import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../classes/stop.dart';
import '../provider/state_info.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  GoogleMapController? googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(47.6219, -122.3517), zoom: 12);
  Map<String, Marker> markers = {};

  set currentCenter(position) => currentCenter = position;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User current location"),
        centerTitle: true,
      ),
      body: Consumer<StateInfo>(
        builder: (context, stateInfo, child) => GoogleMap(
          initialCameraPosition: initialCameraPosition,
          markers: stateInfo.markers,
          circles: stateInfo.circles,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          },
          onCameraIdle: () async {
            print("idle");
            final LatLng center = await getCurrentCenter(googleMapController!);
            final LatLng currentCenter =
                LatLng(center.latitude, center.longitude);
            await stateInfo.getPosition();
            await stateInfo.setRadius(
                currentCenter,
                await getTopOfScreen(googleMapController!),
                await getTopOfScreen(googleMapController!));
            stateInfo.getStopsForLocation(currentCenter.latitude.toString(),
                currentCenter.longitude.toString());
            stateInfo.addCircle(currentCenter, 'searchRadius');
          },
        ),
      ),
      floatingActionButton:
          Consumer<StateInfo>(builder: (context, stateInfo, child) {
        return FloatingActionButton(
            onPressed: () async {
              Position position = stateInfo.position;
              googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 16,
                  ),
                ),
              );
              stateInfo.addMarker('currentLocation',
                  LatLng(position.latitude, position.longitude));
            },
            child: const Icon(Icons.location_history));
      }),
    );
  }

  Future<LatLng> getTopOfScreen(GoogleMapController controller) {
    return controller.getVisibleRegion().then(((value) {
      return value.northeast;
    }));
  }

  Future<LatLng> getCurrentCenter(GoogleMapController controller) {
    return controller.getVisibleRegion().then((value) {
      return LatLng((value.southwest.latitude + value.northeast.latitude) / 2,
          (value.southwest.longitude + value.northeast.longitude) / 2);
    });
  }
}
