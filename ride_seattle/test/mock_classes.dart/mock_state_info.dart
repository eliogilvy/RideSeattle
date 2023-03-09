import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';
import 'package:ride_seattle/classes/stop.dart';
import 'package:ride_seattle/classes/trip_status.dart';
import 'package:ride_seattle/provider/state_info.dart';
import 'package:ride_seattle/classes/route.dart' as r;

class MockStateInfo extends Mock implements StateInfo {
  MockStateInfo() {
    getPosition();
    _addMarker();
    print(_markers);
  }
  @override
  Future<void> getPosition() async {
    _position = Position(
      longitude: 47.6219,
      latitude: -122.3517,
      timestamp: DateTime(2023),
      accuracy: 3,
      altitude: 4,
      heading: 5,
      speed: 6,
      speedAccuracy: 7,
    );
  }

  @override
  Set<Circle> get circles => _circles.values.toSet();
  @override
  Set<Marker> get markers => _markers.values.toSet();
  @override
  List<Stop> get stops => _stops.values.toList();
  @override
  List<r.Route> get routes => _routes.values.toList();
  @override
  Position get position => _position;
  @override
  String get radius => _radius;
  @override
  Stop get currentStopInfo => _currentStopInfo;

  final String _radius = "0";
  late Position _position;
  //final Map<String, Agency> _agencies = {};
  final Map<String, Stop> _stops = {};
  final Map<String, r.Route> _routes = {};
  final Map<String, Marker> _markers = {};
  final Map<String, Circle> _circles = {};
  late Stop _currentStopInfo;

  @override
  Future<List<LatLng>> getRoutePolyline(String routeId) async {
    return [const LatLng(47.6219, -122.3517)];
  }

  void _addMarker() {
    _markers['test marker'] = const Marker(
        markerId: MarkerId('test marker'),
        position: LatLng(47.6219, -122.3517));
  }

  @override
  void getStopsForLocation(String lat, String lon) async {
    addMarker(
      "Test marker",
      "Test marker",
      const LatLng(47.6219, -122.3517),
      (p0) => null,
    );
  }

  @override
  Future<void> getRoutesForLocation(String lat, String lon) async {
    _routes['1'] = r.Route(
      routeId: 'routeId',
      shortName: 'Test route',
      description: 'This is a test',
      type: 'Test type',
      url: 'Test url',
      agencyId: 'agencyId',
    );
  }

  @override
  Future<void> getMarkerInfo(String id) async {
    _currentStopInfo = Stop(
        stopId: 'stopId',
        lat: 1,
        lon: 2,
        direction: 'north',
        name: 'Test stop',
        code: 'Test code',
        locationType: 3,
        routeIds: ['routeId']);
    _currentStopInfo.arrivalAndDeparture['routeId'] = ArrivalAndDeparture(
      routeId: 'routeId',
      tripId: 'tripId',
      serviceDate: 1,
      stopId: 'stopId',
      stopSequence: 2,
      blockTripSequence: 3,
      routeShortName: 'Test route',
      tripHeadsign: 'tripHeadsign',
      arrivalEnabled: true,
      departureEnabled: false,
      scheduledArrivalTime: 4,
      scheduledDepartureTime: 5,
      predicted: true,
      predictedArrivalTime: 6,
      predictedDepartureTime: 7,
      distanceFromStop: 8,
      numberOfStopsAway: 9,
      tripStatus: TripStatus(
        activeTripId: 'tripId',
        blockTripSequence: 1,
        serviceDate: 2,
        scheduledDistanceAlongTrip: 3,
        totalDistanceAlongTrip: 4,
        position: const LatLng(47.6219, -122.3517),
        orientation: 5,
        closestStop: 'stopId',
        closestStopTimeOffset: 6,
        nextStop: 'stopId',
        nextStopTimeOffset: 7,
        phase: 'phase',
        status: 'status',
        predicted: true,
        lastUpdateTime: 8,
        lastLocationUpdateTime: 9,
        lastKnownLocation: const LatLng(47.6219, -122.3517),
      ),
    );
  }
}
