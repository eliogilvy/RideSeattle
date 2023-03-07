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
      maxChildSize: 0.3,
      builder: (context, scrollController) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: ListView(
            controller: scrollController,
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: [
              FutureBuilder<String>(
                future: stateInfo.getStop(stateInfo.vehicleStatus!
                    .nextStop), // Future<String> to build your widget tree
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(
                        'Next Stop: ${snapshot.data}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  } else {
                    return const Center(
                        child:
                            CircularProgressIndicator()); // Show a loading indicator while waiting for the future to complete
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.timer),
                title: Text(
                  'Location updated: ${time(stateInfo.vehicleStatus!.lastLocationUpdateTime, 'h:mm a')}',
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
