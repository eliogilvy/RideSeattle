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
  bool tapped = false;
  @override
  State<HistoryTile> createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  @override
  Widget build(BuildContext context) {
    final fire = Provider.of<FireProvider>(context);
    final hive = Provider.of<LocalStorageProvider>(context);
    return ListTile(
      title: Center(
        child: Text(
          widget.stopName,
          style: const TextStyle(
            color: Colors.white,
          ),//Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ),

      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10)
          )
      ),
      tileColor: Colors.blue,//Theme.of(context).cardTheme.color,
      onTap: () => setState(
        () {
          widget.tapped = true;
        },
      ),
      leading: widget.tapped
          ? IconButton(
              onPressed: () => setState(() {
                    widget.tapped = false;
                  }),
              icon: const Icon(
                Icons.close,
                color: Colors.white, //Theme.of(context).iconTheme.color,
              ))
          : null,
      trailing: widget.tapped
          ? IconButton(
              onPressed: () async {
                widget.tapped = false;
                await hive.history.delete(widget.stopId);
              },
              icon: Icon(
                Icons.delete_forever_outlined,
                color: Colors.white,//Theme.of(context).iconTheme.color,
              ),
            )
          : null,
    );
  }
}
