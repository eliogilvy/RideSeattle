

import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';
import 'package:ride_seattle/classes/route.dart';
import 'package:ride_seattle/classes/stop.dart';
import 'package:ride_seattle/classes/trip_status.dart';
import 'package:ride_seattle/classes/user.dart';
import 'package:ride_seattle/classes/vehicle.dart';

class MockClient extends Mock implements http.Client {}

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
}
