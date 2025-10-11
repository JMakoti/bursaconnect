import 'package:bursaconnect/Users/Models/bursary.dart';
import 'package:bursaconnect/Admin/Services/ActiveBussaries.dart';
import 'package:bursaconnect/Admin/Services/AllApplicants.dart';
import 'package:bursaconnect/Users/Models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class BursaryNotifier with ChangeNotifier {
  final BursaryService _bursaryService = BursaryService();
  List<Bursary> _bursaries = [];

  List<Bursary> get bursaries => _bursaries;

  void listen_to_bursaries() {
    _bursaryService.get_all_bursaries().listen((data) {
      _bursaries = data;
      notifyListeners();
    });
  }
}

class AllApplicants with ChangeNotifier{
  final _usersCollection = FirebaseFirestore.instance.collection('users');
  final AllApplicantsService _applicantsService = AllApplicantsService();
  List<AppUser> _allapplicants = [];
  List<AppUser> get allapplicants => _allapplicants;
  void listenToAppliedStudents() {
    _applicantsService.getAllAppliedStudents().listen((data) {
      _allapplicants = data;
      notifyListeners();
    });
  }
  }
