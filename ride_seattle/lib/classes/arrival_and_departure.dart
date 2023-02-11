import 'package:ride_seattle/classes/trip_status.dart';

class ArrivalAndDeparture {
  final String routeId;
  final String tripId;
  final int serviceDate;
  final String stopId;
  final int stopSequence;
  final int blockTripSequence;
  final String routeShortName;
  final String tripHeadsign;
  final bool arrivalEnabled;
  final bool departureEnabled;
  final int scheduledArrivalTime;
  final int scheduledDepartureTime;
  final bool predicted;
  final int predictedArrivalTime;
  final int predictedDepartureTime;
  final double distanceFromStop;
  final int numberOfStopsAway;
  final TripStatus? tripStatus;

  ArrivalAndDeparture({
    required this.routeId,
    required this.tripId,
    required this.serviceDate,
    required this.stopId,
    required this.stopSequence,
    required this.blockTripSequence,
    required this.routeShortName,
    required this.tripHeadsign,
    required this.arrivalEnabled,
    required this.departureEnabled,
    required this.scheduledArrivalTime,
    required this.scheduledDepartureTime,
    required this.predicted,
    required this.predictedArrivalTime,
    required this.predictedDepartureTime,
    required this.distanceFromStop,
    required this.numberOfStopsAway,
    this.tripStatus,
  });
}
