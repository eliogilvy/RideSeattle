import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/Pages/stop_history.dart';
import 'package:ride_seattle/classes/old_stops.dart';
import 'package:ride_seattle/provider/local_storage_provider.dart';
import 'package:ride_seattle/provider/route_provider.dart';
import 'package:ride_seattle/styles/theme.dart';
import 'Pages/favorites_screen.dart';
import 'provider/state_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/check_auth.dart';
import 'package:flutter/services.dart';

late Box<OldStops> history;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //initialize hive offline storage
  await Hive.initFlutter();
  Hive.registerAdapter(OldStopsAdapter());
  //openboxes
  history = await Hive.openBox('old_stops');

  GeolocatorPlatform locator = GeolocatorPlatform.instance;
  Client client = Client();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => StateInfo(locator: locator, client: client)),
        ChangeNotifierProvider(create: (context) => RouteProvider()),
        ListenableProvider<LocalStorageProvider>(
          create: (context) => LocalStorageProvider(history),
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
      routes: const [],
    ),
    GoRoute(
      path: '/favoriteRoutes',
      builder: (context, state) => const Favorites(),
      routes: const [],
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const StopHistory(),
    )
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
