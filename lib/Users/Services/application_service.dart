import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApplicationService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Adds a bursary to the user's applied list.
  Future<void> applyForBursary(String bursaryId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    final userRef = _firestore.collection('users').doc(user.uid);

    await userRef.set({
      'appliedBursaries': FieldValue.arrayUnion([bursaryId]),
    }, SetOptions(merge: true));
  }

    /// Fetches the list of applied bursary IDs for the logged-in user.
  Future<List<String>> getAppliedBursaries() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }

    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (userDoc.exists && userDoc.data()!.containsKey('appliedBursaries')) {
      final bursaries = List<String>.from(userDoc['appliedBursaries']);
      return bursaries;
    } else {
      return [];
    }
  }

  /// Fetch full bursary details (if you have a 'bursaries' collection)
  Future<List<Map<String, dynamic>>> getAppliedBursaryDetails() async {
    final appliedIds = await getAppliedBursaries();

    if (appliedIds.isEmpty) return [];

    final bursariesSnapshot = await _firestore
        .collection('bursaries')
        .where(FieldPath.documentId, whereIn: appliedIds)
        .get();

    return bursariesSnapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }
}
