class FavoriteRoute {
  final String routeId;
  final String routeName;

  FavoriteRoute({required this.routeId, required this.routeName});

  Map<String, dynamic> toJson() {
    return {'route_id': routeId, 'route_name': routeName};
  }

  factory FavoriteRoute.fromJson(Map<String, dynamic> json) =>
      FavoriteRoute(routeId: json['route_id'], routeName: json['route_name']);
}
