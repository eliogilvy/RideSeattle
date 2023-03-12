import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';

import '../provider/route_provider.dart';
import '../provider/state_info.dart';

class RouteTile extends StatefulWidget {
  RouteTile({super.key, required this.routeName, required this.routeId});
  final String routeName;
  final String routeId;
  bool longpress = false;
  @override
  State<RouteTile> createState() => _RouteTileState();
}

class _RouteTileState extends State<RouteTile> {
  
  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);
    final stateInfo = Provider.of<StateInfo>(context);
    final routeProvider = Provider.of<RouteProvider>(context);
    return ListTile(
      title: Center(
        child: Text(
          widget.routeName,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      tileColor: Theme.of(context).cardTheme.color,
      onTap: () async {
        List<LatLng> routeStops =
            await stateInfo.getRoutePolyline(widget.routeId);
        stateInfo.routeFilter = widget.routeId;
        stateInfo.updateStops();

        routeProvider.setPolyLines(routeStops);
        if (mounted) {
          context.go('/');
        }
      },
      onLongPress: () => setState(() {
        widget.longpress = true;
      }),
      leading: widget.longpress
          ? IconButton(
              onPressed: () => setState(() {
                    widget.longpress = false;
                  }),
              icon: Icon(
                Icons.close,
                color: Theme.of(context).iconTheme.color,
              ))
          : null,
      trailing: widget.longpress
          ? IconButton(
              onPressed: () {
                fire.removeData(widget.routeId);
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                color: Theme.of(context).iconTheme.color,
              ))
          : null,
    );
  }
}
