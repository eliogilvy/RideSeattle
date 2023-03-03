import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ride_seattle/provider/route_provider.dart';
import 'package:ride_seattle/styles/theme.dart';
import 'provider/state_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/check_auth.dart';
import 'package:flutter/services.dart';

import 'package:ride_seattle/provider/localStorageProvider.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box favRouteBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  //initialize hive offline storage
  await Hive.initFlutter();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StateInfo()),
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
