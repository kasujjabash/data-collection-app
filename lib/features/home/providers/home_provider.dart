import 'package:flutter/foundation.dart';
import '../../../data/models/prescription.dart';
import '../../../data/repositories/prescription_repository.dart';

class HomeProvider extends ChangeNotifier {
  final PrescriptionRepository repository;

  List<Prescription> _prescriptions = [];
  int _todayCount = 0;
  int _pendingSyncCount = 0;
  bool _isLoading = false;

  HomeProvider(this.repository) {
    load();
  }

  List<Prescription> get prescriptions => List.unmodifiable(_prescriptions);
  int get todayCount => _todayCount;
  int get pendingSyncCount => _pendingSyncCount;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    try {
      _prescriptions = await repository.getAll();
      _todayCount = await repository.getTodayCount();
      _pendingSyncCount = await repository.getPendingSyncCount();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> delete(String id) async {
    await repository.delete(id);
    await load();
  }
}
