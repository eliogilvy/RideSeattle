import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';

import '../provider/local_storage_provider.dart';
import '../provider/route_provider.dart';
import '../provider/state_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/auth.dart';
import '../classes/fav_route.dart';
import '../widgets/route_tile.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Routes'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          StreamBuilder<List<dynamic>>(
            stream: fire.routeList,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              } else if (snapshot.hasData) {
                final routes = snapshot.data!;
                return Expanded(
                  child: SingleChildScrollView(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      children: List.generate(routes.length, (index) {
                        var routeName = routes[index].routeName;
                        var routeId = routes[index].routeId;
                        return RouteTile(
                            routeName: routeName, routeId: routeId);
                      }),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
