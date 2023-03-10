import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ride_seattle/classes/auth.dart';
import 'package:ride_seattle/classes/fav_route.dart';

class FireProvider with ChangeNotifier {
  FireProvider({required this.fb, required this.auth}) {
    user = auth.currentUser;
  }

  Auth auth;

  CollectionReference<Map<String, dynamic>> fb;
  var user;

  Stream<QuerySnapshot> routeStream(String routeId) {
    return fb
        .doc(user!.uid)
        .collection('routes')
        .where('route_id', isEqualTo: routeId)
        .snapshots();
  }

  Stream<List<FavoriteRoute>> get routeList => fb
      .doc(user!.uid)
      .collection('routes')
      .orderBy('route_name')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => FavoriteRoute.fromJson(doc.data()))
          .toList());

  Future<void> removeData(String routeId) async {
    var user = auth.currentUser;
    final routeToDelete = await fb
        .doc(user!.uid)
        .collection('routes')
        .where('route_id', isEqualTo: routeId)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.docs[0].reference;
    });

    final docTask = fb.doc(user.uid).collection('routes').doc(routeToDelete.id);
    await docTask.delete();
  }

  Future<void> uploadingData(String routeId, String routeName) async {
    var user = auth.currentUser;

    fb
        .doc(user!.uid)
        .collection('routes')
        .add({'route_id': routeId, 'route_name': routeName});
  }
}
