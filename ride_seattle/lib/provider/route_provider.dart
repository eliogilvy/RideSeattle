import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../classes/auth.dart';
import '../classes/stop.dart';

import '../classes/favroute.dart';

class RouteProvider with ChangeNotifier {

  var user = Auth().currentUser;
  var favorite_routes;

  List<Stop> stopsForRoute = [];
  Set<Polyline> routePolyLine = {};


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
    routePolyLine.add(
      Polyline(
          polylineId: const PolylineId('current_route'),
          points: routeStops,
          color: Colors.orange,
          width: 4,
          startCap: Cap.squareCap),
    );

    notifyListeners();
  }

  void clearPolylines() {
    routePolyLine.clear();
    notifyListeners();
  }
}
