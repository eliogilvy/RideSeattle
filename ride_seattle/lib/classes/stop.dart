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
  ArrivalAndDeparture? arrivalAndDeparture;

  Stop({
    required this.stopId,
    required this.lat,
    required this.lon,
    required this.direction,
    required this.name,
    required this.code,
    required this.locationType,
    required this.routeIds,
    this.arrivalAndDeparture,
  });

  void getArrivalAndDeparture() async {
    Response res = await get(Uri.parse(Routes.getArrivalAndDeparture(stopId)));
    final document = XmlDocument.parse(res.body);
    final arrivalAndDepartureNode =
        document.findElements("arrivalAndDeparture").first;

    final routeId = arrivalAndDepartureNode.findElements("routeId").first.text;
    final tripId = arrivalAndDepartureNode.findElements("tripId").first.text;
    final serviceDate = int.parse(
        arrivalAndDepartureNode.findElements("serviceDate").first.text);
    final id = arrivalAndDepartureNode.findElements("stopId").first.text;
    final stopSequence = int.parse(
        arrivalAndDepartureNode.findElements("stopSequence").first.text);
    final blockTripSequence = int.parse(
        arrivalAndDepartureNode.findElements("blockTripSequence").first.text);
    final routeShortName =
        arrivalAndDepartureNode.findElements("routeShortName").first.text;
    final routeLongName =
        arrivalAndDepartureNode.findElements("routeLongName").first.text;
    final tripHeadsign =
        arrivalAndDepartureNode.findElements("tripHeadsign").first.text;
    final arrivalEnabled =
        arrivalAndDepartureNode.findElements("arrivalEnabled").first.text ==
            "true";
    final departureEnabled =
        arrivalAndDepartureNode.findElements("departureEnabled").first.text ==
            "true";
    final scheduledArrivalTime = int.parse(arrivalAndDepartureNode
        .findElements("scheduledArrivalTime")
        .first
        .text);
    final scheduledDepartureTime = int.parse(arrivalAndDepartureNode
        .findElements("scheduledDepartureTime")
        .first
        .text);
    final frequency =
        arrivalAndDepartureNode.findElements("frequency").first.text;
    final predicted =
        arrivalAndDepartureNode.findElements("predicted").first.text == "true";
    final predictedArrivalTime = int.parse(arrivalAndDepartureNode
        .findElements("predictedArrivalTime")
        .first
        .text);
    final predictedDepartureTime = int.parse(arrivalAndDepartureNode
        .findElements("predictedDepartureTime")
        .first
        .text);
    final distanceFromStop = double.parse(
        arrivalAndDepartureNode.findElements("distanceFromStop").first.text);
    final numberOfStopsAway = int.parse(
        arrivalAndDepartureNode.findElements("numberOfStopsAway").first.text);
    final tripStatus =
        arrivalAndDepartureNode.findElements("tripStatus").first.text;

    arrivalAndDeparture = ArrivalAndDeparture(
      routeId: routeId,
      tripId: tripId,
      serviceDate: serviceDate,
      stopId: id,
      stopSequence: stopSequence,
      blockTripSequence: blockTripSequence,
      routeShortName: routeShortName,
      routeLongName: routeLongName,
      tripHeadsign: tripHeadsign,
      arrivalEnabled: arrivalEnabled,
      departureEnabled: departureEnabled,
      scheduledArrivalTime: scheduledArrivalTime,
      scheduledDepartureTime: scheduledDepartureTime,
      frequency: frequency,
      predicted: predicted,
      predictedArrivalTime: predictedArrivalTime,
      predictedDepartureTime: predictedDepartureTime,
      distanceFromStop: distanceFromStop,
      numberOfStopsAway: numberOfStopsAway,
      tripStatus: tripStatus,
    );
  }
}
