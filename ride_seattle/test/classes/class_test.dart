import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';
import 'package:ride_seattle/classes/route.dart';
import 'package:ride_seattle/classes/stop.dart';
import 'package:ride_seattle/classes/trip_status.dart';
import 'package:ride_seattle/classes/user.dart';
import 'package:ride_seattle/classes/vehicle.dart';
import 'package:ride_seattle/provider/route_provider.dart';

import 'package:ride_seattle/provider/state_info.dart';

class MockClient extends Mock implements http.Client {
  MockClient({this.res});
  String? res;
  final List<Uri> calls = [];

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    calls.add(url);
    return Future.value(Response(res!, 200));
  }
}

class MockGeoLocatorPlatform extends Mock implements GeolocatorPlatform {
  MockGeoLocatorPlatform({required this.service, required this.permission});
  bool service;
  LocationPermission permission;
  @override
  Future<bool> isLocationServiceEnabled() async {
    return service;
  }

  @override
  Future<LocationPermission> checkPermission() {
    return Future.value(permission);
  }

  @override
  Future<LocationPermission> requestPermission() {
    return Future.value(permission);
  }

  @override
  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) {
    return Future.value(
      Position(
        longitude: 47.6219,
        latitude: -122.3517,
        timestamp: DateTime(2023),
        accuracy: 3,
        altitude: 4,
        heading: 5,
        speed: 6,
        speedAccuracy: 7,
      ),
    );
  }
}

