import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:ride_seattle/classes/fav_route.dart';
import 'package:ride_seattle/classes/old_stops.dart';
import 'package:ride_seattle/classes/trip_status.dart';
import 'package:xml/xml.dart';
import '../OneBusAway/routes.dart';
import '../classes/stop.dart';
import 'dart:math';
import 'package:ride_seattle/classes/route.dart' as r;

class StateInfo with ChangeNotifier {
  StateInfo({required this.locator, required this.client}) {
    getPosition();
  }

  Client client;
  GeolocatorPlatform locator;
  String _radius = "0";
  late Position _position;
  //final Map<String, Agency> _agencies = {};
  final Map<String, Stop> _stops = {};
  final Map<String, r.Route> _routes = {};
  final Map<String, Marker> _markers = {};
  final Map<String, Circle> _circles = {};
  bool showMarkerInfo = false;
  bool showVehicleInfo = false;
  Stop? _currentStopInfo;
  String? _routeFilter;
  String? lastVehicle;
  TripStatus? vehicleStatus;

  Set<Circle> get circles => _circles.values.toSet();
  Set<Marker> get markers => _markers.values.toSet();
  List<Stop> get stops => _stops.values.toList();
  List<r.Route> get routes {
    List<r.Route> routeList = _routes.values.toList();
    routeList.sort((a, b) {
      if (a.shortName == null) {
        return 1; // `a` should come after `b`
      } else if (b.shortName == null) {
        return -1; // `a` should come before `b`
      } else {
        bool isANumber = int.tryParse(a.shortName!) != null;
        bool isBNumber = int.tryParse(b.shortName!) != null;

        if (!isANumber && !isBNumber) {
          // Both elements are not numbers, compare them directly
          return a.shortName!.compareTo(b.shortName!);
        } else if (isANumber && isBNumber) {
          // Both elements are numbers, compare them as numbers
          return int.parse(a.shortName!).compareTo(int.parse(b.shortName!));
        } else {
          // One element is a number, the other is not. The non-number element should be after the number element
          return isANumber ? -1 : 1;
        }
      }
    });

    return routeList;
  }

  Position get position => _position;
  String get radius => _radius;
  Stop? get currentStopInfo => _currentStopInfo;

  void addCircle(LatLng position, String id) {
    _circles[id] = Circle(
      circleId: const CircleId("id"),
      center: position,
      radius: double.parse(_radius), // convert to meters
      fillColor: Colors.blue.withOpacity(0.1),
      strokeWidth: 1,
      strokeColor: Colors.blue,
    );
    notifyListeners();
  }

  void setRadius(LatLng center, LatLng top, LatLng bottom) {
    const earthRadius = 6371000; // Earth's mean radius in kilometers
    final lat1 = center.latitude * pi / 180;
    final lat2 = top.latitude * pi / 180;

    final dLat = (top.latitude - center.latitude) * pi / 180;
    final dLng = (top.longitude - center.longitude) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = earthRadius * c;

    _radius = distance.toString();
    notifyListeners();
  }

  Future<List<LatLng>> getRoutePolyline(String routeId) async {
    //assign make sure not to have old stops included in a different route
    List<LatLng> points = [];

    Response res =
        await client.get(Uri.parse(Routes.getStopsForRoute(routeId)));

    var document = XmlDocument.parse(res.body);
    var polylines = document.findAllElements('encodedPolyline').first;
    var point = polylines.findElements('points').first.text;
    final coords = PolylinePoints().decodePolyline(point);
    for (var coord in coords) {
      points.add(LatLng(coord.latitude, coord.longitude));
    }

    return points;
  }

  void updateStops() {
    _markers.clear();
    _stops.removeWhere((key, value) => !value.routeIds.contains(_routeFilter));
    var filepath = 'assets/images/stops/bus-stop.png';
    for (var stop in _stops.values) {
      if (stop.direction != null) {
        filepath = 'assets/images/stops/bus-stop-${stop.direction}.png';
      }
      addMarker(
          stop.stopId, stop.name, LatLng(stop.lat, stop.lon), getMarkerInfo,
          iconFilepath: filepath);
    }
    notifyListeners();
  }

  Future<void> getStopsForLocation(String lat, String lon) async {
    Response res = await client
        .get(Uri.parse(Routes.getStopsForLocation(lat, lon, _radius)));
    final document = XmlDocument.parse(res.body);
    var stops = document.findAllElements('stop');
    for (var stop in stops) {
      _addStop(stop);
    }
  }

  void _addStop(XmlElement stop) {
    var id = stop.findElements("id").first.text;
    var lat = double.parse(stop.findElements("lat").first.text);
    var lon = double.parse(stop.findElements("lon").first.text);
    String? direction;
    try {
      direction = stop.findElements("direction").first.text;
    } catch (e) {
      if (e is StateError) {
        direction = null;
      }
    }
    var name = stop.findElements("name").first.text;
    var routeIds = stop
        .findElements("routeIds")
        .first
        .findElements("routeId")
        .map((e) => e.text)
        .toList();
    if (_routeFilter == null || routeIds.contains(_routeFilter)) {
      _stops[id] = parseStop(stop);
      var filePath = 'assets/images/stops/bus-stop.png';
      if (direction != null) {
        filePath = 'assets/images/stops/bus-stop-$direction.png';
      }
      addMarker(id, name, LatLng(lat, lon), getMarkerInfo,
          iconFilepath: filePath);
    }
  }

