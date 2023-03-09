import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/widgets/marker_sheet.dart';
import '../provider/route_provider.dart';
import '../provider/state_info.dart';
import '../widgets/nav_drawer.dart';
import 'package:go_router/go_router.dart';

import '../widgets/route_list.dart';
import '../widgets/vehicle_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late String _mapStyle;
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleMapController? googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(47.6219, -122.3517), zoom: 16);

  @override
  initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    //final User? user = Auth().currentUser;
    final stateInfo = Provider.of<StateInfo>(context, listen: true);
    final routeProvider = Provider.of<RouteProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Seattle'),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text("Find a route"),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  onPressed: () {
                                    stateInfo.routeFilter = null;
                                    routeProvider.clearPolylines();
                                    if (context.canPop()) context.pop();
                                  },
                                  icon: const Icon(Icons.refresh_rounded),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const RouteList(),
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.filter_alt_outlined),
          ),
        ],
      ),
      drawer: const NavDrawer(),
      body: Column(
        children: [
          Flexible(
            child: GoogleMap(
              rotateGesturesEnabled: false,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition: initialCameraPosition,
              markers: stateInfo.markers,
              mapToolbarEnabled: false,
              //circles: stateInfo.circles,
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                if (mounted) {
                  setState(() {
                    googleMapController = controller;
                    controller.setMapStyle(_mapStyle);
                  });
                }
              },
              onTap: (argument) {
                if (mounted) {
                  stateInfo.showVehicleInfo = false;
                  stateInfo.showMarkerInfo = false;
                  stateInfo.removeMarker('current');
                  routeProvider.clearPolylines();
                  stateInfo.removeMarker(stateInfo.lastVehicle);
                }
              },
              onCameraIdle: () {
                updateView(stateInfo);
              },
              polylines: routeProvider.routePolyLine,
            ),
          ),
        ],
      ),
      bottomSheet: stateInfo.showMarkerInfo
          ? MarkerSheet(controller: googleMapController!)
          : stateInfo.showVehicleInfo
              ? VehicleSheet(controller: googleMapController!)
              : null,
      floatingActionButton: FloatingActionButton.small(
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
        },
        child: const Icon(Icons.location_history),
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
    stateInfo.setRadius(
        currentCenter,
        await getTopOfScreen(googleMapController!),
        await getBottomOfScreen(googleMapController!));
    stateInfo.getStopsForLocation(
        currentCenter.latitude.toString(), currentCenter.longitude.toString());
    stateInfo.getRoutesForLocation(
        currentCenter.latitude.toString(), currentCenter.longitude.toString());
    stateInfo.addCircle(currentCenter, 'searchRadius');
  }
}
