import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/classes/old_stops.dart';

import '../provider/local_storage_provider.dart';
import '../widgets/history_tile.dart';

class StopHistory extends StatefulWidget {
  const StopHistory({Key? key}) : super(key: key);

  @override
  State<StopHistory> createState() => _StopHistoryState();
}

class _StopHistoryState extends State<StopHistory> {
  @override
  Widget build(BuildContext context) {
    final hive = Provider.of<LocalStorageProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stop History'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ValueListenableBuilder<Box<OldStops>>(
              valueListenable: hive.history.listenable(),
              builder: (context, box, _) {
                final history = box.values.toList();
                if (history.isEmpty) {
                  return Center(
                    child: Text(
                      'History is empty',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final oldStop = history[index];
                      return Card(
                        child: HistoryTile(
                            stopName: oldStop.name, stopId: oldStop.stopId),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
