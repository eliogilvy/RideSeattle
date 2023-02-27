import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';


import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ride_seattle/Pages/favorited_routes.dart';
import 'package:ride_seattle/provider/localStorageProvider.dart';

import 'Pages/check_auth.dart';
import 'package:ride_seattle/Pages/maps_screen.dart';
import 'package:ride_seattle/provider/RouteProvider.dart';
import 'package:ride_seattle/styles/theme.dart';
import 'provider/state_info.dart';


late Box favRouteBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //initialize hive offline storage
  await Hive.initFlutter();
  //Hive adapter for route information

  //openboxes
  favRouteBox = await Hive.openBox('favorite_routes');


  var stateInfo = StateInfo();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: stateInfo),
        ChangeNotifierProvider(create: (context) => RouteProvider()),
        ListenableProvider<localStorageProvider>(create: (context) =>
            localStorageProvider(
                favRouteBox: favRouteBox)
        ),

      ],
      child: const RideApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const CheckAuth(),
      routes: [
      ],
    ),
    GoRoute(
      path: '/favoriteRoutes',
      builder: (context, state) => const favorites_page(),
      routes: const [],
    ),


  ],
);

class RideApp extends StatelessWidget {
  const RideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ride App',
      routerConfig: _router,
      theme: RideSeattleTheme.theme(),
    );
  }
}
