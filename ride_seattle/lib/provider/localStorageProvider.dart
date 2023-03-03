

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:ride_seattle/classes/LatLng_custom.dart';

class localStorageProvider extends ChangeNotifier {
  Box favRouteBox;

  localStorageProvider({
      required this.favRouteBox,
  });

  List<List<LatLng_custom>> favoriteRoutes =[];


  List<List<LatLng_custom>> getFavoriteRoutes() {
    return favoriteRoutes;
  }

  Future<void> loadData() async{
    favoriteRoutes = favRouteBox.get(0).cast<List<LatLng_custom>>();
    notifyListeners();
  }
  //loadData if exists


  //add a route to favorites
  void addRoute(List<LatLng> routeStops){

    List<LatLng_custom> routeStops_custom = [];

    for (LatLng stop in routeStops){
      routeStops_custom.add(LatLng_custom(Latitude: stop.latitude,
          Longitude: stop.longitude));
    }

    favoriteRoutes.add(routeStops_custom);
    updateData();
  }

  //remove route
  void removeRoute(int index){
    print("ROUTE TRYING TO REMOVE");
    print(favoriteRoutes);
    favoriteRoutes.removeAt(index);
    updateData();
  }

  Future<void> updateData() async {
    favRouteBox.put(0, favoriteRoutes);
    notifyListeners();
  }




}