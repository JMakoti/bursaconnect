import 'package:bursaconnect/Users/Models/bursary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class BursaryService{
  final CollectionReference _allBursaries = FirebaseFirestore.instance.collection("bursaries");

/// Stream all bursaries in real-time
  Stream<List<Bursary>> get_all_bursaries() {
     return _allBursaries.snapshots().map((snapshot){
       return snapshot.docs.map((doc){
         return Bursary.fromJson(
           doc.data() as Map<String, dynamic>,
           doc.id,

         );
       }).toList();
     });
  }

  /// Fetch a single bursary by its ID (optional helper)
  Future<Bursary?> getBursaryById(String id) async {
    final doc = await _allBursaries.doc(id).get();
    if (!doc.exists) return null;
    return Bursary.fromJson(doc.data() as Map<String, dynamic>, doc.id);
  }

}