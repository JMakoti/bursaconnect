import 'package:bursaconnect/Users/Models/bursary.dart';
import 'package:bursaconnect/Admin/Services/ActiveBussaries.dart';
import 'package:flutter/foundation.dart';

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