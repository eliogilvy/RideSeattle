import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_seattle/widgets/arrival_and_departure_list.dart';

class MarkerSheet extends StatelessWidget {
  final GoogleMapController controller;
  const MarkerSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          height: 100,
          color: Colors.lightBlueAccent,
          child: Center(
            child: ArrivalAndDepartureList(
              scrollController: scrollController,
              controller: controller,
            ),
          ),
        );
      },
      expand: false,
      initialChildSize: 0.2,
      maxChildSize: 0.5,
      minChildSize: 0.2,
    );
  }
}