void main() {
  group(
    'Testing classes',
    () {
      // test('Agency class constructor', () {
      //   var agency = Agency(
      //     agencyId: '1',
      //     name: 'Test Agency',
      //     url: 'http://example.com',
      //     timezone: 'UTC',
      //     lang: 'en',
      //     phone: '555-555-5555',
      //     fareUrl: 'http://example.com/fares',
      //     privateService: false,
      //   );

      //   expect(agency.agencyId, '1');
      //   expect(agency.name, 'Test Agency');
      //   expect(agency.url, 'http://example.com');
      //   expect(agency.timezone, 'UTC');
      //   expect(agency.lang, 'en');
      //   expect(agency.phone, '555-555-5555');
      //   expect(agency.fareUrl, 'http://example.com/fares');
      //   expect(agency.privateService, isFalse);
      // });
      test('Arrival and departure class constructor', () {
        var ad = ArrivalAndDeparture(
            routeId: '1',
            tripId: '2',
            serviceDate: 3,
            stopId: '4',
            stopSequence: 5,
            blockTripSequence: 6,
            routeShortName: '7',
            tripHeadsign: '8',
            arrivalEnabled: true,
            departureEnabled: false,
            scheduledArrivalTime: 9,
            scheduledDepartureTime: 10,
            predicted: true,
            predictedArrivalTime: 11,
            predictedDepartureTime: 12,
            distanceFromStop: 13,
            numberOfStopsAway: 14);

        expect(ad.routeId, '1');
        expect(ad.tripId, '2');
        expect(ad.serviceDate, 3);
        expect(ad.stopId, '4');
        expect(ad.stopSequence, 5);
        expect(ad.blockTripSequence, 6);
        expect(ad.routeShortName, '7');
        expect(ad.tripHeadsign, '8');
        expect(ad.arrivalEnabled, true);
        expect(ad.departureEnabled, false);
        expect(ad.scheduledArrivalTime, 9);
        expect(ad.scheduledDepartureTime, 10);
        expect(ad.predicted, true);
        expect(ad.predictedArrivalTime, 11);
        expect(ad.predictedDepartureTime, 12);
        expect(ad.distanceFromStop, 13);
        expect(ad.numberOfStopsAway, 14);
      });
      test('Stop class constructor', () {
        var stop = Stop(
          stopId: '1',
          lat: 2,
          lon: 3,
          direction: '4',
          name: '5',
          code: '6',
          locationType: 7,
          routeIds: [],
        );

        expect(stop.stopId, '1');
        expect(stop.lat, 2);
        expect(stop.lon, 3);
        expect(stop.direction, '4');
        expect(stop.name, '5');
        expect(stop.code, '6');
        expect(stop.locationType, 7);
        expect(stop.routeIds, []);
      });
      test('Trip status class constructor', () {
        var trip = TripStatus(
          activeTripId: '1',
          blockTripSequence: 2,
          serviceDate: 3,
          scheduledDistanceAlongTrip: 4,
          totalDistanceAlongTrip: 5,
          position: const LatLng(1, 1),
          orientation: 6,
          closestStop: '7',
          closestStopTimeOffset: 8,
          nextStop: '9',
          nextStopTimeOffset: 10,
          phase: '11',
          status: '12',
          predicted: true,
          lastUpdateTime: 13,
          lastLocationUpdateTime: 14,
          lastKnownLocation: const LatLng(1, 1),
        );
        expect(trip.activeTripId, '1');
        expect(trip.blockTripSequence, 2);
        expect(trip.serviceDate, 3);
        expect(trip.scheduledDistanceAlongTrip, 4);
        expect(trip.totalDistanceAlongTrip, 5);
        expect(trip.position, const LatLng(1, 1));
        expect(trip.orientation, 6);
        expect(trip.closestStop, '7');
        expect(trip.closestStopTimeOffset, 8);
        expect(trip.nextStop, '9');
        expect(trip.nextStopTimeOffset, 10);
        expect(trip.phase, '11');
        expect(trip.status, '12');
        expect(trip.predicted, true);
        expect(trip.lastUpdateTime, 13);
        expect(trip.lastLocationUpdateTime, 14);
        expect(trip.lastKnownLocation, const LatLng(1, 1));
      });
      test('User class constructor', () {
        var user = User(
          userId: 1,
          firstName: 'Eli',
          lastName: 'Ogilvy',
          email: 'test@gmail.com',
          favoriteRoutes: [],
        );

        expect(user.userId, 1);
        expect(user.firstName, 'Eli');
        expect(user.lastName, 'Ogilvy');
        expect(user.email, 'test@gmail.com');
        expect(user.favoriteRoutes, []);
      });
      test('User toMap', () {
        var user = User(
          userId: 1,
          firstName: 'Eli',
          lastName: 'Ogilvy',
          email: 'test@gmail.com',
          favoriteRoutes: [],
        );

        var testUser = user.toMap();

        expect(testUser["id"], 1);
        expect(testUser["firstName"], 'Eli');
        expect(testUser["lastName"], 'Ogilvy');
        expect(testUser["email"], 'test@gmail.com');
        expect(testUser["favoriteRoutes"], []);
      });
      test('User fromMap', () {
        var user = User(
          userId: 1,
          firstName: 'Eli',
          lastName: 'Ogilvy',
          email: 'test@gmail.com',
          favoriteRoutes: [],
        );

        var userMap = user.toMap();
        var userFromMap = User.fromMap(userMap);

        expect(userFromMap.userId, 1);
        expect(userFromMap.firstName, 'Eli');
        expect(userFromMap.lastName, 'Ogilvy');
        expect(userFromMap.email, 'test@gmail.com');
        expect(userFromMap.favoriteRoutes, []);
      });
      test(
        'Vehicle class constructor',
        () {
          var v = Vehicle(
            vehicleId: '1',
            lastUpdateTime: '2',
            lastLocationUpdateTime: '3',
            lat: '4',
            lon: '5',
            tripId: '6',
            tripStatus: '7',
          );
          expect(v.vehicleId, '1');
          expect(v.lastUpdateTime, '2');
          expect(v.lastLocationUpdateTime, '3');
          expect(v.lat, '4');
          expect(v.lon, '5');
          expect(v.tripId, '6');
          expect(v.tripStatus, '7');
        },
      );
      test(
        'Constructor sets properties correctly',
        () {
          var route = Route(
            routeId: "1_102715",
            shortName: "162",
            description: "Lake Meridean P&R - Downtown Seattle",
            type: '3',
            url: "http://metro.kingcounty.gov/schedules/162/n0.html",
            agencyId: "1",
          );

          expect(route.routeId, "1_102715");
          expect(route.shortName, "162");
          expect(route.description, "Lake Meridean P&R - Downtown Seattle");
          expect(route.type, '3');
          expect(
              route.url, "http://metro.kingcounty.gov/schedules/162/n0.html");
          expect(route.agencyId, "1");
        },
      );
    },
  );
  group(
    'Testing state info',
    () {
      MockGeoLocatorPlatform locator = MockGeoLocatorPlatform(
          service: true, permission: LocationPermission.always);
      MockClient client = MockClient();
      StateInfo? stateInfo;
      setUp(() {
        TestWidgetsFlutterBinding.ensureInitialized();
        stateInfo = StateInfo(locator: locator, client: client);
      });
      test(
        'getPosition() returns the current position when location services and permissions are enabled',
        () async {
          // Arrange
          //StateInfo stateInfo = StateInfo(locator: locator, client: client);
          await stateInfo!.getPosition();
          expect(
            stateInfo!.position,
            Position(
              longitude: 47.6219,
              latitude: -122.3517,
              timestamp: DateTime(2023),
              accuracy: 3,
              altitude: 4,
              heading: 5,
              speed: 6,
              speedAccuracy: 7,
            ),
          );
        },
      );
      test(
        'getPosition() returns error due to bad privileges',
        () async {
          StateInfo stateInfo = StateInfo(locator: locator, client: client);
          stateInfo.locator = MockGeoLocatorPlatform(
              service: false, permission: LocationPermission.always);
          try {
            await stateInfo.getPosition();
          } catch (e) {
            expect(e, 'Location services are disabled');
          }

          stateInfo.locator = MockGeoLocatorPlatform(
              service: true, permission: LocationPermission.denied);
          try {
            await stateInfo.getPosition();
          } catch (e) {
            expect(e, 'Location Permission denied');
          }

          stateInfo.locator = MockGeoLocatorPlatform(
              service: true, permission: LocationPermission.deniedForever);
          try {
            await stateInfo.getPosition();
          } catch (e) {
            expect(e, 'Location permission denied permanently');
          }
        },
      );
      test(
        'get methods',
        () {
          stateInfo!.addCircle(const LatLng(1, 1), 'circle');
          expect(stateInfo!.circles.length, 1);
          stateInfo!.addMarker(
              'marker', 'name test', const LatLng(1, 1), (p0) => null);

          stateInfo!.setRadius(
              const LatLng(5, 5), const LatLng(10, 5), const LatLng(0, 5));
          expect(stateInfo!.radius, '555974.6332227937');
          expect(stateInfo!.currentStopInfo, null);
        },
      );

      test(
        'getStopsForLocation',
        () async {
          stateInfo!.client = MockClient(
            res: '''<stop>
            <id>1_75403</id>
            <lat>47.6543655</lat>
            <lon>-122.305206</lon>
            <direction>S</direction>
            <name>Stevens Way &amp; BENTON LANE</name>
            <code>75403</code>
            <locationType>0</locationType>
            <routeIds>
              <string>1_31</string>
              <string>...</string>
            </routeIds>
          </stop>''',
          );
          await stateInfo!.getStopsForLocation('24', '24');
          expect(stateInfo!.stops.length, 1);
        },
      );
      test(
        'getRoutesForLocation',
        () async {
          stateInfo!.client = MockClient(
            res: '''<route>
            <id>1_100224</id>
            <shortName>44</shortName>
            <description>Ballard - Montlake</description>
            <type>3</type>
            <url>http://metro.kingcounty.gov/schedules/044/n0.html</url>
            <agencyId>1</agencyId>
        </route>''',
          );

          await stateInfo!.getRoutesForLocation('24', '24');
          expect(stateInfo!.routes.length, 1);
        },
      );

      test(
        'getStop',
        () async {
          stateInfo!.client = MockClient(
            res: '''<stop>
            <id>1_75403</id>
            <lat>47.6543655</lat>
            <lon>-122.305206</lon>
            <direction>S</direction>
            <name>Stevens Way &amp; BENTON LANE</name>
            <code>75403</code>
            <locationType>0</locationType>
            <routeIds>
              <string>1_31</string>
              <string>...</string>
            </routeIds>
          </stop>''',
          );

          // Calling twice to get stop in map and stop not in map
          String stop = await stateInfo!.getStop('1_75403');
          expect(stop, 'Stevens Way & BENTON LANE');

          stop = await stateInfo!.getStop('1_75403');
          expect(stop, 'Stevens Way & BENTON LANE');

          await stateInfo!.getMarkerInfo('1_75403');
          expect(stateInfo!.currentStopInfo!.stopId, '1_75403');
        },
      );

      test('getRoutePolyline', () async {
        stateInfo!.client = MockClient(res: '''
        <encodedPolyline>
<points>qc}aHp|`jVrA?e@cJAIEa@Mc@ISsBkEO[IYGYEWAYAc@@}E?m@AmOAoO?sF?sD?oC?q@?sG?cE?oA?yA?yD@eH?sO?kA@qL?U?OAeF?yH?}@?oJ?gN?_C?yAAwE?oCAq@?U?e@?]@]@QBMDIFMDKJGHKhBsAbCkBJIHGr@e@xAs@rBgAhB}@TM^[`@_@BA\_@r@y@X_@nCaD`@i@BERSLQ\e@Zm@~@oBTc@L[Xw@DM@KDSDSDUB[@M?S@c@?{@?_D?eA?sD?wF?aH?}A@kA?SHm@B[D]@Y@e@?k@?o@Ei@?[?S@}@@kAA[ASCM?UEq@As@Ag@A{D@MBMDQJYl@yARc@P_@Pe@Ri@@qD?aB?gE?yG?M?_B?Y?mD?_A?yD?s@?wC?u@?_@?}F@kF?mF?_A@mD?mF?oC@iE@sD?a@?sE?wE?oD@w@@}D?a@?yD@eC?kA?g@@uB?i@?gA?yC?eA@_@?g@?eA@qB?qB@uB?qB?uB?k@?cA@qB?yB|@?dC?bBDpABtE@hHFlABh@?n@?~B?dBBL?fCDjBBZ?PBJFJJLHX\bB{DdAkCFStCgH|@eC`@iA`A_CISCM?M?MBo@@W?QB[?e@?_@AS</points>
<length>216</length>
</encodedPolyline>''');

        List<LatLng> list = await stateInfo!.getRoutePolyline('test');

        expect(list.length, 215);
      });
      test('add and remove marker', () async {
        await stateInfo!
            .addMarker('marker', 'test', const LatLng(1, 1), (p0) => null);
        expect(stateInfo!.markers.length, 1);
        stateInfo!.removeMarker('marker');
        expect(stateInfo!.markers.length, 0);
      });
      test('can call getVehicleInfo, can call set route filter', () async {
        await stateInfo!.getVehicleInfo('id');
        stateInfo!.routeFilter = 'test';
        stateInfo!.updateStops();
        expect(stateInfo!.markers.length, 0);
      });
    },
  );

  group('Route Provider tests', () {
    late RouteProvider routeProvider;

    setUp(() => routeProvider = RouteProvider());

    test('Adding a stop', () {
      routeProvider.assignStops([
        Stop(
            stopId: 'stopId',
            lat: 1,
            lon: 2,
            direction: 'north',
            name: 'Test stop',
            code: 'Test code',
            locationType: 3,
            routeIds: ['routeId'])
      ]);
      expect(routeProvider.stopsForRoute.first.stopId, 'stopId');
      expect(routeProvider.getStops().length, 1);

      routeProvider.stopsForRoute.clear();

      expect(routeProvider.getStops().length, 0);

      routeProvider.addItem(Stop(
          stopId: 'stopId',
          lat: 1,
          lon: 2,
          direction: 'north',
          name: 'Test stop',
          code: 'Test code',
          locationType: 3,
          routeIds: ['routeId']));
      expect(routeProvider.getStops().first.stopId, 'stopId');
    });
    test('Setting polylines', () {
      routeProvider.setPolyLines([const LatLng(1, 1)]);
      expect(routeProvider.routePolyLine.length, 1);
      routeProvider.clearPolylines();
      expect(routeProvider.routePolyLine.length, 0);
    });
  });
}
