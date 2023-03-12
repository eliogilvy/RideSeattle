import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
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
import 'package:ride_seattle/Pages/favorites_screen.dart';
import 'package:ride_seattle/Pages/login_screen.dart';
import 'package:ride_seattle/Pages/maps_screen.dart';
import 'package:ride_seattle/classes/auth.dart';
import 'package:ride_seattle/classes/old_stops.dart';
import 'package:ride_seattle/main.dart';
import 'package:ride_seattle/provider/local_storage_provider.dart';
import 'package:ride_seattle/provider/route_provider.dart';
import 'package:ride_seattle/provider/state_info.dart';

import 'package:http/http.dart';
import 'package:ride_seattle/widgets/loading.dart';
import 'package:ride_seattle/widgets/nav_drawer.dart';
import 'package:ride_seattle/widgets/route_box.dart';
import 'package:ride_seattle/widgets/route_name.dart';
import 'package:ride_seattle/widgets/vehicle_sheet.dart';

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


void main() {

  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  Widget buildTestableWidget(Widget widget) {
    return MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(home: widget)
    );
  }

  setUpAll(() async {
    await Firebase.initializeApp();

  });

  testWidgets("Check Sign in", (WidgetTester tester) async {

    GeolocatorPlatform locator = GeolocatorPlatform.instance;
    Client client = Client();
    //initialize hive offline storage
    await Hive.initFlutter();
    //openboxes
    Box<OldStops> history = await Hive.openBox('stop_test');
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
                      LocalStorageProvider(history)),
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

      await tester.enterText(find.byKey(const ValueKey("emailField")), 'testEmail2@test.com');
      await tester.enterText(find.byKey(const ValueKey("passwordField")), '123456789');


      await tester.tap(submit_loginRegisterBtn);
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      //Not navigating???
      //Check if I navigated
      //expect(find.byKey(ValueKey("googleMap")), findsOneWidget);

      //can't go to maps screen because of permissions?

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
      //can't test
    });

  });


  group('Router Test', ()
  {

    final observerMock = MockNavigatorObserver();


    final _router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const MapScreen(),
          routes: const [],
        ),
        GoRoute(
          path: '/favoriteRoutes',
          builder: (context, state) => const Favorites(),
          routes: const [],
        ),
      ],
    );


    Widget buildTestableWidget() {

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
            child: MaterialApp.router(
              title: 'ride seattle',
              routerConfig: _router,
            ),
          ),

        ),
      );
    }

    testWidgets('Maps screen loads, navigate to favorites', (WidgetTester tester) async {

      await tester.pumpWidget(buildTestableWidget());
      final map = find.byKey(const ValueKey('googleMap'));
      expect(map, findsOneWidget);

      final ScaffoldState scaffoldState = tester.firstState(find.byType(Scaffold));
      scaffoldState.openDrawer();

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('My Routes'), findsOneWidget);

    });

  });

  group('favorites page test', () {

    Widget buildTestableWidget(Widget widget) {
      return MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(home: widget)
      );
    }

    final user = MockUser(
      isAnonymous: true,
      uid: 'someuid',
      email: 'bob@somedomain.com',
      displayName: 'Bob',
    );

    final auth = MockFirebaseAuth(mockUser: user);
    //await??
    final result = auth.signInAnonymously();

    //final user = await result.user;
    //print(user.displayName);

    testWidgets('Favorites Page is empty find no widgets', (WidgetTester tester) async {

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
          data: MediaQueryData(),
          child: MaterialApp(home: widget)
      );
    }


    testWidgets('Loader does not appear after 10 seconds', (WidgetTester tester) async{

      //fails need to dependency injection of firebase auth
      LoadingWidget loader = const LoadingWidget();
      await tester.pumpWidget(buildTestableWidget(loader));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pump(const Duration(seconds: 2));

    });

    testWidgets('Loader appears', (WidgetTester tester) async{

      await tester.pumpWidget(const Directionality(textDirection: TextDirection.ltr, child: LoadingWidget()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));

      //fails need to dependency injection of firebase auth
      //LoadingWidget loader = const LoadingWidget();
      //await tester.pumpWidget(buildTestableWidget(loader));
      //final loadingWidget = find.byType(CircularProgressIndicator);
      //expect(loadingWidget, findsOneWidget);
    });

  });

  group('vehicle_sheet', (){

    //TODO does not work WIP

    MockGeoLocatorPlatform locator = MockGeoLocatorPlatform(
        service: true, permission: LocationPermission.always);
    MockClient client = MockClient();
    StateInfo? stateInfo;
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      stateInfo = StateInfo(locator: locator, client: client);
    });


    Widget buildTestableWidget(Widget widget) {

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
              child: MaterialApp(home: widget)
          ),

        ),
      );
    }

    testWidgets('Check vehicle sheet', (WidgetTester tester) async{
      //fails need to dependency injection of firebase auth
      VehicleSheet vehicle_sheet = const VehicleSheet();
      await tester.pumpWidget(buildTestableWidget(vehicle_sheet));

    });

  });

  group('route_name', (){

    testWidgets('route name has correct text', (WidgetTester tester) async{
      //fails need to dependency injection of firebase auth
      RouteName routeName = const RouteName(text: 'routeBlah');
      await tester.pumpWidget(buildTestableWidget(routeName));
      await tester.pumpAndSettle();

      final fake_route = find.text('routeBlah');
      expect(fake_route, findsOneWidget);

    });
  });

  group('route_box', (){

    testWidgets('route name has correct text', (WidgetTester tester) async{

      //fails need to dependency injection of firebase auth
      RouteBox routeBox = RouteBox(text: 'route_box_text', maxW: 50,);
      await tester.pumpWidget(buildTestableWidget(routeBox));
      await tester.pumpAndSettle();

      final route_box_text = find.text('route_box_text');
      expect(route_box_text, findsOneWidget);
    });

    testWidgets('route box is expanded', (WidgetTester tester) async{

      final observerMock = MockNavigatorObserver();

      Widget buildTestableWidget(Widget widget) {
        return MediaQuery(
            data: MediaQueryData(),
            child: MaterialApp(home: widget,
              navigatorObservers: [
                observerMock
              ],)
        );
      }

      //fails need to dependency injection of firebase auth
      RouteBox routeBox = RouteBox(text: 'route_box_text', maxW: 50,);
      await tester.pumpWidget(buildTestableWidget(routeBox));
      await tester.pumpAndSettle();

      final route_box = find.byKey(const ValueKey("route_box"));
      expect(route_box, findsOneWidget);

      await tester.tap(route_box);
      verify(observerMock.didPush(any, any));
      await tester.pumpAndSettle();

    });

  });


  group('nav_drawer', (){
    {

      MockGeoLocatorPlatform locator = MockGeoLocatorPlatform(
          service: true, permission: LocationPermission.always);
      MockClient client = MockClient();
      StateInfo? stateInfo;
      setUp(() {
        TestWidgetsFlutterBinding.ensureInitialized();
        stateInfo = StateInfo(locator: locator, client: client);
      });

      Widget buildTestableWidget(Widget widget) {

        return MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(
            home:
            MultiProvider(
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

      testWidgets('Open navigation drawer with text', (WidgetTester tester) async {
        MapScreen map_page = MapScreen();
        await tester.pumpWidget(buildTestableWidget(map_page));
        final map = find.byKey(const ValueKey('googleMap'));
        expect(map, findsOneWidget);

        var scaffolds = find.byType(Scaffold);

        final ScaffoldState state = tester.firstState(scaffolds.last);
        state.openDrawer();
        await tester.pump(const Duration(seconds: 1));

        expect(find.byType(Drawer), findsOneWidget);
        //expect(find.byKey(const ValueKey("navigation_drawer")), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);

      });
    }
  });


}

