import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ride_seattle/classes/arrival_and_departure.dart';

class ArrivalAndDepartureTile extends StatelessWidget {
  final ArrivalAndDeparture adInfo;
  const ArrivalAndDepartureTile({super.key, required this.adInfo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(adInfo.routeShortName.toString()),
      trailing: IconButton(
        icon: const Icon(
          Icons.bus_alert,
        ),
        onPressed: () {
          print("hello");
        },
      ),
    );
  }
}
