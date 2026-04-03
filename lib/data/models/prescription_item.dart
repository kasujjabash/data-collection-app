class PrescriptionItem {
  final String id;
  final String prescriptionId;
  final String drug;
  final String strength;
  final String form;
  final int quantity;
  final String frequency;
  final String duration;

  const PrescriptionItem({
    required this.id,
    required this.prescriptionId,
    required this.drug,
    required this.strength,
    required this.form,
    required this.quantity,
    required this.frequency,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'prescription_id': prescriptionId,
      'drug': drug,
      'strength': strength,
      'form': form,
      'quantity': quantity,
      'frequency': frequency,
      'duration': duration,
    };
  }

  factory PrescriptionItem.fromMap(Map<String, dynamic> map) {
    return PrescriptionItem(
      id: map['id'] as String,
      prescriptionId: map['prescription_id'] as String,
      drug: map['drug'] as String,
      strength: map['strength'] as String,
      form: map['form'] as String,
      quantity: map['quantity'] as int,
      frequency: map['frequency'] as String,
      duration: map['duration'] as String,
    );
  }
}
