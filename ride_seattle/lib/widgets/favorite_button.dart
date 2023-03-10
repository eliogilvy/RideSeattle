import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/firebase_provider.dart';
import 'package:ride_seattle/provider/local_storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/auth.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton(
      {super.key,
      required this.routeId,
      required this.routeName,
      required this.callback});
  final String routeId;
  final String routeName;
  final Function callback;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorited = false;

  // Future<void> getData() async {
  //   var user = Auth().currentUser;

  //   var data = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user!.uid)
  //       .collection('routes')
  //       .where('route_id', isEqualTo: widget.routeId)
  //       .get();

  //   int dataLength = data.docs.length;
  //   isFavorited = dataLength > 0 ? true : false;
  // }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<LocalStorageProvider>(context, listen: false);
    var fb = FirebaseFirestore.instance.collection('users');
    FireProvider fire = FireProvider(
        fb: fb, routeId: widget.routeId, routeName: widget.routeName);
    Stream<QuerySnapshot> stream = fire.stream;

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.star_border,
            ),
          );
        } else {
          return snapshot.data!.docs.isEmpty
              ? IconButton(
                  tooltip: "Add to favorites",
                  icon: const Icon(
                    Icons.star_border,
                  ),
                  onPressed: () async {
                    storage.addRoute(widget.routeId);
                    fire.uploadingData();
                    setState(() {});
                    widget.callback();
                  },
                )
              : IconButton(
                  tooltip: "Remove from favorites",
                  icon: const Icon(
                    Icons.star,
                  ),
                  onPressed: () async {
                    fire.removeData();
                    setState(() {});
                    widget.callback();
                  },
                );
        }
      },
    );
  }
}
