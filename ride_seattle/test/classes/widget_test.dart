import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/Pages/maps_screen.dart';
import 'package:ride_seattle/provider/local_storage_provider.dart';
import 'package:ride_seattle/provider/route_provider.dart';
import 'package:ride_seattle/provider/state_info.dart';

import '../mock_classes.dart/mock_state_info.dart';

void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();

//   group(
//     'MapScreen',
//     () {
//       testWidgets(
//         'should render a Google Map',
//         (tester) async {
//           await tester.pumpWidget(testWidget(const MapScreen()));

//           final googleMapFinder = find.byType(GoogleMap);

//           expect(googleMapFinder, findsOneWidget);
//         },
//       );

//       testWidgets(
//         'should show a search field',
//         (tester) async {
//           await tester.pumpWidget(testWidget(const MapScreen()));

//           final searchFieldFinder =
//               find.widgetWithText(TextField, 'Search for stops');

//           expect(searchFieldFinder, findsOneWidget);
//         },
//       );
//     },
//   );
// }

// Widget testWidget(Widget test) {
//   final _router = GoRouter(
//     initialLocation: '/',
//     routes: [
//       GoRoute(
//         path: '/',
//         builder: (context, state) => test,
//         routes: const [],
//       ),
//     ],
//   );
//   return MultiProvider(
//     providers: [
//       ChangeNotifierProvider<StateInfo>(create: (context) => MockStateInfo()),
//       ChangeNotifierProvider<RouteProvider>(create: (context) => RouteProvider()),
//       //ChangeNotifierProvider<LocalStorageProvider>(create: (context) => LocalStorageProvider()),
//     ],
//     child: MaterialApp.router(
//       title: 'Ride App',
//       routerConfig: _router,
//     ),
//   );
}
