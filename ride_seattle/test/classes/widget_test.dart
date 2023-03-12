import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/Pages/favorites_screen.dart';
import 'package:ride_seattle/Pages/login_screen.dart';
import 'package:ride_seattle/Pages/maps_screen.dart';
import 'package:ride_seattle/Pages/stop_history.dart';
import 'package:ride_seattle/classes/auth.dart';
import 'package:ride_seattle/main.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';
import 'package:ride_seattle/provider/local_storage_provider.dart';
import 'package:ride_seattle/provider/route_provider.dart';
import 'package:ride_seattle/provider/state_info.dart';

import 'package:ride_seattle/styles/theme.dart';
import 'package:ride_seattle/widgets/arrival_and_departure_list.dart';
import 'package:ride_seattle/widgets/loading.dart';
import 'package:ride_seattle/widgets/marker_sheet.dart';
import 'package:ride_seattle/widgets/route_box.dart';
import 'package:ride_seattle/widgets/route_name.dart';
import 'package:ride_seattle/widgets/vehicle_sheet.dart';
import 'package:ride_seattle/widgets/route_tile.dart';
import 'package:ride_seattle/widgets/route_list.dart';

import '../mock_classes.dart/mock_state_info.dart';
import 'class_test.dart';
import 'firebase_mock.dart';
import 'widget_test.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigatorObserver>(
      returnNullOnMissingStub: true,
    )
  ],
)
class MockHiveBox extends Mock implements Box {}

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();
  late LoginPage loginPage;
  late MockClient client;
  GeolocatorPlatform locator = GeolocatorPlatform.instance;
  final user = MockUser(
    isAnonymous: false,
    uid: 'someuid',
    email: 'bob@somedomain.com',
    displayName: 'Bob',
  );

  final auth = MockFirebaseAuth(mockUser: user, signedIn: true);

  Widget buildTestableWidget(Widget widget) {
    return MediaQuery(data: MediaQueryData(), child: MaterialApp(home: widget));
  }

  setUpAll(() async {
    await Firebase.initializeApp();
    client = MockClient();
  });

  group('login and register tests', () {
    setUp(() {
      loginPage = const LoginPage();
    });
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) =>
                      StateInfo(locator: locator, client: client)),
              ChangeNotifierProvider(create: (context) => RouteProvider()),
              ChangeNotifierProvider(
                create: (context) => FireProvider(
                  fb: FakeFirebaseFirestore().collection('users'),
                  auth: Auth(
                    firebaseAuth: auth,
                  ),
                ),
              )
            ],
            child: widget,
          ),
        ),
      );
    }

    testWidgets('Tap login with no entries should see error text',
        (WidgetTester tester) async {
      // Create the widget by telling the tester to build it.

      await tester.pumpWidget(buildTestableWidget(loginPage));

      final submit_loginRegisterBtn =
          find.byKey(const ValueKey('submit_login_Register_Button'));
      expect(submit_loginRegisterBtn, findsOneWidget);

      await tester.tap(submit_loginRegisterBtn);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(find.byKey(const ValueKey("error_message")), findsOneWidget);

      //ERROR MESSAGE APPEARS can't read actual text
      //expect(find.text("Error ? Given String is empty or null"), findsOneWidget);

      //can't identify exact text from error message
    });

    testWidgets('Click register and enter new password and username',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildTestableWidget(loginPage));

      final loginRegisterBtn =
          find.byKey(const ValueKey('login_or_registerButton'));
      expect(loginRegisterBtn, findsOneWidget);

      await tester.tap(loginRegisterBtn);
      await tester.pumpAndSettle(const Duration(milliseconds: 300));

      expect(find.text("Register instead"), findsOneWidget);

      final submit_loginRegisterBtn =
          find.byKey(const ValueKey('submit_login_Register_Button'));
      expect(submit_loginRegisterBtn, findsOneWidget);

      final emailField = find.byKey(const ValueKey("emailField"));
      final passwordField = find.byKey(const ValueKey("passwordField"));
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);

      await tester.enterText(
          find.byKey(const ValueKey("emailField")), 'testEmail2@test.com');
      await tester.enterText(
          find.byKey(const ValueKey("passwordField")), '123456789');

      await tester.tap(submit_loginRegisterBtn);
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      // Not navigating???
      // Check if I navigated
      // expect(find.byKey(ValueKey("googleMap")), findsOneWidget);

      //can't go to maps screen because of permissions?
    });
  });

  group('Maps test', () {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) =>
                      StateInfo(locator: locator, client: client)),
              ChangeNotifierProvider(create: (context) => RouteProvider()),
            ],
            child: widget,
          ),
        ),
      );
    }

    testWidgets('Maps screen loads', (WidgetTester tester) async {
      MapScreen map_page = const MapScreen();
      await tester.pumpWidget(buildTestableWidget(map_page));
      final map = find.byKey(const ValueKey('googleMap'));
      expect(map, findsOneWidget);
    });

    testWidgets('Markers load', (WidgetTester tester) async {
      MapScreen map_page = MapScreen();
      await tester.pumpWidget(buildTestableWidget(map_page));
      final map = find.byKey(const ValueKey('googleMap'));
      //can't test
    });
  });

  group('favorites page test', () {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (context) =>
                      StateInfo(locator: locator, client: client)),
              ChangeNotifierProvider(create: (context) => RouteProvider()),
              ChangeNotifierProvider(
                create: (context) => FireProvider(
                  fb: FakeFirebaseFirestore().collection('users'),
                  auth: Auth(
                    firebaseAuth: auth,
                  ),
                ),
              )
            ],
            child: widget,
          ),
        ),
      );
    }

    //final user = await result.user;
    //print(user.displayName);

    testWidgets('Favorites Page is empty find no widgets',
        (WidgetTester tester) async {
      //fails need to dependency injection of firebase auth
      Favorites favorite_screen = const Favorites();
      await tester.pumpWidget(buildTestableWidget(favorite_screen));
      await tester.pumpAndSettle();

      final tiles = find.byType(ListTile);
      expect(tiles, findsNothing);
    });
  });

  group('loader test', () {
    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: widget));
    }

    testWidgets(
      'Loader has circular progress indicator, after 10 seconds, changes to ',
      (WidgetTester tester) async {
        //fails need to dependency injection of firebase auth
        LoadingWidget loader = const LoadingWidget();
        await tester.pumpWidget(buildTestableWidget(loader));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump(const Duration(seconds: 10));
        expect(find.text('No data available, try tapping on the stop again.'),
            findsOneWidget);
      },
    );
  });

  group('route tile', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    Completer<GoogleMapController> controller = Completer();
    RouteTile routeTile = RouteTile(routeId: '123', routeName: '24');
    final StateInfo mock = MockStateInfo();

    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => mock,
                ),
                ChangeNotifierProvider(create: (context) => RouteProvider()),
                ChangeNotifierProvider(
                  create: (context) => FireProvider(
                    fb: FakeFirebaseFirestore().collection('users'),
                    auth: Auth(
                      firebaseAuth: auth,
                    ),
                  ),
                ),
              ],
              child: MaterialApp(
                home: Scaffold(body: widget),
                theme: RideSeattleTheme.theme(),
              )),
        ),
      );
    }

    testWidgets('Route Tile loads ', (tester) async {
      await tester.pumpWidget(buildTestableWidget(routeTile));
      expect(find.byType(Text), findsOneWidget);

      await tester.pump(const Duration(seconds: 10));
    });

    testWidgets('Route Tile long press ', (tester) async {
      await tester.pumpWidget(buildTestableWidget(routeTile));

      await tester.longPress(find.byType(ListTile));

      await tester.pump(const Duration(seconds: 10));

      expect(find.byType(IconButton), findsNWidgets(2));
    });
  });

  group('vehicle_sheet', () {
    StateInfo customStateInfo = MockStateInfo();
    String time(int t, String format) {
      String f = DateFormat(format).format(
        DateTime.fromMillisecondsSinceEpoch(t),
      );
      if (f == '0') {
        return 'NOW';
      }
      return f;
    }

    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => customStateInfo,
                ),
                ChangeNotifierProvider(create: (context) => RouteProvider()),
              ],
              child: MaterialApp(
                home: Scaffold(body: widget),
                theme: RideSeattleTheme.theme(),
              )),
        ),
      );
    }

    testWidgets('Check vehicle sheet', (WidgetTester tester) async {
      //fails need to dependency injection of firebase auth
      VehicleSheet vehicle_sheet = const VehicleSheet();
      await tester.pumpWidget(buildTestableWidget(vehicle_sheet));

      //First find progress indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump();

      // Find stop name
      expectLater(find.text('Next Stop: test stop'), findsOneWidget);
      // Find the location updated tile
      expect(
          find.text(
              'Location updated: ${time(customStateInfo.vehicleStatus!.lastLocationUpdateTime, 'h:mm a')}'),
          findsOneWidget);
    });
  });

  group('route_list', () {
    StateInfo customStateInfo = MockStateInfo();

    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => customStateInfo,
                ),
                ChangeNotifierProvider(create: (context) => RouteProvider()),
              ],
              child: MaterialApp(
                home: Scaffold(body: widget),
                theme: RideSeattleTheme.theme(),
              )),
        ),
      );
    }

    testWidgets('Check route list on empty routes',
        (WidgetTester tester) async {
      RouteList route_list = const RouteList();
      await tester.pumpWidget(buildTestableWidget(route_list));

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(InkWell), findsNothing);

      await tester.pump();
    });

    testWidgets('Check route list with routes', (WidgetTester tester) async {
      Widget buildTestableWidgetTest(Widget widget) {
        return MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(
            home: MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                      create: (context) =>
                          StateInfo(locator: locator, client: client)),
                  ChangeNotifierProvider(create: (context) => RouteProvider()),
                ],
                child: MaterialApp(
                  home: Scaffold(body: widget),
                  theme: RideSeattleTheme.theme(),
                )),
          ),
        );
      }

      RouteList route_list = const RouteList();
      await tester.pumpWidget(buildTestableWidgetTest(route_list));

      await tester.pump(const Duration(seconds: 10));

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.byType(InkWell), findsNothing);

      await tester.pump();
    });
  });

  group('marker sheet', () {
    TestWidgetsFlutterBinding.ensureInitialized();
    Completer<GoogleMapController> controller = Completer();
    MarkerSheet markerSheet = MarkerSheet(controller: controller);
    final StateInfo mock = MockStateInfo();

    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => mock,
                ),
                ChangeNotifierProvider(create: (context) => RouteProvider()),
                ChangeNotifierProvider(
                  create: (context) => FireProvider(
                    fb: FakeFirebaseFirestore().collection('users'),
                    auth: Auth(
                      firebaseAuth: auth,
                    ),
                  ),
                ),
              ],
              child: MaterialApp(
                home: Scaffold(body: widget),
                theme: RideSeattleTheme.theme(),
              )),
        ),
      );
    }

    testWidgets('sheet loads but only has a progress indicator',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget(markerSheet));
      expect(find.byType(SizedBox), findsOneWidget);

      await tester.pump(const Duration(seconds: 10));
    });
    testWidgets(
      'sheet loads with a routename and tile list',
      (tester) async {
        await mock.getMarkerInfo('id');
        await tester.pumpWidget(buildTestableWidget(markerSheet));
        expect(find.byType(RouteName), findsOneWidget);
        expect(find.byType(ArrivalAndDepartureList), findsOneWidget);
      },
    );
  });

  group('route_name', () {
    testWidgets('route name has correct text', (WidgetTester tester) async {
      //fails need to dependency injection of firebase auth
      RouteName routeName = const RouteName(text: 'testroute');
      await tester.pumpWidget(buildTestableWidget(routeName));
      await tester.pumpAndSettle();

      final fake_route = find.text('testroute');
      expect(fake_route, findsOneWidget);
    });
  });

  group('route_box', () {
    testWidgets('route box has correct text', (WidgetTester tester) async {
      //fails need to dependency injection of firebase auth
      RouteBox routeBox = RouteBox(
        text: 'route_box_text',
        maxW: 50,
      );
      await tester.pumpWidget(buildTestableWidget(routeBox));
      await tester.pumpAndSettle();

      final route_box_text = find.text('route_box_text');
      expect(route_box_text, findsOneWidget);
    });

    testWidgets('route box has been tapped', (WidgetTester tester) async {
      final observerMock = MockNavigatorObserver();

      Widget buildTestableWidget(Widget widget) {
        return MediaQuery(
            data: MediaQueryData(),
            child: MaterialApp(
              home: widget,
              navigatorObservers: [observerMock],
            ));
      }

      //fails need to dependency injection of firebase auth
      RouteBox routeBox = RouteBox(
        text: 'route_box_text',
        maxW: 50,
      );
      await tester.pumpWidget(buildTestableWidget(routeBox));
      await tester.pumpAndSettle();

      final route_box = find.byKey(const ValueKey("route_box"));
      expect(route_box, findsOneWidget);

      await tester.tap(route_box);
      verify(observerMock.didPush(any, any));
      await tester.pumpAndSettle();
    });
  });

  group('nav_drawer', () {
    {
      GeolocatorPlatform locator = MockGeoLocatorPlatform(
          service: true, permission: LocationPermission.always);

      MockClient client = MockClient();

      StateInfo stateInfo = MockStateInfo();

      //MOCK HIVE BOX???
      MockHiveBox mockHiveBox;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const MapScreen(),
            routes: const [],
          ),
          GoRoute(
            path: '/favoriteRoutes',
            builder: (context, state) => const Placeholder(
              key: Key('favoriteRoutes'),
            ),
            routes: const [],
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const Placeholder(
              key: Key('History'),
            ),
          )
        ],
      );
      final observerMock = MockNavigatorObserver();

      Widget buildTestableWidget() {
        //inherently has access to hive box
        return MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (context) => stateInfo),
                ChangeNotifierProvider(create: (context) => RouteProvider()),
                ListenableProvider<LocalStorageProvider>(
                  create: (context) => LocalStorageProvider(history),
                ),
                ChangeNotifierProvider(
                  create: (context) => FireProvider(
                    fb: FakeFirebaseFirestore().collection('users'),
                    auth: Auth(
                      firebaseAuth: auth,
                    ),
                  ),
                )
              ],
              child: MaterialApp.router(
                title: 'ride seattle',
                routerConfig: router,
              ),
            ),
            navigatorObservers: [observerMock],
          ),
        );
      }

      testWidgets('Open navigation drawer all tabs appear',
          (WidgetTester tester) async {
        await tester.pumpWidget(buildTestableWidget());
        final map = find.byKey(const ValueKey('googleMap'));
        expect(map, findsOneWidget);

        var scaffolds = find.byType(Scaffold);

        final ScaffoldState state = tester.firstState(scaffolds.last);
        state.openDrawer();
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(Drawer), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('My Routes'), findsOneWidget);
        expect(find.text('History'), findsOneWidget);
        expect(find.text('Sign out'), findsOneWidget);
      });

      testWidgets('Open navigation drawer navigate to home',
          (WidgetTester tester) async {
        await tester.pumpWidget(buildTestableWidget());
        final map = find.byKey(const ValueKey('googleMap'));

        // var scaffolds = find.byType(Scaffold);
        // final ScaffoldState state = tester.firstState(scaffolds.last);
        // state.openDrawer();
        final buttonFinder = find.byKey(const Key('drawer_open'));
        expect(buttonFinder, findsOneWidget);
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        expect(find.byType(Drawer), findsOneWidget);

        final homeButton = find.text('Home');

        expect(homeButton, findsOneWidget);
        await tester.tap(homeButton);
        verify(observerMock.didPush(any, any));
        await tester.pumpAndSettle();
        expect(map, findsOneWidget);
      });

      testWidgets(
        'Open navigation drawer navigate to stop history',
        (WidgetTester tester) async {
          await tester.pumpWidget(buildTestableWidget());
          final buttonFinder = find.byKey(const Key('drawer_open'));
          expect(buttonFinder, findsOneWidget);
          await tester.tap(buttonFinder);
          await tester.pumpAndSettle();

          expect(find.byType(Drawer), findsOneWidget);

          final historyButton = find.text('History');

          expect(historyButton, findsOneWidget);
          await tester.tap(historyButton);
          verify(observerMock.didPush(any, any));

          await tester.pumpAndSettle();

          expect(find.byKey(const Key('History')), findsOneWidget);

          // final body = find.byType(Scaffold);
          // expect(body, findsAtLeastNWidgets(1));

          // final stopHistory = find.text('Stop History');
          // expect(stopHistory, findsOneWidget);
        },
      );

      // testWidgets('Open drawer and navigate to favorite routes',
      //     (tester) async {
      //   await tester.pumpWidget(buildTestableWidget());
      //   final buttonFinder = find.byKey(const Key('drawer_open'));
      //   expect(buttonFinder, findsOneWidget);
      //   await tester.tap(buttonFinder);
      //   await tester.pumpAndSettle();

      //   expect(find.byType(Drawer), findsOneWidget);
      // });
    }
  });
}