  Stop parseStop(XmlElement stop) {
    var id = stop.findElements("id").first.text;
    var lat = double.parse(stop.findElements("lat").first.text);
    var lon = double.parse(stop.findElements("lon").first.text);
    String? direction;
    try {
      direction = stop.findElements("direction").first.text;
    } catch (e) {
      if (e is StateError) {
        direction = null;
      }
    }
    var name = stop.findElements("name").first.text;
    var code = stop.findElements("code").first.text;
    var locationType = int.parse(stop.findElements("locationType").first.text);
    var routeIds = stop
        .findElements("routeIds")
        .first
        .findElements("routeId")
        .map((e) => e.text)
        .toList();

    return Stop(
        stopId: id,
        lat: lat,
        lon: lon,
        direction: direction,
        name: name,
        code: code,
        locationType: locationType,
        routeIds: routeIds);
  }

  Future<void> getRoutesForLocation(String lat, String lon) async {
    Response res = await client
        .get(Uri.parse(Routes.getRoutesForLocation(lat, lon, _radius)));
    final document = XmlDocument.parse(res.body);
    final routes = document.findAllElements('route');
    for (var route in routes) {
      _createRoute(route);
    }
  }

  Future<String> getStop(String id) async {
    Stop? stop;
    if (_stops.containsKey(id)) {
      stop = _stops[id]!;
    } else {
      Response res = await client.get(Uri.parse(Routes.getStop(id)));

      var document = XmlDocument.parse(res.body);
      var s = document.findAllElements('stop');
      stop = parseStop(s.first);
      _stops[stop.stopId] = stop;
    }
    return stop.name;
  }

  void _createRoute(XmlElement route) {
    final id = route.findElements('id').first.text;
    String? shortName;

    try {
      shortName = route.findElements('shortName').first.text;
    } catch (e) {
      if (e is StateError) shortName = null;
    }

    String? description;
    try {
      description = route.findElements('description').first.text;
    } catch (e) {
      if (e is StateError) description = null;
    }

    final type = route.findElements('type').first.text;
    String? url;
    try {
      url = route.findElements('url').first.text;
    } catch (e) {
      if (e is StateError) url = null;
    }

    final agencyId = route.findElements('agencyId').first.text;

    _routes[id] = r.Route(
        routeId: id,
        shortName: shortName,
        description: description,
        type: type,
        url: url,
        agencyId: agencyId);
  }

  set routeFilter(String? filter) {
    _routeFilter = filter;
  }

  Future<void> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await locator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await locator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await locator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location Permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission denied permanently");
    }

    _position = await locator.getCurrentPosition();
    notifyListeners();
  }

  Future<BitmapDescriptor> _getImage(String filePath) async {
    return await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), filePath);
  }

  Future<void> addMarker(
      String id, String name, LatLng location, Function(String) function,
      {String? iconFilepath, double? x, double? y}) async {
    BitmapDescriptor markerIcon;
    iconFilepath ??= 'assets/images/icons8-location-pin-66.png';
    try {
      markerIcon = await _getImage(iconFilepath);
    } catch (e) {
      markerIcon = await _getImage(iconFilepath);
    }

    var marker = Marker(
      markerId: MarkerId(id),
      position: location,
      //infoWindow: markerWindow(name),
      icon: markerIcon,
      onTap: () async {
        function(id);
        if (iconFilepath != 'assets/images/bus.png' &&
            !iconFilepath!.contains('marked')) {
          _markers.remove("current");
          String markerFilePath =
              iconFilepath.substring(0, iconFilepath.indexOf('.'));
          markerFilePath = "$markerFilePath-marked.png";

          Box<OldStops> box = await Hive.openBox('old_stops');
          await box.put(
            id,
            OldStops(
              stopId: id,
              name: name,
              lon: location.longitude,
              lat: location.latitude,
            ),
          );

          addMarker("current", name, location, (p0) => null,
              iconFilepath: markerFilePath, x: 0.5, y: 0.8);
        }
      },
      anchor: const Offset(0.0, 0.0),
    );
    _markers[id] = marker;
    notifyListeners();
  }

  void removeMarker(String? id) {
    if (id != null) {
      _markers.remove(id);
    }
  }

  Future<void> getVehicleInfo(String id) async {
    showMarkerInfo = false;
    showVehicleInfo = true;
    //await getTripInfo(id);
    notifyListeners();
  }

  Future<void> getMarkerInfo(String id) async {
    showVehicleInfo = false;
    showMarkerInfo = true;
    _currentStopInfo = _stops[id]!;
    await _currentStopInfo!.getArrivalAndDeparture(client);
  }

  //void _loadStops() {}

  // Future<void> getAgencies() async {
  //   Response res = await get(Uri.parse(Routes.getAgencies()));
  //   final document = XmlDocument.parse(res.body);
  //   for (var agency in document.findAllElements('agency')) {
  //     final id = agency.findElements('id');
  //     final name = agency.findElements('name');
  //     final url = agency.findElements('url');
  //     final timezone = agency.findElements('timezone');
  //     final lang = agency.findElements('lang');
  //     var phone;
  //     var fareUrl;
  //     try {
  //       phone = agency.findElements('phone').first.text;
  //     } catch (e) {
  //       if (e is StateError) phone = null;
  //     }
  //     try {
  //       fareUrl = agency.findElements('fareUrl').first.text;
  //     } catch (e) {
  //       if (e is StateError) fareUrl = null;
  //     }
  //     final privateService = agency.findElements('privateService');
  //     _agencies[id.first.text] = Agency(
  //       agencyId: id.first.text,
  //       name: name.first.text,
  //       url: url.first.text,
  //       timezone: timezone.first.text,
  //       lang: lang.first.text,
  //       phone: phone,
  //       fareUrl: fareUrl,
  //       privateService: bool.fromEnvironment(privateService.first.text),
  //     );
  //   }
  // }
}
