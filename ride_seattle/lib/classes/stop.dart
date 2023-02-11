import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';
import 'package:ride_seattle/classes/trip_status.dart';
import 'package:xml/xml.dart';

import '../OneBusAway/routes.dart';

class Stop {
  final String stopId;
  final double lat;
  final double lon;
  String? direction;
  final String name;
  final String code;
  final int locationType;
  final List<String> routeIds;
  Map<String, ArrivalAndDeparture> _arrivalAndDeparture = {};

  Stop({
    required this.stopId,
    required this.lat,
    required this.lon,
    required this.direction,
    required this.name,
    required this.code,
    required this.locationType,
    required this.routeIds,
  });

  Map<String, ArrivalAndDeparture> get arrivalAndDeparture =>
      _arrivalAndDeparture;

  List<ArrivalAndDeparture> get arrivalAndDepartureList =>
      _arrivalAndDeparture.values.toList();

  LatLng getPostion(XmlElement position) {
    double lat = double.parse(position.findElements('lat').first.text);
    double lon = double.parse(position.findElements('lon').first.text);
    return LatLng(lat, lon);
  }

  TripStatus getTripStatus(XmlElement trip) {
    final activeTripId = trip.findElements('activeTripId').first.text;
    final blockTripSequence =
        int.parse(trip.findElements('blockTripSequence').first.text);
    final serviceDate = int.parse(trip.findElements('serviceDate').first.text);
    final scheduledDistanceAlongTrip = double.parse(
        trip.findElements('scheduledDistanceAlongTrip').first.text);
    final totalDistanceAlongTrip =
        double.parse(trip.findElements('totalDistanceAlongTrip').first.text);
    final LatLng position = getPostion(trip.findElements('position').first);
    final orientation =
        double.parse(trip.findElements('orientation').first.text);
    final closestStop = trip.findElements('closestStop').first.text;
    final closestStopTimeOffset =
        int.parse(trip.findElements('closestStopTimeOffset').first.text);
    final nextStop = trip.findElements('nextStop').first.text;
    final nextStopTimeOffset =
        int.parse(trip.findAllElements('nextStopTimeOffset').first.text);

    var phase;
    try {
      phase = trip.findAllElements('phase').first.text;
    } catch (e) {
      phase = "Unknown";
    }
    final status = trip.findAllElements('status').first.text;
    final predicted =
        bool.fromEnvironment(trip.findAllElements('predicted').first.text);
    var lastUpdateTime;
    try {
      lastUpdateTime =
          int.parse(trip.findAllElements('lastUpdateTime').first.text);
    } catch (e) {
      lastUpdateTime = 0;
    }
    var lastLocationUpdateTime;
    try {
      lastLocationUpdateTime =
          int.parse(trip.findAllElements('lastLocationUpdateTime').first.text);
    } catch (e) {
      lastLocationUpdateTime = 0;
    }
    var lastKnownLocation;
    try {
      lastKnownLocation =
          getPostion(trip.findAllElements('lastKnownLocation').first);
    } catch (e) {
      lastKnownLocation = null;
    }

    return TripStatus(
      activeTripId: activeTripId,
      blockTripSequence: blockTripSequence,
      serviceDate: serviceDate,
      scheduledDistanceAlongTrip: scheduledDistanceAlongTrip,
      totalDistanceAlongTrip: totalDistanceAlongTrip,
      position: position,
      orientation: orientation,
      closestStop: closestStop,
      closestStopTimeOffset: closestStopTimeOffset,
      nextStop: nextStop,
      nextStopTimeOffset: nextStopTimeOffset,
      phase: phase,
      status: status,
      predicted: predicted,
      lastUpdateTime: lastUpdateTime,
      lastLocationUpdateTime: lastLocationUpdateTime,
      lastKnownLocation: lastKnownLocation,
    );
  }

  Future<void> getArrivalAndDeparture() async {
    Response res =
        await get(Uri.parse(Routes.getArrivalsAndDepartures(stopId)));
    final document = XmlDocument.parse(res.body);
    var arrivalAndDepartureNode =
        document.findAllElements("arrivalAndDeparture");

    for (var ad in arrivalAndDepartureNode) {
      final routeId = ad.findElements("routeId").first.text;
      final tripId = ad.findElements("tripId").first.text;
      final serviceDate = int.parse(ad.findElements("serviceDate").first.text);
      final id = ad.findElements("stopId").first.text;
      final stopSequence =
          int.parse(ad.findElements("stopSequence").first.text);
      final blockTripSequence =
          int.parse(ad.findElements("blockTripSequence").first.text);
      final routeShortName = ad.findElements("routeShortName").first.text;
      final tripHeadsign = ad.findElements("tripHeadsign").first.text;
      final arrivalEnabled =
          ad.findElements("arrivalEnabled").first.text == "true";
      final departureEnabled =
          ad.findElements("departureEnabled").first.text == "true";
      final scheduledArrivalTime =
          int.parse(ad.findElements("scheduledArrivalTime").first.text);
      final scheduledDepartureTime =
          int.parse(ad.findElements("scheduledDepartureTime").first.text);
      final predicted = ad.findElements("predicted").first.text == "true";
      final predictedArrivalTime =
          int.parse(ad.findElements("predictedArrivalTime").first.text);
      final predictedDepartureTime =
          int.parse(ad.findElements("predictedDepartureTime").first.text);
      final distanceFromStop =
          double.parse(ad.findElements("distanceFromStop").first.text);
      final numberOfStopsAway =
          int.parse(ad.findElements("numberOfStopsAway").first.text);
      XmlElement? tripStatus;
      TripStatus? trip;
      try {
        tripStatus = ad.findElements('tripStatus').first;
        trip = getTripStatus(tripStatus);
      } catch (e) {
        tripStatus = null;
        trip = null;
      }

      _arrivalAndDeparture[tripId] = ArrivalAndDeparture(
        routeId: routeId,
        tripId: tripId,
        serviceDate: serviceDate,
        stopId: id,
        stopSequence: stopSequence,
        blockTripSequence: blockTripSequence,
        routeShortName: routeShortName,
        tripHeadsign: tripHeadsign,
        arrivalEnabled: arrivalEnabled,
        departureEnabled: departureEnabled,
        scheduledArrivalTime: scheduledArrivalTime,
        scheduledDepartureTime: scheduledDepartureTime,
        predicted: predicted,
        predictedArrivalTime: predictedArrivalTime,
        predictedDepartureTime: predictedDepartureTime,
        distanceFromStop: distanceFromStop,
        numberOfStopsAway: numberOfStopsAway,
        tripStatus: trip,
      );
    }
  }
}
