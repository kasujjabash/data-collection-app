/// Static reference tables for structured data entry.
/// All dropdowns in the app draw from these lists to enforce standardization.
class DrugDictionary {
  DrugDictionary._();

  static const List<String> drugs = [
    'Amoxicillin',
    'Ampicillin',
    'Artemether/Lumefantrine',
    'Azithromycin',
    'Chloroquine',
    'Ciprofloxacin',
    'Cloxacillin',
    'Cotrimoxazole',
    'Diclofenac',
    'Doxycycline',
    'Erythromycin',
    'Ferrous Sulfate',
    'Fluconazole',
    'Folic Acid',
    'Gentamicin',
    'Ibuprofen',
    'Metformin',
    'Metronidazole',
    'Omeprazole',
    'ORS',
    'Paracetamol',
    'Prednisolone',
    'Salbutamol',
    'Zinc Sulfate',
  ];

  static const List<String> strengths = [
    '5mg',
    '10mg',
    '20mg',
    '25mg',
    '40mg',
    '50mg',
    '100mg',
    '125mg',
    '200mg',
    '250mg',
    '400mg',
    '500mg',
    '600mg',
    '800mg',
    '1g',
    '2g',
  ];

  static const List<String> forms = [
    'Capsule',
    'Cream',
    'Drops',
    'Injection',
    'Powder',
    'Suppository',
    'Suspension',
    'Syrup',
    'Tablet',
  ];

  static const List<String> frequencies = [
    'OD – Once Daily',
    'BD – Twice Daily',
    'TDS – Three Times Daily',
    'QID – Four Times Daily',
    'PRN – As Needed',
    'Stat – Immediately',
    'Weekly',
  ];

  static const List<String> durations = [
    '1 day',
    '2 days',
    '3 days',
    '5 days',
    '7 days',
    '10 days',
    '14 days',
    '21 days',
    '28 days',
    '1 month',
    '2 months',
    '3 months',
  ];
}
