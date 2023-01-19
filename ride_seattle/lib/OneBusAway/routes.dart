import 'keys.dart';

class Routes {
  static String getStops(String id) {
    return 'http://api.pugetsound.onebusaway.org/api/where/stop-ids-for-agency/$id.xml?key=${Key.oneBusAway}';
  }

  static String getAgencies() {
    return 'http://api.pugetsound.onebusaway.org/api/where/agencies-with-coverage.xml?key=${Key.oneBusAway}';
  }

  static String getRoutes(String id) {
    return 'https://api.pugetsound.onebusaway.org/api/where/routes-for-agency/$id.xml?key=${Key.oneBusAway}';
  }
}
