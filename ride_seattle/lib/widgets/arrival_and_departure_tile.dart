import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';

import '../provider/state_info.dart';

class ArrivalAndDepartureTile extends StatelessWidget {
  final ArrivalAndDeparture adInfo;
  final GoogleMapController controller;
  const ArrivalAndDepartureTile(
      {super.key, required this.adInfo, required this.controller});

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context, listen: false);
    return ListTile(
      title: Text(adInfo.routeShortName.toString()),
      trailing: IconButton(
        icon: const Icon(
          Icons.bus_alert,
        ),
        onPressed: () async {
          await stateInfo.addMarker(
              'vehicle', adInfo.routeShortName, adInfo.tripStatus.position, stateInfo.getVehicleInfo,
              iconFilepath: 'assets/images/icons8-trolleybus-30.png');
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: adInfo.tripStatus.position,
                zoom: 16,
              ),
            ),
          );
        },
      ),
    );
  }
}
