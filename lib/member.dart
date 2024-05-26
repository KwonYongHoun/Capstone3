import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Member {
  final int memberNumber; //회원번호
  final String password; //비밀번호
  final String name; //이름
  final String phoneNumber; //전화번호
  final DateTime registrationDate; //등록일
  final DateTime expirationDate; //마감일
  final String memberState; //회원권상태: 정상/정지

  Member({
    required this.memberNumber,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.registrationDate,
    required this.expirationDate,
    required this.memberState,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberNumber': memberNumber,
      'password': password,
      'name': name,
      'phoneNumber': phoneNumber,
      'registrationDate': registrationDate.toIso8601String(),
      'expirationDate': expirationDate.toIso8601String(),
      'memberState': memberState,
    };
  }
}

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'members.db';
  static const String tableName = 'members';

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, dbName);
    print('Database path: $path');
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE $tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          memberNumber INTEGER,
          password TEXT,
          name TEXT,
          phoneNumber TEXT,
          registrationDate TEXT,
          expirationDate TEXT,
          memberState TEXT
        )
      ''');
    });
  }

  static Future<void> insertMember(Member member) async {
    final db = await database;
    await db.insert(tableName, member.toMap());
  }

  static Future<List<Member>> getMembers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return Member(
        memberNumber: maps[i]['memberNumber'],
        password: maps[i]['password'],
        name: maps[i]['name'],
        phoneNumber: maps[i]['phoneNumber'],
        registrationDate: DateTime.parse(maps[i]['registrationDate']),
        expirationDate: DateTime.parse(maps[i]['expirationDate']),
        memberState: maps[i]['memberState'],
      );
    });
  }

  static Future<int> getLastThreeDigits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      columns: ['memberNumber'],
      orderBy: 'memberNumber DESC',
      limit: 1,
    );
    if (maps.isEmpty) {
      return 0;
    }
    final lastMemberNumber = maps.first['memberNumber'] as int;
    return lastMemberNumber % 1000;
  }

  static Future<void> deleteMember(int memberNumber) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'memberNumber = ?',
      whereArgs: [memberNumber],
    );
  }

  static Future<void> updateMember(Member member) async {
    final db = await database;
    await db.update(
      tableName,
      member.toMap(),
      where: 'memberNumber = ?',
      whereArgs: [member.memberNumber],
    );
  }

  static Future<List<Member>> searchMembers(String searchQuery) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'name LIKE ? OR phoneNumber LIKE ?',
      whereArgs: ['%$searchQuery%', '%$searchQuery%'],
    );
    return List.generate(maps.length, (i) {
      return Member(
        memberNumber: maps[i]['memberNumber'],
        password: maps[i]['password'],
        name: maps[i]['name'],
        phoneNumber: maps[i]['phoneNumber'],
        registrationDate: DateTime.parse(maps[i]['registrationDate']),
        expirationDate: DateTime.parse(maps[i]['expirationDate']),
        memberState: maps[i]['memberState'],
      );
    });
  }

  static Future<List<Member>> IDCheck(String id, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'memberNumber = ? AND password = ?',
      whereArgs: [id, password],
    );
    return List.generate(maps.length, (i) {
      return Member(
        memberNumber: maps[i]['memberNumber'],
        password: maps[i]['password'],
        name: maps[i]['name'],
        phoneNumber: maps[i]['phoneNumber'],
        registrationDate: DateTime.parse(maps[i]['registrationDate']),
        expirationDate: DateTime.parse(maps[i]['expirationDate']),
        memberState: maps[i]['memberState'],
      );
    });
  }
}
