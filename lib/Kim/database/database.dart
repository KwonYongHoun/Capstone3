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
