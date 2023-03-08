// import 'package:http/http.dart';
// import 'package:ride_seattle/OneBusAway/routes.dart';
// import 'package:ride_seattle/classes/route.dart';
// import 'package:ride_seattle/classes/stop.dart';
// import 'package:xml/xml.dart';

// class Agency {
//   String agencyId;
//   String name;
//   String url;
//   String timezone;
//   String lang;
//   String? phone;
//   String? fareUrl;
//   bool privateService;

//   final List<String> _stopIds = [];
//   final Map<String, Route> _routes = {};
//   final Map<String, Stop> _stops = {};

//   Agency({
//     required this.agencyId,
//     required this.name,
//     required this.url,
//     required this.timezone,
//     required this.lang,
//     required this.phone,
//     required this.fareUrl,
//     required this.privateService,
//   });

//   Stop getStop(String stopId) {
//     return _stops[stopId]!;
//   }

//   Route getRoute(String routeId) {
//     return _routes[routeId]!;
//   }

//   void getRoutes() async {
//     Response res = await get(Uri.parse(Routes.getRoutes(agencyId)));
//     final document = XmlDocument.parse(res.body);
//     final routes = document.findAllElements('route');
//     for (var route in routes) {
//       _createRoute(route);
//     }
//   }

//   void _createRoute(XmlElement route) {
//     final id = route.findElements('id').first.text;
//     String? shortName;
//     try {
//       shortName = route.findElements('shortName').first.text;
//     } catch (e) {
//       if (e is StateError) shortName = null;
//     }
//     String? description;
//     try {
//       description = route.findElements('description').first.text;
//     } catch (e) {
//       if (e is StateError) description = null;
//     }

//     final type = route.findElements('type').first.text;
//     var url;
//     try {
//       url = route.findElements('url').first.text;
//     } catch (e) {
//       if (e is StateError) url = null;
//     }
//     final agencyId = route.findElements('agencyId').first.text;
//     _routes[id] = Route(
//         routeId: id,
//         shortName: shortName,
//         description: description,
//         type: type,
//         url: url,
//         agencyId: agencyId);
//   }

//   void getStopIdsForAgency() async {
//     Response res = await get(Uri.parse(Routes.getStopIdsForAgency(agencyId)));
//     final document = XmlDocument.parse(res.body);
//     final stopIds = document.findAllElements('string');
//     for (var stopId in stopIds) {
//       _stopIds.add(stopId.text);
//     }
//   }

//   void populateStopMap() {
//     for (var stop in _stopIds) {
//       _addStopFromId(stop);
//     }
//   }

//   void _addStopFromId(String stopId) async {
//     Response res = await get(Uri.parse(Routes.getStop(stopId)));
//     final document = XmlDocument.parse(res.body);
//     final stop = document.findElements('stop');
//     _addStop(stop.first);
//   }

//   void _addStop(XmlElement stop) {
//     final id = stop.findElements('id').first.text;
//     final lat = stop.findElements('lat').first.text as double;
//     final lon = stop.findElements('lon').first.text as double;
//     final direction = stop.findElements('direction').first.text;
//     final name = stop.findElements('name').first.text;
//     final code = stop.findElements('code').first.text;
//     final locationType = stop.findElements('locationType').first.text as int;
//     final routeIds = stop.findElements('routeIds');
//     final List<String> routeList = [];
//     for (var route in routeIds) {
//       routeList.add(route.text);
//     }
//     _stops[id] = Stop(
//       stopId: id,
//       lat: lat,
//       lon: lon,
//       direction: direction,
//       name: name,
//       code: code,
//       locationType: locationType,
//       routeIds: routeList,
//     );
//   }

//   // @override
//   // String toString() {
//   //   return "Id: $agencyId\nName: $name\nUrl: $url\nFareUrl: $fareUrl\nTimezone: $timezone\nPhone: $phone\nPrivate: ${privateService.toString()}";
//   // }
// }
