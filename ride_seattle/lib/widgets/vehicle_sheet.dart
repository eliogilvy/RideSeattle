import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/state_info.dart';

class VehicleSheet extends StatelessWidget {
  const VehicleSheet({
    super.key,
  });

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
                future: stateInfo.getStop(stateInfo.vehicleStatus!.nextStop),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Card(

                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)
                          )
                      ),

                      child: ListTile(

                        leading: const Icon(Icons.location_on),
                        title: Text(
                          'Next Stop: ${snapshot.data}',
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                    )
                ),

                child: ListTile(

                  leading: const Icon(Icons.timer),
                  title: Text(
                    'Location updated: ${time(stateInfo.vehicleStatus!.lastLocationUpdateTime, 'h:mm a')}',
                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                  ),
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
