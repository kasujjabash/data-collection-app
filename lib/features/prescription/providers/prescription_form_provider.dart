import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/prescription.dart';
import '../../../data/models/prescription_item.dart';
import '../../../data/repositories/prescription_repository.dart';

/// Mutable state for a single drug entry in the form.
class DrugFormData {
  String? drug;
  String? strength;
  String? form;
  String? quantity;
  String? frequency;
  String? duration;

  DrugFormData({
    this.drug,
    this.strength,
    this.form,
    this.quantity,
    this.frequency,
    this.duration,
  });

  DrugFormData copyWith({
    String? drug,
    String? strength,
    String? form,
    String? quantity,
    String? frequency,
    String? duration,
  }) {
    return DrugFormData(
      drug: drug ?? this.drug,
      strength: strength ?? this.strength,
      form: form ?? this.form,
      quantity: quantity ?? this.quantity,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
    );
  }

  bool get isValid =>
      drug != null &&
      strength != null &&
      form != null &&
      (quantity?.isNotEmpty ?? false) &&
      frequency != null &&
      duration != null;
}

class PrescriptionFormProvider extends ChangeNotifier {
  final PrescriptionRepository _repository;
  static const _uuid = Uuid();

  // Patient info
  String? patientName;
  String? patientAge;
  String? patientGender;
  String? diagnosis;
  String? imagePath;

  // Drug list — starts with one empty entry
  List<DrugFormData> drugs = [DrugFormData()];

  bool _isSaving = false;
  String? error;

  PrescriptionFormProvider(this._repository);

  bool get isSaving => _isSaving;
  bool get isValid => drugs.isNotEmpty && drugs.every((d) => d.isValid);

  // --- patient field setters (no notify needed — called from onChanged) ---

  void setPatientName(String v) => patientName = v.trim().isEmpty ? null : v.trim();
  void setPatientAge(String v) => patientAge = v.isEmpty ? null : v;
  void setDiagnosis(String v) => diagnosis = v.trim().isEmpty ? null : v.trim();

  void setPatientGender(String? v) {
    patientGender = v;
    notifyListeners();
  }

  void setImagePath(String? path) {
    imagePath = path;
    notifyListeners();
  }

  // --- drug list management ---

  void addDrug() {
    drugs = [...drugs, DrugFormData()];
    notifyListeners();
  }

  void removeDrug(int index) {
    if (drugs.length <= 1) return;
    drugs = List.of(drugs)..removeAt(index);
    notifyListeners();
  }

  void updateDrug(int index, DrugFormData updated) {
    drugs = List.of(drugs)..[index] = updated;
    notifyListeners();
  }

  // --- save ---

  Future<bool> save() async {
    if (!isValid) {
      error = 'Please complete all required drug fields.';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    error = null;
    notifyListeners();

    try {
      final prescriptionId = _uuid.v4();

      final items = drugs.map((d) {
        return PrescriptionItem(
          id: _uuid.v4(),
          prescriptionId: prescriptionId,
          drug: d.drug!,
          strength: d.strength!,
          form: d.form!,
          quantity: int.tryParse(d.quantity ?? '1') ?? 1,
          frequency: d.frequency!,
          duration: d.duration!,
        );
      }).toList();

      await _repository.save(
        Prescription(
          id: prescriptionId,
          patientName: patientName,
          patientAge: int.tryParse(patientAge ?? ''),
          patientGender: patientGender,
          diagnosis: diagnosis,
          imagePath: imagePath,
          createdAt: DateTime.now(),
          syncStatus: 'pending',
          items: items,
        ),
      );

      return true;
    } catch (_) {
      error = 'Failed to save. Please try again.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
