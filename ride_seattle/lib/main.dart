import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'provider/state_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/check_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var stateInfo = StateInfo();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: stateInfo),
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
      routes: [],
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
    );
  }
}
