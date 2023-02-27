

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';

class localStorageProvider extends ChangeNotifier {
  Box favRouteBox;

  localStorageProvider({
      required this.favRouteBox,
  });

  List<List<LatLng>> favoriteRoutes =[];


  List<List<LatLng>> getFavoriteRoutes() {
    return favoriteRoutes;
  }

  Future<void> loadData() async{
    favoriteRoutes = favRouteBox.get(0);
    notifyListeners();
  }
  //loadData if exists


  //add a route to favorites
  void addRoute(List<LatLng> routeStops){
    favoriteRoutes.add(routeStops);
    updateData();
  }

  //remove route
  void removeRoute(int index){
    favoriteRoutes.removeAt(index);
    updateData();
  }

  Future<void> updateData() async {
    favRouteBox.put(0, favoriteRoutes);
    notifyListeners();
  }




}