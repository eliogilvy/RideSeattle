import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripStatus {
  String activeTripId;
  int blockTripSequence;
  int serviceDate;
  double scheduledDistanceAlongTrip;
  double totalDistanceAlongTrip;
  LatLng position;
  double orientation;
  String closestStop;
  int closestStopTimeOffset;
  String nextStop;
  int nextStopTimeOffset;
  String phase;
  String status;
  bool predicted;
  int lastUpdateTime;
  int lastLocationUpdateTime;
  LatLng? lastKnownLocation;
  //double distanceAlongTrip;
  //int scheduleDeviation;
  //String vehicleId;

  TripStatus({
    required this.activeTripId,
    required this.blockTripSequence,
    required this.serviceDate,
    required this.scheduledDistanceAlongTrip,
    required this.totalDistanceAlongTrip,
    required this.position,
    required this.orientation,
    required this.closestStop,
    required this.closestStopTimeOffset,
    required this.nextStop,
    required this.nextStopTimeOffset,
    required this.phase,
    required this.status,
    required this.predicted,
    required this.lastUpdateTime,
    required this.lastLocationUpdateTime,
    required this.lastKnownLocation,
  });
}
