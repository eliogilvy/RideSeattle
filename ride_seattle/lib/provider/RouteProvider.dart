import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../classes/stop.dart';

class RouteProvider with ChangeNotifier {
  List<Stop> stopsForRoute = [];

  Set<Polyline> routePolyLine = {};
  List<LatLng> latlng_of_route = [];

  void addItem(Stop stop) {
    stopsForRoute.add(stop);
    notifyListeners();
  }

  void assignStops(List<Stop> stops) {
    stopsForRoute = stops;
    notifyListeners();
  }

  List<Stop> getStops() {
    return stopsForRoute;
  }

  void setPolyLines(List<LatLng> routeStops) {
    // for (var stop in stopsForRoute) {
    //   latlng_of_route.add(LatLng(stop.lat, stop.lon));
    // }

    routePolyLine.add(
      Polyline(
        polylineId: const PolylineId('current_route'),
        points: routeStops,
        color: Colors.orange,
        width: 3,
      ),
    );
    print('added lines');

    notifyListeners();
  }
}
