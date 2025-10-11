import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bursaconnect/Users/Models/user_model.dart';

class AllApplicantsService {
  final CollectionReference _users =
  FirebaseFirestore.instance.collection('users');

  Stream<List<AppUser>> getAllAppliedStudents() {
    return _users.snapshots().map((snapshot) {
      // Convert all docs to AppUser
      final users = snapshot.docs.map((doc) {
        return AppUser.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // 🔹 Filter only users who have applied bursaries
      final appliedStudents = users
          .where((user) =>
      user.appliedBursaries != null &&
          user.appliedBursaries!.isNotEmpty)
          .toList();

      return appliedStudents;
    });
  }
}