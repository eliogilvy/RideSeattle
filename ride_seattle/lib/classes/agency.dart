import 'package:http/http.dart';
import 'package:ride_seattle/OneBusAway/routes.dart';
import 'package:xml/xml.dart' as xml;

class Agency {
  String id;
  String name;
  String url;
  String timezone;
  String lang;
  String? phone;
  String? fareUrl;
  bool privateService;

  List<String> _stops = [];

  Agency({
    required this.id,
    required this.name,
    required this.url,
    required this.timezone,
    required this.lang,
    this.phone = "N/A",
    this.fareUrl = "N/A",
    required this.privateService,
  });

  void getStops() async {
    Response res = await get(Uri.parse(Routes.getStops(id)));
    final document = xml.XmlDocument.parse(res.body);
    final stopIds = document.findAllElements('string');
    for (var stop in stopIds) {
      _stops.add(stop.text);
    }
  }

  @override
  String toString() {
    return "Id: $id\nName: $name\nUrl: $url\nFareUrl: $fareUrl\nTimezone: $timezone\nPhone: $phone\nPrivate: ${privateService.toString()}";
  }
}
