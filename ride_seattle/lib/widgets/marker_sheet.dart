import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/widgets/arrival_and_departure_list.dart';
import 'package:ride_seattle/widgets/route_name.dart';

import '../provider/state_info.dart';

class MarkerSheet extends StatelessWidget {
  final GoogleMapController controller;
  const MarkerSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context, listen: false);
    return DraggableScrollableSheet(
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              RouteName(text: stateInfo.currentStopInfo.name),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 17, 0, 0),
                  child: Center(
                    child: ArrivalAndDepartureList(
                      scrollController: scrollController,
                      controller: controller,
                    ),
                  ),
                ),
              ),
            ],
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
