import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class LocalStorageProvider extends ChangeNotifier {
  Box favRouteBox;

  LocalStorageProvider({
    required this.favRouteBox,
  });

  List<String> favoriteRoutes = [];

  List<String> getFavoriteRoutes() {
    return favoriteRoutes;
  }

  Future<void> loadData() async {
    favoriteRoutes = favRouteBox.get(0);
    notifyListeners();
  }
  //loadData if exists

  //add a route to favorites
  void addRoute(String routeId) {
    favoriteRoutes.add(routeId);
    updateData();
  }

  //remove route
  void removeRoute(int index) {
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