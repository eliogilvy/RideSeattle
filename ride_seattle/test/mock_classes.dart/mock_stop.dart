import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';
import 'package:ride_seattle/classes/stop.dart';
import 'package:ride_seattle/classes/trip_status.dart';

class MockStop extends Mock implements Stop {

  // final String stopId;
  // final double lat;
  // final double lon;
  // String? direction;
  // final String name;
  // final String code;
  // final int locationType;
  // final List<String> routeIds;
  final Map<String, ArrivalAndDeparture> _arrivalAndDeparture = {};

  // MockStop({
  //   required this.stopId,
  //   required this.lat,
  //   required this.lon,
  //   required this.direction,
  //   required this.name,
  //   required this.code,
  //   required this.locationType,
  //   required this.routeIds,
  // });

  @override
  Future<void> getArrivalAndDeparture() async {
    _arrivalAndDeparture['tripId'] = ArrivalAndDeparture(
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
        position: const LatLng(20, 20),
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
        lastKnownLocation: const LatLng(1, 1),
      ),
    );
  }
}
