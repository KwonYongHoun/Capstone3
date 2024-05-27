import 'package:flutter/material.dart';
import 'myhomepage.dart';
import 'findid.dart';
import 'findpassword.dart';
import '../member.dart';
import '../Kwon/AdminMain.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//입력된 아이디 비밀번호
String enteredId = ''; //아이디
String enteredPassword = ''; //버밀번호
String enteredName = ''; //이름

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(55.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 35.0),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    '초기 ID : 회원번호',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: Text(
                    '초기 비밀번호 : 전화번호',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: idController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'ID',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 112, 203, 245), width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 112, 203, 245), width: 3.0),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: passwordController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'PASSWORD',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 112, 203, 245), width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 112, 203, 245), width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                // Retrieve entered ID and password
                enteredId = idController.text;
                enteredPassword = passwordController.text;

                //관리자모드 실행 : Id admin / 비밀번호 master
                if (enteredId == 'admin' && enteredPassword == 'master') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminModeHomePage()),
                  );
                }

                // Query the database for a member with the entered ID
                List<Member> members =
                    await DatabaseHelper.IDCheck(enteredId, enteredPassword);

                if (members.isNotEmpty) {
                  // Login successful
                  enteredName = members.first.name; // 이름도 같이 반환하기
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                } else {
                  // Invalid ID or password
                  setState(() {
                    errorMessage = '아이디 또는 비밀번호가 올바르지 않습니다.';
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  '로그인',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(250, 50),
                backgroundColor: Colors.lightGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    // FindIdPage로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FindId()),
                    );
                  },
                  child: Text(
                    '회원번호 찾기',
                    style: TextStyle(
                      color: Color.fromARGB(255, 138, 138, 138),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // FindPassword로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FindPassword()),
                    );
                  },
                  child: Text(
                    '비밀번호 찾기',
                    style: TextStyle(
                      color: Color.fromARGB(255, 138, 138, 138),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

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
