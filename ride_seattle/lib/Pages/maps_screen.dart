import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/widgets/marker_sheet.dart';
import '../provider/state_info.dart';
import '../widgets/nav_drawer.dart';
import '../classes/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late String _mapStyle;

  GoogleMapController? googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(47.6219, -122.3517), zoom: 16);

  final TextEditingController _searchController = TextEditingController();

  @override
  initState() {
    super.initState();
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;
    final stateInfo = Provider.of<StateInfo>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Seattle'),
      ),
      drawer: const NavDrawer(),
      body: Column(children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(hintText: 'Search for stops'),
                onChanged: (value) {
                  print(value);
                },
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
          ],
        ),
        Expanded(
          child: Builder(
            builder: (context) => GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition: initialCameraPosition,
              markers: stateInfo.markers,
              mapToolbarEnabled: false,
              //circles: stateInfo.circles,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                if (mounted) {
                  setState(() {
                    googleMapController = controller;
                    controller.setMapStyle(_mapStyle);
                  });
                }
              },
              onTap: (argument) {
                stateInfo.showMarkerInfo = false;
                Navigator.of(context).maybePop();
              },

              onCameraIdle: () {
                updateView(stateInfo);
                if (stateInfo.showMarkerInfo) {
                  _showBottomSheet(context, stateInfo);
                }
              },
            ),
          ),
        ),
      ]),
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
    stateInfo.addCircle(currentCenter, 'searchRadius');
  }

  void _showBottomSheet(BuildContext context, StateInfo stateInfo) {
    Scaffold.of(context)
        .showBottomSheet(
          (BuildContext context) {
            return MarkerSheet(controller: googleMapController!);
          },
        )
        .closed
        .whenComplete(() => stateInfo.showMarkerInfo = false);
  }
}
