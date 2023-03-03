import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/route_provider.dart';

import '../provider/state_info.dart';

class RouteList extends StatelessWidget {
  const RouteList({super.key});

  @override
  Widget build(BuildContext context) {
    final stateInfo = Provider.of<StateInfo>(context);
    final routeProvider = Provider.of<RouteProvider>(context);
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: stateInfo.routes.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          final route = stateInfo.routes[index];
          return InkWell(
            onTap: () async {
              stateInfo.routeFilter = route.routeId;
              stateInfo.updateStops();

              routeProvider.setPolyLines(
                await stateInfo
                    .getRoutePolyline(stateInfo.routes[index].routeId),
              );
              // ignore: use_build_context_synchronously
              if (context.canPop()) context.pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                route.shortName!,
              ),
            ),
          );
        },
      ),
    );
  }
}
