import 'package:http/http.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';
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

  Future<void> getArrivalAndDeparture() async {
    print("stop $stopId");
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
      final tripStatus = ad.findElements("tripStatus").first.text;

      print("adding $routeId");
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
        tripStatus: tripStatus,
      );
    }
  }
}
