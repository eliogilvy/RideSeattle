import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehicleSheet extends StatelessWidget {
  const VehicleSheet({super.key, required this.controller});

  final GoogleMapController controller;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      builder: (context, scrollController) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
          ),
        );
      },
    );
  }
}
