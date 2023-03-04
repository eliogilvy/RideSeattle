import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';
import 'package:ride_seattle/provider/route_provider.dart';
import 'package:ride_seattle/widgets/route_box.dart';

import '../provider/state_info.dart';

class ArrivalAndDepartureTile extends StatelessWidget {
  final ArrivalAndDeparture adInfo;
  final GoogleMapController controller;
  const ArrivalAndDepartureTile(
      {super.key, required this.adInfo, required this.controller});

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context, listen: false);
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    return ListTile(
      title: Row(
        children: [
          RouteBox(
            text: adInfo.routeShortName,
            maxW: 150,
          ),
          Expanded(
            child: Container(),
          ),
          RouteBox(
            text: getPredictedArrivalTime(adInfo),
            maxW: double.infinity,
          ),
          IconButton(
            tooltip: "Find my vehicle",
            icon: const Icon(
              Icons.directions_bus,
            ),
            onPressed: () async {
              if (adInfo.tripStatus != null) {
                //get all the stops for the current route
                List<LatLng> routeStops =
                    await stateInfo.getRoutePolyline(adInfo.routeId);
                //add those stops to the routeProvider

                routeProvider.setPolyLines(routeStops);

                findBus(stateInfo);
              }
            },
          ),
        ],
      ),
    );
  }

  void findBus(StateInfo stateInfo) {
    
    stateInfo.removeMarker(stateInfo.lastVehicle);
    stateInfo.lastVehicle = adInfo.tripStatus!.activeTripId;
    stateInfo.addMarker(adInfo.tripStatus!.activeTripId, adInfo.routeShortName,
        adInfo.tripStatus!.position, stateInfo.getVehicleInfo,
        iconFilepath: 'assets/images/icons8-bus-96.png');
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: adInfo.tripStatus!.position,
          zoom: 16,
        ),
      ),
    );
  }

  String getPredictedArrivalTime(ArrivalAndDeparture adInfo) {
    int prediction;
    if (adInfo.predictedArrivalTime == 0) {
      prediction = adInfo.scheduledArrivalTime;
    } else {
      prediction = adInfo.predictedArrivalTime;
    }
    int now = DateTime.now().millisecondsSinceEpoch;

    int difference = prediction - now;
    int differenceInMinutes = difference ~/ 60000;
    if (differenceInMinutes == 0) {
      return "NOW";
    } else if (differenceInMinutes < 0) {
      return "Departed";
    }
    return "${differenceInMinutes.toString()} min";
  }
}
