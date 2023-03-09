class favRoute {
  final String routeId;

  favRoute({required this.routeId});

  factory favRoute.fromJson(Map<String, dynamic> json) =>
      favRoute(routeId: json['route_id']);
}
