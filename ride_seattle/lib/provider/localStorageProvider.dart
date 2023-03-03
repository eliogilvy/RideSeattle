import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class localStorageProvider extends ChangeNotifier {
  Box favRouteBox;

  localStorageProvider({
    required this.favRouteBox,
  });

  List<int> favoriteRoutes =[];


  List<int> getFavoriteRoutes() {
    return favoriteRoutes;
  }

  Future<void> loadData() async{
    favoriteRoutes = favRouteBox.get(0);
    notifyListeners();
  }
  //loadData if exists


  //add a route to favorites
  void addRoute(int routeId){

    favoriteRoutes.add(routeId);

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