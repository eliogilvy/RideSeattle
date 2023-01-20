import 'package:http/http.dart';
import 'package:xml/xml.dart';

import '../OneBusAway/routes.dart';

class Route {
  final String id;
  String? shortName;
  String? description;
  final String type;
  String? url;
  final String agencyId;

  Route({
    required this.id,
    required this.shortName,
    required this.type,
    required this.description,
    required this.url,
    required this.agencyId,
  }) {
    getStopList();
  }

  final List<String> _stopIds = [];

  void getStopList() async {
    Response res = await get(Uri.parse(Routes.getStopsForRoute(id)));
    final document = XmlDocument.parse(res.body);
    final stops = document.findAllElements('string');
    for (var stop in stops) {
      _stopIds.add(stop.text);
    }
  }
}
