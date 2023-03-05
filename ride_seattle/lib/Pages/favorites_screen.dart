import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../provider/local_storage_provider.dart';
import '../provider/route_provider.dart';
import '../provider/state_info.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late LocalStorageProvider localStorage;
  late List<String> favoriteRoutes;

  late StateInfo stateInfo;
  late RouteProvider routeProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onAfterBuild(context));
  }

  void _onAfterBuild(BuildContext context) {
    localStorage = Provider.of<LocalStorageProvider>(context, listen: false);
    stateInfo = Provider.of<StateInfo>(context, listen: false);
    routeProvider = Provider.of<RouteProvider>(context, listen: false);

    try {
      localStorage.loadData();
    } catch (e) {
      print(e.toString());
    }

    favoriteRoutes = localStorage.getFavoriteRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Routes'),
        ),
        body: Column(
          children: [
            Consumer<LocalStorageProvider>(
                builder: (context, provider, listTile) {
              if (favoriteRoutes == null) {
                return const SizedBox(
                  width: 200.0,
                  height: 300.0,
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    key: const Key('favorite_routes'),
                    itemCount: favoriteRoutes.length,
                    itemBuilder: buildList,
                  ),
                );
              }
            }),
          ],
        ));
  }

  Widget buildList(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Visibility(
        visible: true,
        child: Dismissible(
          key: UniqueKey(),
          background: trashBackground(),
          onDismissed: (direction) {
            //taskOrder.removeWhere((item) => item.id == taskOrder[index].id.toString());
            localStorage.removeRoute(index);
          },
          child: InkWell(
            onTap: () async {
              //highlight the route
              String routeId = favoriteRoutes[index];

              stateInfo.routeFilter = routeId;
              stateInfo.updateStops();

              routeProvider.setPolyLines(
                await stateInfo.getRoutePolyline(routeId),
              );
              //navigate to the home page
              // ignore: use_build_context_synchronously
              context.pop();
              // ignore: use_build_context_synchronously
              context.pop();
            },
            child: ListTile(
              //replace with name of stop/route
              title: Text('Fav Route #$index'),
              subtitle: Text('$index'),
            ),
          ),
        ),
      ),
    );
  }

  Widget trashBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
