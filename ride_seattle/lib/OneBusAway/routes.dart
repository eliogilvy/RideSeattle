import 'dart:convert';
import 'package:http/http.dart';
import 'package:xml/xml.dart';
import 'package:xml2json/xml2json.dart';

import 'keys.dart';

class Routes {
  static String getStopsForRoute(String id) {
    return 'http://api.pugetsound.onebusaway.org/api/where/stops-for-route/$id.xml?key=${Key.oneBusAway}';
  }

  static String getAgencies() {
    return 'http://api.pugetsound.onebusaway.org/api/where/agencies-with-coverage.xml?key=${Key.oneBusAway}';
  }

  static String getRoutes(String id) {
    return 'https://api.pugetsound.onebusaway.org/api/where/routes-for-agency/$id.xml?key=${Key.oneBusAway}';
  }

  static String getStop(String id) {
    return 'http://api.pugetsound.onebusaway.org/api/where/stop/$id.xml?key=${Key.oneBusAway}';
  }

  static String getStopIdsForAgency(String id) {
    return 'http://api.pugetsound.onebusaway.org/api/where/stop-ids-for-agency/$id.xml?key=${Key.oneBusAway}';
  }

  static String getVehiclesforAgency(String id) {
    return 'http://api.onebusaway.org/api/where/vehicles-for-agency/$id.xml?key=${Key.oneBusAway}';
  }

  static String getArrivalsAndDepartures(String id) {
    return 'http://api.pugetsound.onebusaway.org/api/where/arrivals-and-departures-for-stop/$id.xml?key=${Key.oneBusAway}';
  }

  static String getStopsForLocation(String lat, String lon, String radius) {
    return 'http://api.pugetsound.onebusaway.org/api/where/stops-for-location.xml?key=${Key.oneBusAway}&lat=$lat&lon=$lon&radius=$radius';
  }

  static String getRoutesForLocation(String lat, String lon, String radius) {
    return 'http://api.pugetsound.onebusaway.org/api/where/routes-for-location.xml?key=${Key.oneBusAway}&lat=$lat&lon=$lon&radius=$radius';
  }
}
