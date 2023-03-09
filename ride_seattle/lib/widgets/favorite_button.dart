import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_seattle/provider/local_storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/auth.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton(
      {super.key, required this.routeId, required this.callback});
  final String routeId;
  final Function callback;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorited = false;
  @override
  void initState() {
    super.initState();
    getData();
    print(isFavorited);
  }

  Future<void> getData() async {
    var user = Auth().currentUser;

    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('routes')
        .where('route_id', isEqualTo: widget.routeId)
        .get();

    int dataLength = await data.docs.length;
    if (dataLength > 0) {
      isFavorited = true;
    }
  }

  Future<void> uploadingData() async {
    var user = Auth().currentUser;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection('routes')
        .add({'route_id': widget.routeId});

    setState(() {
      isFavorited = true;
    });
  }

  Future<void> removeData() async {
    var user = Auth().currentUser;
    final routeToDelete = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('routes')
        .where('route_id', isEqualTo: widget.routeId)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.docs[0].reference;
    });
    final docTask = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('routes')
        .doc(routeToDelete.id);
    docTask.delete();

    setState(() {
      isFavorited = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final storage = Provider.of<LocalStorageProvider>(context, listen: false);

    return !isFavorited
        ? IconButton(
            tooltip: "Add to favorites",
            icon: const Icon(
              Icons.star_border,
            ),
            onPressed: () {
              storage.addRoute(widget.routeId);
              uploadingData();
              widget.callback();
            },
          )
        : IconButton(
            tooltip: "Remove from favorites",
            icon: const Icon(
              Icons.star,
            ),
            onPressed: () {
              removeData();
            },
          );
  }
}
