class Vehicle {
  final String vehicleId;
  final String lastUpdateTime;
  final String lastLocationUpdateTime;
  final String lat;
  final String lon;
  final String tripId;
  final String tripStatus;

  Vehicle({
    required this.vehicleId,
    required this.lastUpdateTime,
    required this.lastLocationUpdateTime,
    required this.lat,
    required this.lon,
    required this.tripId,
    required this.tripStatus,
  });
}
