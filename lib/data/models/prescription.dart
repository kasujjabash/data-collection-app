import 'prescription_item.dart';

class Prescription {
  final String id;
  final String? patientName;
  final int? patientAge;
  final String? patientGender;
  final String? diagnosis;
  final String? imagePath;
  final DateTime createdAt;
  final String syncStatus; // 'pending' | 'synced' | 'failed'
  final List<PrescriptionItem> items;

  const Prescription({
    required this.id,
    this.patientName,
    this.patientAge,
    this.patientGender,
    this.diagnosis,
    this.imagePath,
    required this.createdAt,
    required this.syncStatus,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_name': patientName,
      'patient_age': patientAge,
      'patient_gender': patientGender,
      'diagnosis': diagnosis,
      'image_path': imagePath,
      'created_at': createdAt.millisecondsSinceEpoch,
      'sync_status': syncStatus,
    };
  }

  factory Prescription.fromMap(
    Map<String, dynamic> map,
    List<PrescriptionItem> items,
  ) {
    return Prescription(
      id: map['id'] as String,
      patientName: map['patient_name'] as String?,
      patientAge: map['patient_age'] as int?,
      patientGender: map['patient_gender'] as String?,
      diagnosis: map['diagnosis'] as String?,
      imagePath: map['image_path'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['created_at'] as int,
      ),
      syncStatus: map['sync_status'] as String,
      items: items,
    );
  }
}
