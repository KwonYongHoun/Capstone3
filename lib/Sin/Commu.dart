import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Commu {
  final int? postID;
  final int? fk_memberNumber;
  final String type;
  final String content;
  final DateTime createdAt;

  Commu({
    this.postID,
    this.fk_memberNumber,
    required this.type,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'postID': postID,
      'fk_memberNumber': fk_memberNumber,
      'type': type,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class DatabaseHelper {
  static late Database _database;
  static const String dbName = 'commu.db';
  static const String tableName = 'Posts';

  static Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), dbName),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName(
            postID INTEGER PRIMARY KEY,
            fk_memberNumber INTEGER,
            type TEXT,
            content TEXT,
            createdAt TEXT
          )
        ''');

        // 데이터베이스가 생성될 때 게시물 데이터를 넣습니다.
        await _insertInitialData(db);
      },
      version: 1,
    );
  }

  static Future<void> _insertInitialData(Database db) async {
    List<Commu> initialPosts = [
      Commu(
        postID: 1,
        fk_memberNumber: 1,
        type: '자유게시판',
        content: '첫 번째 게시물 내용입니다.',
        createdAt: DateTime.now(),
      ),
      Commu(
        postID: 2,
        fk_memberNumber: 2,
        type: '헬스 파트너 찾기',
        content: '두 번째 게시물 내용입니다.',
        createdAt: DateTime.now(),
      ),
      Commu(
        postID: 3,
        fk_memberNumber: 3,
        type: '운동 고민 게시판',
        content: '세 번째 게시물 내용입니다.',
        createdAt: DateTime.now(),
      ),
    ];

    for (var post in initialPosts) {
      await db.insert(tableName, post.toMap());
    }
  }

  static Future<void> insertPost(Commu post) async {
    await _database.insert(tableName, post.toMap());
  }

  static Future<List<Commu>> getPosts() async {
    final List<Map<String, dynamic>> maps = await _database.query(tableName);
    return List.generate(maps.length, (i) {
      return Commu(
        postID: maps[i]['postID'],
        fk_memberNumber: maps[i]['fk_memberNumber'],
        type: maps[i]['type'],
        content: maps[i]['content'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
      );
    });
  }

  // 추가적인 메소드들 (예: 삭제, 업데이트)도 필요에 따라 작성 가능
}
