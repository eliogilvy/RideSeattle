import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/widgets/arrival_and_departure_tile.dart';

import '../provider/state_info.dart';

class ArrivalAndDepartureList extends StatefulWidget {
  final ScrollController scrollController;
  const ArrivalAndDepartureList({super.key, required this.scrollController});

  @override
  State<ArrivalAndDepartureList> createState() =>
      _ArrivalAndDepartureListState();
}

class _ArrivalAndDepartureListState extends State<ArrivalAndDepartureList> {
  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context, listen: true);
    return ListView.builder(
        controller: widget.scrollController,
        itemCount: stateInfo.currentStopInfo.arrivalAndDeparture.values.length,
        itemBuilder: (BuildContext context, int index) {
          return ArrivalAndDepartureTile(
              adInfo: stateInfo.currentStopInfo.arrivalAndDepartureList[index]);
        });
  }
}
