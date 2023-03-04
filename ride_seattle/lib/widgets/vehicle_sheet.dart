import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/state_info.dart';

class VehicleSheet extends StatelessWidget {
  const VehicleSheet({super.key, required this.controller});

  final GoogleMapController controller;

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context, listen: true);
    return DraggableScrollableSheet(
      controller: DraggableScrollableController(),
      expand: false,
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: ListView(
            controller: scrollController,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: [
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Text('Next Stop: ${stateInfo.vehicleStatus!.nextStop}'),
              ),
              ListTile(
                leading: const Icon(Icons.timer),
                title: Text(
                  'Location updated: ${time(stateInfo.vehicleStatus!.lastLocationUpdateTime, 'h:mm a')}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(
                  'Scheduled arrival: ${time(stateInfo.vehicleStatus!.nextStopTimeOffset, 'm')}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String time(int t, String format) {
    String f = DateFormat(format).format(
      DateTime.fromMillisecondsSinceEpoch(t),
    );
    if (f == '0') {
      return 'NOW';
    }
    return f;
  }
}
