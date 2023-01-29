import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:ride_seattle/classes/agency.dart';
import 'package:xml/xml.dart';
import '../OneBusAway/routes.dart';
import '../classes/stop.dart';
import 'dart:math';

class StateInfo with ChangeNotifier {
  StateInfo() {
    getPosition();
  }

  final String _radius = "5000";
  late Position _position;
  final Map<String, Agency> _agencies = {};
  final Map<String, Stop> _stops = {};
  final Map<String, Route> _routes = {};
  final Map<String, Marker> _markers = {};

  Set<Marker> get markers => _markers.values.toSet();
  List<Stop> get stops => _stops.values.toList();
  List<Route> get routes => _routes.values.toList();
  Position get position => _position;

  Future<double> setRadius(LatLng center, LatLng top, LatLng bottom) async {
    final earthRadius = 6371000; // Earth's mean radius in kilometers
    final lat1 = center.latitude * pi / 180;
    final lat2 = top.latitude * pi / 180;
    final lng1 = center.longitude * pi / 180;
    final lng2 = top.longitude * pi / 180;

    final dLat = (top.latitude - center.latitude) * pi / 180;
    final dLng = (top.longitude - center.longitude) * pi / 180;

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = earthRadius * c;

    print("distance is: $distance");

    return distance;
  }

  Future<void> getStopsForLocation(String lat, String lon) async {
    Response res =
        await get(Uri.parse(Routes.getStopsForLocation(lat, lon, _radius)));
    final document = XmlDocument.parse(res.body);
    var stops = document.findAllElements('stop');
    for (var stop in stops) {
      var id = stop.findElements("id").first.text;
      var lat = double.parse(stop.findElements("lat").first.text);
      var lon = double.parse(stop.findElements("lon").first.text);
      var direction;
      try {
        direction = stop.findElements("direction").first.text;
      } catch (e) {
        if (e is StateError) {
          direction = null;
        }
      }
      var name = stop.findElements("name").first.text;
      var code = stop.findElements("code").first.text;
      var locationType =
          int.parse(stop.findElements("locationType").first.text);
      var routeIds = stop
          .findElements("routeIds")
          .first
          .findElements("routeId")
          .map((e) => e.text)
          .toList();
      _stops[id] = Stop(
        stopId: id,
        lat: lat,
        lon: lon,
        direction: direction,
        name: name,
        code: code,
        locationType: locationType,
        routeIds: routeIds,
      );
      addMarker(id, LatLng(lat, lon),
          icon_filepath: 'assets/images/icons8-bus-stop-64.png');
    }
  }

  Future<void> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location Permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission denied permanently");
    }

    _position = await Geolocator.getCurrentPosition();
  }

  Future<void> addMarker(String id, LatLng location,
      {String? icon_filepath}) async {
    BitmapDescriptor markerIcon;

    if (icon_filepath != null) {
      markerIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), icon_filepath);
    } else {
      markerIcon = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          'assets/images/icons8-location-pin-66.png');
    }
    var marker = Marker(
        markerId: MarkerId(id),
        position: location,
        infoWindow: const InfoWindow(
            title: 'Location of thing', snippet: 'Some Description'),
        icon: markerIcon);

    _markers[id] = marker;
    notifyListeners();
  }

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
