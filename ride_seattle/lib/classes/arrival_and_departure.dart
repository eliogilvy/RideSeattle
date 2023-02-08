class ArrivalAndDeparture {
  final String routeId;
  final String tripId;
  final int serviceDate;
  final String stopId;
  final int stopSequence;
  final int blockTripSequence;
  final String routeShortName;
  final String routeLongName;
  final String tripHeadsign;
  final bool arrivalEnabled;
  final bool departureEnabled;
  final int scheduledArrivalTime;
  final int scheduledDepartureTime;
  final String frequency;
  final bool predicted;
  final int predictedArrivalTime;
  final int predictedDepartureTime;
  final double distanceFromStop;
  final int numberOfStopsAway;
  final String tripStatus;

  ArrivalAndDeparture({
    required this.routeId,
    required this.tripId,
    required this.serviceDate,
    required this.stopId,
    required this.stopSequence,
    required this.blockTripSequence,
    required this.routeShortName,
    required this.routeLongName,
    required this.tripHeadsign,
    required this.arrivalEnabled,
    required this.departureEnabled,
    required this.scheduledArrivalTime,
    required this.scheduledDepartureTime,
    required this.frequency,
    required this.predicted,
    required this.predictedArrivalTime,
    required this.predictedDepartureTime,
    required this.distanceFromStop,
    required this.numberOfStopsAway,
    required this.tripStatus,
  });
}