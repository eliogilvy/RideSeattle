import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class CurrentLocationScreen extends StatefulWidget {
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  State<CurrentLocationScreen> createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {

  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(37, -122), zoom: 14);

  Map<String, Marker> markers = {};



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User current location") ,
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers.values.toSet(),
        zoomControlsEnabled: false,
        mapType: MapType.normal,


        onMapCreated: (GoogleMapController controller){
          googleMapController = controller;

        },),

      floatingActionButton: FloatingActionButton.extended(onPressed: () async {

        Position position = await _determinePosition();

        googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 14)));

        markers.clear();

        addMarker('currentLocation', LatLng(position.latitude,position.longitude));

        setState(() {

        });

      },
          label: const Text("Current Location"),
          icon: const Icon(Icons.location_history)
      ),
    );
  }

  addMarker(String id, LatLng location)
  {
    var marker = Marker(
        markerId: MarkerId(id),
        position: location,
        infoWindow: const InfoWindow(title: 'Location of thing', snippet: 'Some Description'),
    );

    markers[id] = marker;
    setState(() {

    });
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled){
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location Permission denied");
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error("Location permission denied permanently");
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;

  }
}
