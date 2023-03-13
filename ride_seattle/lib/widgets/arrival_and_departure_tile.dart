import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';
import 'package:ride_seattle/provider/route_provider.dart';
import 'package:ride_seattle/widgets/route_box.dart';
import '../provider/local_storage_provider.dart';
import '../provider/state_info.dart';
import 'favorite_button.dart';

class ArrivalAndDepartureTile extends StatefulWidget {
  final ArrivalAndDeparture adInfo;
  final Completer<GoogleMapController> controller;

  const ArrivalAndDepartureTile({
    super.key,
    required this.adInfo,
    required this.controller,
  });

  @override
  State<ArrivalAndDepartureTile> createState() =>
      _ArrivalAndDepartureTileState();
}

class _ArrivalAndDepartureTileState extends State<ArrivalAndDepartureTile> {
  late LocalStorageProvider localStorage;
  late List<String> favoriteRoutes;

  // Offset _tapPosition = Offset.zero;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) => _onAfterBuild(context));
  }

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context, listen: false);
    final routeProvider = Provider.of<RouteProvider>(context, listen: false);
    return ListTile(
      // onLongPress: () {
      //   _showContextMenu(context, widget.adInfo.routeId);
      // },
      title: Row(
        children: [
          RouteBox(
            text: widget.adInfo.routeShortName,
            maxW: 120,
          ),
          Expanded(
            child: Container(),
          ),
          RouteBox(
            text: getPredictedArrivalTime(widget.adInfo),
            maxW: 100,
          ),
          const SizedBox(
            width: 10,
          ),

          IconButton(
            tooltip: "Find my vehicle",
            icon: const Icon(
              Icons.directions_bus,
            ),
            onPressed: () async {
              if (widget.adInfo.tripStatus != null) {
                //get all the stops for the current route
                List<LatLng> routeStops =
                    await stateInfo.getRoutePolyline(widget.adInfo.routeId);
                //add those stops to the routeProvider

                routeProvider.setPolyLines(routeStops);

                findBus(stateInfo);
              }
            },
          ),
          FavoriteButton(
            routeId: widget.adInfo.routeId,
            routeName: widget.adInfo.routeShortName,
          ),
        ],
      ),
    );
  }

  void findBus(StateInfo stateInfo) async {
    GoogleMapController c = await widget.controller.future;
    stateInfo.removeMarker(stateInfo.lastVehicle);
    stateInfo.vehicleStatus = widget.adInfo.tripStatus!;
    stateInfo.lastVehicle = widget.adInfo.tripStatus!.activeTripId;
    stateInfo.addMarker(
        widget.adInfo.tripStatus!.activeTripId,
        widget.adInfo.routeShortName,
        widget.adInfo.tripStatus!.position,
        stateInfo.getVehicleInfo,
        iconFilepath: 'assets/images/bus.png');
    c.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: widget.adInfo.tripStatus!.position,
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
