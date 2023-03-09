class favRoute {
  final String routeId;
  final String routeName;

  favRoute({required this.routeId, required this.routeName});

  factory favRoute.fromJson(Map<String, dynamic> json) =>
      favRoute(routeId: json['route_id'], routeName: json['route_name']);
}
