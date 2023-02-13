import 'package:flutter/foundation.dart';
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

  void assignStops(List<Stop> stops)
  {
    stopsForRoute = stops;
    notifyListeners();
  }

  List<Stop> getStops () {
    return stopsForRoute;
  }

  void setPolyLines(){
    for(var stop in stopsForRoute){
      latlng_of_route.add(LatLng(stop.lat, stop.lon));
    }


    print("WTF are the stops latlng");
    print(latlng_of_route);

    routePolyLine.add(
        Polyline(
          polylineId: const PolylineId('current_route'),
          points:latlng_of_route,
          color: Colors.orange,
        )
    );

    notifyListeners();

  }

}
