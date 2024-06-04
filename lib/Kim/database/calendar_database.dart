import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CalendarDatabase {
  static final CalendarDatabase _instance = CalendarDatabase._internal();

  factory CalendarDatabase() => _instance;

  CalendarDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'calendar.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        duration INTEGER NOT NULL
      )
    ''');
  }

  Future<void> insertRecord(String date, int duration) async {
    final db = await database;

    await db.insert(
      'records',
      {'date': date, 'duration': duration},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getRecords() async {
    final db = await database;
    return await db.query('records');
  }
}
