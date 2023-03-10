import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_seattle/classes/auth.dart';

class FireProvider {
  FireProvider(
      {required this.fb, required this.routeId, required this.routeName});

  String routeId;
  String routeName;
  
  CollectionReference<Map<String, dynamic>> fb;
  var user = Auth().currentUser;
  Stream<QuerySnapshot> get stream {
    return fb
        .doc(user!.uid)
        .collection('routes')
        .where('route_id', isEqualTo: routeId)
        .snapshots();
  }

  Future<void> removeData() async {
    var user = Auth().currentUser;
    final routeToDelete = await fb
        .doc(user!.uid)
        .collection('routes')
        .where('route_id', isEqualTo: routeId)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.docs[0].reference;
    });

    final docTask = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('routes')
        .doc(routeToDelete.id);
    await docTask.delete();
  }

  Future<void> uploadingData() async {
    var user = Auth().currentUser;

    fb
        .doc(user!.uid)
        .collection('routes')
        .add({'route_id': routeId, 'route_name': routeName});
  }
}
