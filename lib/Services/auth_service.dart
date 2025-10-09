import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Sign Up Error: $e');
      return null;
    }
  }

   // Sign in and get user role
  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // 🔹 Fetch user role from Firestore
        DocumentSnapshot<Map<String, dynamic>> snapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          final data = snapshot.data();
          return {
            'user': user,
            'role': data?['role'] ?? 'User', // default to 'User'
          };
        } else {
          print('User record not found in Firestore.');
        }
      }

      return null;
    } catch (e) {
      print('Sign In Error: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current logged-in user
  User? get currentUser => _auth.currentUser;
}
