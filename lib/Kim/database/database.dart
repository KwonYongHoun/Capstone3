import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Database App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Database _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'fitness_database.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  _createDb(Database db, int version) async {
    // Member Table
    await db.execute('''
      CREATE TABLE Member (
        memberID INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');

    // Record Table
    await db.execute('''
      CREATE TABLE Record (
        recordID INTEGER PRIMARY KEY AUTOINCREMENT,
        memberID INTEGER,
        date TEXT,
        entryTime TEXT,
        exitTime TEXT,
        equipmentUsed TEXT,
        FOREIGN KEY (memberID) REFERENCES Member(memberID)
      )
    ''');

    // Stats Table
    await db.execute('''
      CREATE TABLE Stats (
        statsID INTEGER PRIMARY KEY AUTOINCREMENT,
        memberID INTEGER,
        exerciseTime INTEGER,
        equipmentUsed TEXT,
        FOREIGN KEY (memberID) REFERENCES Member(memberID)
      )
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Database App'),
      ),
      body: const Center(
        child: Text('Database Initialized'),
      ),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('exercise.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
    CREATE TABLE exercise (
      id $idType,
      duration $textType,
      date $textType
    )
    ''');
  }

  Future<int> insertExercise(String duration, String date) async {
    final db = await instance.database;

    final data = {'duration': duration, 'date': date};
    return await db.insert('exercise', data);
  }

  Future<bool> checkExerciseForDate(String date) async {
    final db = await instance.database;

    final result = await db.query(
      'exercise',
      columns: ['id'],
      where: 'date = ?',
      whereArgs: [date],
    );

    return result.isNotEmpty;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
