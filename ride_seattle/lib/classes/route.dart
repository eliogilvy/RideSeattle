class Route {
  final String routeId;
  String? shortName;
  String? description;
  final String type;
  String? url;
  final String agencyId;

  Route({
    required this.routeId,
    required this.shortName,
    required this.type,
    required this.description,
    required this.url,
    required this.agencyId,
  });
}
