class Stop {
  final String id;
  final double lat;
  final double lon;
  final String direction;
  final String name;
  final String code;
  final int locationType;
  final List<String> routeIds;

  Stop({
    required this.id,
    required this.lat,
    required this.lon,
    required this.direction,
    required this.name,
    required this.code,
    required this.locationType,
    required this.routeIds,
  });
}
