import 'package:sqflite/sqflite.dart';
import '../database/app_database.dart';
import '../models/prescription.dart';
import '../models/prescription_item.dart';

class PrescriptionRepository {
  Future<Database> get _db => AppDatabase.instance;

  Future<List<Prescription>> getAll() async {
    final db = await _db;
    final rows = await db.query('prescriptions', orderBy: 'created_at DESC');

    final List<Prescription> result = [];
    for (final row in rows) {
      final items = await _itemsFor(db, row['id'] as String);
      result.add(Prescription.fromMap(row, items));
    }
    return result;
  }

  Future<void> save(Prescription prescription) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.insert(
        'prescriptions',
        prescription.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      for (final item in prescription.items) {
        await txn.insert(
          'prescription_items',
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<void> delete(String id) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.delete(
        'prescription_items',
        where: 'prescription_id = ?',
        whereArgs: [id],
      );
      await txn.delete(
        'prescriptions',
        where: 'id = ?',
        whereArgs: [id],
      );
    });
  }

  Future<int> getTodayCount() async {
    final db = await _db;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final end =
        DateTime(now.year, now.month, now.day, 23, 59, 59).millisecondsSinceEpoch;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as c FROM prescriptions WHERE created_at BETWEEN ? AND ?',
      [start, end],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getPendingSyncCount() async {
    final db = await _db;
    final result = await db.rawQuery(
      "SELECT COUNT(*) as c FROM prescriptions WHERE sync_status = 'pending'",
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // --- private ---

  Future<List<PrescriptionItem>> _itemsFor(Database db, String prescriptionId) async {
    final rows = await db.query(
      'prescription_items',
      where: 'prescription_id = ?',
      whereArgs: [prescriptionId],
    );
    return rows.map(PrescriptionItem.fromMap).toList();
  }
}
