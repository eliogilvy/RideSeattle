import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

import '../classes/old_stops.dart';

class LocalStorageProvider extends ChangeNotifier {
  late Box<OldStops> history;

  LocalStorageProvider(Box<OldStops> h) {
    history = h;
  }

  //List<OldStops> get history async => await _history.all;

  // Future<void> loadData() async {
  //   _history = favRouteBox.get(0);
  //   notifyListeners();
  // }
  //loadData if exists

  //add a route to favorites
  // void addStop(String stopId, LatLng coord) {
  //   _history.add(OldStops(stopId: stopId, coord: coord));
  //   updateData();
  // }

  //remove route
  // void removeRoute(int index) {
  //   print("ROUTE TRYING TO REMOVE");
  //   print(favoriteRoutes);
  //   favoriteRoutes.removeAt(index);
  //   updateData();
  // }

  // Future<void> updateData() async {
  //   _history.put(0, favoriteRoutes);
  //   notifyListeners();
  // }
}
