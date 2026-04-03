import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  AppDatabase._();

  static Database? _instance;

  static Future<Database> get instance async {
    _instance ??= await _open();
    return _instance!;
  }

  static Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'pharmacy.db');

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE prescriptions (
        id            TEXT    PRIMARY KEY,
        patient_name  TEXT,
        patient_age   INTEGER,
        patient_gender TEXT,
        diagnosis     TEXT,
        image_path    TEXT,
        created_at    INTEGER NOT NULL,
        sync_status   TEXT    NOT NULL DEFAULT 'pending'
      )
    ''');

    await db.execute('''
      CREATE TABLE prescription_items (
        id              TEXT    PRIMARY KEY,
        prescription_id TEXT    NOT NULL,
        drug            TEXT    NOT NULL,
        strength        TEXT    NOT NULL,
        form            TEXT    NOT NULL,
        quantity        INTEGER NOT NULL,
        frequency       TEXT    NOT NULL,
        duration        TEXT    NOT NULL,
        FOREIGN KEY (prescription_id)
          REFERENCES prescriptions (id)
          ON DELETE CASCADE
      )
    ''');
  }
}
