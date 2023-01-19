import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:ride_seattle/OneBusAway/test_data.dart';
import 'package:ride_seattle/Pages/maps.dart';
import 'package:ride_seattle/Pages/sign_in.dart';

import 'homescreen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final routerDelegate = BeamerDelegate(
      locationBuilder: RoutesLocationBuilder(
        routes: {
          "/": (context, state, data) => const HomeScreen(),
        },
      ),
    );
    return MaterialApp.router(
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
    );
  }
}
