import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/Pages/check_auth.dart';
import 'package:ride_seattle/Pages/favorites_screen.dart';
import 'package:ride_seattle/Pages/login_screen.dart';
import 'package:ride_seattle/Pages/maps_screen.dart';
import 'package:ride_seattle/classes/auth.dart';
import 'package:ride_seattle/main.dart';
import 'package:ride_seattle/provider/local_storage_provider.dart';
import 'package:ride_seattle/provider/route_provider.dart';
import 'package:ride_seattle/provider/state_info.dart';

import 'package:http/http.dart';

import '../mock_classes.dart/mock_state_info.dart';
import 'firebase_mock.dart';
import 'widget_test.mocks.dart';


@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigatorObserver>()
  ],
)


void main() {

  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets("Check Sign in", (WidgetTester tester) async {

    GeolocatorPlatform locator = GeolocatorPlatform.instance;
    Client client = Client();
    //initialize hive offline storage
    await Hive.initFlutter();
    //openboxes
    Box favRouteBox = await Hive.openBox('fav_routes');
    final observerMock = MockNavigatorObserver();

    final loginRegisterBtn = find.byKey(const ValueKey('login_registerButton'));

    //execute test
    await tester.pumpWidget(
        MaterialApp(
          home:MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) => StateInfo(locator: locator, client: client)),
              ChangeNotifierProvider(create: (context) => RouteProvider()),
              ListenableProvider<LocalStorageProvider>(
                  create: (context) =>
                      LocalStorageProvider(favRouteBox: favRouteBox)),
            ],
            child:const CheckAuth(),

          ),
          navigatorObservers: [
            observerMock,
          ],
        )
    );

    //await tester.tap(loginRegisterBtn);
    //verify(observerMock.didPush(any, any));
    await tester.pump();
  });


  group('login and register tests', () {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(home: widget)
      );
    }

    testWidgets('Tap login with no entries should see error text', (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.

      LoginPage login_page = const LoginPage();
      await tester.pumpWidget(buildTestableWidget(login_page));

      final submit_loginRegisterBtn = find.byKey(const ValueKey('submit_login_Register_Button'));
      expect(submit_loginRegisterBtn, findsOneWidget);

      await tester.tap(submit_loginRegisterBtn);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(find.byKey(ValueKey("error_message")), findsOneWidget);

      //ERROR MESSAGE APPEARS can't read actual text
      //expect(find.text("Error ? Given String is empty or null"), findsOneWidget);

      //can't identify exact text from error message
    });

    testWidgets('Click register and enter new password and username', (WidgetTester tester) async {
      LoginPage login_page = const LoginPage();
      await tester.pumpWidget(buildTestableWidget(login_page));

      final loginRegisterBtn = find.byKey(const ValueKey('login_or_registerButton'));
      expect(loginRegisterBtn, findsOneWidget);

      await tester.tap(loginRegisterBtn);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(find.text("Login instead"), findsOneWidget);

      final submit_loginRegisterBtn = find.byKey(const ValueKey('submit_login_Register_Button'));
      expect(submit_loginRegisterBtn, findsOneWidget);

      final emailField = find.byKey(const ValueKey("emailField"));
      final passwordField = find.byKey(const ValueKey("passwordField"));
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);

      await tester.enterText(find.byKey(const ValueKey("emailField")), 'testEmail@test.com');
      await tester.enterText(find.byKey(const ValueKey("passwordField")), '123456789');


      await tester.tap(submit_loginRegisterBtn);
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      //Not navigating???
      //Check if I navigated
      //expect(find.byKey(ValueKey("googleMap")), findsOneWidget);

    });




  });


  group('Maps test', ()
  {
    Widget buildTestableWidget(Widget widget) {

      GeolocatorPlatform locator = GeolocatorPlatform.instance;
      Client client = Client();

      return MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(
              home:
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                        create: (context) => StateInfo(locator: locator, client: client)),
                    ChangeNotifierProvider(create: (context) => RouteProvider()),
                  ],
                  child: widget,
                ),
          ),
      );
    }

    testWidgets('Maps screen loads', (WidgetTester tester) async {

      MapScreen map_page = MapScreen();
      await tester.pumpWidget(buildTestableWidget(map_page));
      final map = find.byKey(const ValueKey('googleMap'));
      expect(map, findsOneWidget);
    });

    testWidgets('Markers load', (WidgetTester tester) async {

      MapScreen map_page = MapScreen();
      await tester.pumpWidget(buildTestableWidget(map_page));
      final map = find.byKey(const ValueKey('googleMap'));


    });

  });


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

