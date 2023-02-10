import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/widgets/marker_sheet.dart';
import '../provider/state_info.dart';
import '../widgets/navDrawer.dart';
import '../classes/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  GoogleMapController? googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(47.6219, -122.3517), zoom: 16);
  Map<String, Marker> markers = {};
  final User? user = Auth().currentUser;

  set currentCenter(position) => currentCenter = position;

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context, listen: true);
    return Scaffold(
      drawer: navDrawer(),
      body: Builder(
        builder: (context) => GoogleMap(
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          initialCameraPosition: initialCameraPosition,
          markers: stateInfo.markers,
          circles: stateInfo.circles,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            googleMapController = controller;
          },
          onTap: (argument) {
            stateInfo.showMarkerInfo = false;
            Navigator.of(context).maybePop();
          },
          onCameraIdle: () {
            updateView(stateInfo);
            if (stateInfo.showMarkerInfo) {
              Scaffold.of(context).showBottomSheet(
                (BuildContext context) {
                  return MarkerSheet(controller: googleMapController!);
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
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
              // await stateInfo.addMarker(
              //     'currentLocation',
              //     LatLng(position.latitude, position.longitude),
              //     stateInfo.getMarkerInfo);
            },
            child: const Icon(Icons.location_history),
          ),
          FloatingActionButton(
            onPressed: signOut,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  Future<LatLng> getTopOfScreen(GoogleMapController controller) {
    return controller.getVisibleRegion().then(((value) {
      return value.northeast;
    }));
  }

  Future<LatLng> getBottomOfScreen(GoogleMapController controller) {
    return controller.getVisibleRegion().then(((value) {
      return value.southwest;
    }));
  }

  Future<LatLng> getCurrentCenter(GoogleMapController controller) {
    return controller.getVisibleRegion().then((value) {
      return LatLng((value.southwest.latitude + value.northeast.latitude) / 2,
          (value.southwest.longitude + value.northeast.longitude) / 2);
    });
  }

  Future<void> updateView(StateInfo stateInfo) async {
    final LatLng center = await getCurrentCenter(googleMapController!);
    final LatLng currentCenter = LatLng(center.latitude, center.longitude);
    await stateInfo.getPosition();
    await stateInfo.setRadius(
        currentCenter,
        await getTopOfScreen(googleMapController!),
        await getBottomOfScreen(googleMapController!));
    stateInfo.getStopsForLocation(
        currentCenter.latitude.toString(), currentCenter.longitude.toString());
    stateInfo.addCircle(currentCenter, 'searchRadius');
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }
}
