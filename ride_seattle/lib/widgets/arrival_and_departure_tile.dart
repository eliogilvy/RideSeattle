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
  final GoogleMapController controller;
  final Function callback;

  const ArrivalAndDepartureTile(
      {super.key,
      required this.adInfo,
      required this.controller,
      required this.callback});

  @override
  State<ArrivalAndDepartureTile> createState() =>
      _ArrivalAndDepartureTileState();
}

class _ArrivalAndDepartureTileState extends State<ArrivalAndDepartureTile> {
  late LocalStorageProvider localStorage;
  late List<String> favoriteRoutes;

  Offset _tapPosition = Offset.zero;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _onAfterBuild(context));
  }

  void _onAfterBuild(BuildContext context) {
    localStorage = Provider.of<LocalStorageProvider>(context, listen: false);

    try {
      localStorage.loadData();
    } catch (e) {
      print(e.toString());
    }
    favoriteRoutes = localStorage.getFavoriteRoutes();
  }

  void _getTapPosition(TapDownDetails tapPos) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;

    setState(() {
      _tapPosition = renderBox.globalToLocal(tapPos.globalPosition);
    });
  }

  // void _showContextMenu(context, String routeId) async {
  //   final RenderObject? overlay =
  //       Overlay.of(context).context.findRenderObject();
  //   final result = await showMenu(
  //       context: context,
  //       position: RelativeRect.fromRect(
  //         Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 10, 10),
  //         Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
  //             overlay.paintBounds.size.height),
  //       ),
  //       items: [
  //         const PopupMenuItem(
  //           value: "favorited",
  //           child: Text('Add to favorites'),
  //         ),
  //       ]);

  //   if (result == "favorited") {
  //     print("route favorited");
  //     //add polylines to local database

  //     localStorage.addRoute(routeId);
  //     print("route added - arrival/departure tile");
  //   }
  // }

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
          // GestureDetector(
          //   onTapDown: (position) {
          //     _getTapPosition(position);
          //   },
          //   child: InkWell(
          //     //tooltip: "Find my vehicle",
          //     onTap: () async {
          //       if (widget.adInfo.tripStatus != null) {
          //         //get all the stops for the current route
          //         List<LatLng> routeStops =
          //             await stateInfo.getRoutePolyline(widget.adInfo.routeId);
          //         //add those stops to the routeProvider

          //         routeProvider.setPolyLines(routeStops);

          //         findBus(stateInfo);
          //       }
          //     },
          //     onLongPress: () async {
          //       _showContextMenu(context, widget.adInfo.routeId);
          //     },
          //     child: Ink(
          //       child: const Icon(Icons.directions_bus),
          //     ),
          //   ),
          // ),

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
            callback: widget.callback,
          ),
        ],
      ),
    );
  }

  void findBus(StateInfo stateInfo) {
    stateInfo.removeMarker(stateInfo.lastVehicle);
    stateInfo.vehicleStatus = widget.adInfo.tripStatus!;
    stateInfo.lastVehicle = widget.adInfo.tripStatus!.activeTripId;
    stateInfo.addMarker(
        widget.adInfo.tripStatus!.activeTripId,
        widget.adInfo.routeShortName,
        widget.adInfo.tripStatus!.position,
        stateInfo.getVehicleInfo,
        iconFilepath: 'assets/images/icons8-bus-96.png');
    widget.controller.animateCamera(
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
