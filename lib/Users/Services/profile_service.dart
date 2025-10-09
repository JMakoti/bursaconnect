import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/student.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetch the current logged-in user's profile from `users`
  Future<Map<String, dynamic>?> getUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  /// Get user data by ID from `users` collection
  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) return doc.data();
      return null;
    } catch (e) {
      print('❌ Error fetching user: $e');
      return null;
    }
  }

  /// Get student profile (education + attachments)
  Future<Student?> getStudentByUserId(String userId) async {
    try {
      final query = await _firestore
          .collection('students')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (query.docs.isEmpty) return null;

      final data = query.docs.first.data();
      return Student.fromJson(data);
    } catch (e) {
      print('❌ Error fetching student: $e');
      return null;
    }
  }

  /// Update a user's general details (from `users` collection)
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception('No authenticated user.');

      await _firestore.collection('users').doc(uid).update(data);
      print('✅ User profile updated successfully');
    } catch (e) {
      print('❌ Error updating user profile: $e');
      rethrow;
    }
  }

  /// Update or create a student's profile in `students` collection
  Future<void> updateStudentProfile(Student student) async {
    try {
      await _firestore.collection('students').doc(student.userId).set(
            student.toJson(),
            SetOptions(merge: true), // Keeps existing data
          );
      print('✅ Student profile updated successfully');
    } catch (e) {
      print('❌ Error updating student profile: $e');
      rethrow;
    }
  }

  /// Fetch student profile by userId (direct doc fetch)
  Future<Student?> getStudentProfile(String userId) async {
    try {
      final doc = await _firestore.collection('students').doc(userId).get();
      if (doc.exists) {
        return Student.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('❌ Error fetching student profile: $e');
      rethrow;
    }
  }

  /// Fetch user details (for joining with student info)
  Future<Map<String, dynamic>?> getUserDetails(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }

  /// Fetch bursary info using `bursaryId` from student
  Future<Map<String, dynamic>?> getBursaryInfo(String bursaryId) async {
    try {
      final doc =
          await _firestore.collection('bursaries').doc(bursaryId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('❌ Error fetching bursary info: $e');
      return null;
    }
  }
}
