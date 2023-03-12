import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';
import 'package:ride_seattle/provider/local_storage_provider.dart';

import '../provider/route_provider.dart';
import '../provider/state_info.dart';

class HistoryTile extends StatefulWidget {
  HistoryTile({super.key, required this.stopName, required this.stopId});
  final String stopName;
  final String stopId;
  bool longpress = false;
  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  final fire = FireProvider(fb: FirebaseFirestore.instance.collection('users'));

  @override
  Widget build(BuildContext context) {
    final hive = Provider.of<LocalStorageProvider>(context);
    return ListTile(
      title: Center(
        child: Text(
          widget.stopName,
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      tileColor: Theme.of(context).cardTheme.color,
      onLongPress: () => setState(
        () {
          widget.longpress = true;
        },
      ),
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
              onPressed: () async {
                print('deleting ${widget.stopName}');
                await hive.history.delete(widget.stopId);
                setState(() {
                  widget.longpress = false;
                });
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
            )
          : null,
    );
  }
}
