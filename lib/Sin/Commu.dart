import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Commu {
  final int? postID;
  final int? fk_memberNumber;
  final String type;
  final String title;
  final String content;
  final DateTime createdAt;
  int? commentCount;
  int? likeCount;
  DateTime? timestamp;
  String? name;

  Commu({
    this.postID,
    this.fk_memberNumber,
    required this.type,
    required this.title,
    required this.content,
    required this.createdAt,
    this.commentCount,
    this.likeCount,
    this.timestamp,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'postID': postID,
      'fk_memberNumber': fk_memberNumber,
      'type': type,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'name': name,
      'likeCount': likeCount,
    };
  }
}

class Comment {
  final int? commentID;
  final int postID;
  final int memberNumber;
  final String content;
  final DateTime createdAt;

  Comment({
    this.commentID,
    required this.postID,
    required this.memberNumber,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'commentID': commentID,
      'postID': postID,
      'memberNumber': memberNumber,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class DatabaseHelper {
  static late Database _database;
  static const String commuDbName = 'commu.db';
  static const String postsTable = 'Posts';
  static const String commentsTable = 'Comments';

  static Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), commuDbName),
      onCreate: (db, version) async {
        await _createTables(db);
        await _insertInitialData(db);
      },
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createTables(db);
        }
      },
    );
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $postsTable(
        postID INTEGER PRIMARY KEY,
        fk_memberNumber INTEGER,
        type TEXT,
        title TEXT, -- 제목 필드 추가
        content TEXT,
        createdAt TEXT,
        name TEXT,
        likeCount INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $commentsTable(
        commentID INTEGER PRIMARY KEY,
        postID INTEGER,
        memberNumber INTEGER,
        content TEXT,
        createdAt TEXT,
        FOREIGN KEY (postID) REFERENCES $postsTable(postID)
      )
    ''');
  }

  static Future<void> _insertInitialData(Database db) async {
    final List<Map<String, dynamic>> initialData = [
      {
        'postID': 1,
        'fk_memberNumber': 1,
        'type': '자유게시판',
        'title': '첫 번째 게시물 제목', // 제목 데이터 추가
        'content': '첫 번째 게시물 내용입니다.',
        'createdAt': DateTime.now().toIso8601String(),
        'name': '회원1',
      },
      {
        'postID': 2,
        'fk_memberNumber': 2,
        'type': '헬스 파트너 찾기',
        'title': '두 번째 게시물 제목', // 제목 데이터 추가
        'content': '두 번째 게시물 내용입니다.',
        'createdAt': DateTime.now().toIso8601String(),
        'name': '회원2',
      },
      {
        'postID': 3,
        'fk_memberNumber': 3,
        'type': '운동 고민 게시판',
        'title': '세 번째 게시물 제목', // 제목 데이터 추가
        'content': '세 번째 게시물 내용입니다.',
        'createdAt': DateTime.now().toIso8601String(),
        'name': '회원3',
      },
    ];

    for (final data in initialData) {
      await db.insert(postsTable, data);
    }
  }

  static Future<List<Commu>> getPostsByType(String type) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      postsTable,
      where: 'type = ?',
      whereArgs: [type],
    );

    List<Commu> posts = [];
    for (final map in maps) {
      final int postID = map['postID'];
      final int commentCount = await _getCommentCount(postID);
      posts.add(
        Commu(
          postID: map['postID'],
          fk_memberNumber: map['fk_memberNumber'],
          type: map['type'],
          title: map['title'],
          content: map['content'],
          createdAt: DateTime.parse(map['createdAt']),
          commentCount: commentCount,
          timestamp: DateTime.parse(map['createdAt']),
          name: map['name'],
        ),
      );
    }

    return posts;
  }

  static Future<void> insertPost(Commu post) async {
    await _database.insert(postsTable, post.toMap());
  }

  static Future<void> insertComment(Comment comment) async {
    await _database.insert(commentsTable, comment.toMap());
  }

  static Future<List<Comment>> getCommentsByPostID(int postID) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      commentsTable,
      where: 'postID = ?',
      whereArgs: [postID],
    );
    return List.generate(maps.length, (i) {
      return Comment(
        commentID: maps[i]['commentID'],
        postID: maps[i]['postID'],
        memberNumber: maps[i]['memberNumber'],
        content: maps[i]['content'],
        createdAt: DateTime.parse(maps[i]['createdAt']),
      );
    });
  }

  static Future<List<Commu>> getPosts() async {
    final List<Map<String, dynamic>> maps = await _database.query(postsTable);

    List<Commu> posts = [];
    for (final map in maps) {
      final int postID = map['postID'];
      final int commentCount = await _getCommentCount(postID);
      posts.add(
        Commu(
          postID: map['postID'],
          fk_memberNumber: map['fk_memberNumber'],
          type: map['type'],
          title: map['title'],
          content: map['content'],
          createdAt: DateTime.parse(map['createdAt']),
          commentCount: commentCount,
          timestamp: DateTime.parse(map['createdAt']),
          name: map['name'], // 이름 추가
        ),
      );
    }

    return posts;
  }

  static Future<int> _getCommentCount(int postID) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      commentsTable,
      where: 'postID = ?',
      whereArgs: [postID],
    );
    return maps.length;
  }

  static Future<int> getLikeCount(int postID) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      postsTable,
      columns: ['likeCount'],
      where: 'postID = ?',
      whereArgs: [postID],
    );
    if (maps.isNotEmpty) {
      return maps.first['likeCount'];
    } else {
      return 0;
    }
  }

  static Future<void> updateLikeCount(int postID, int newLikeCount) async {
    await _database.update(
      postsTable,
      {'likeCount': newLikeCount},
      where: 'postID = ?',
      whereArgs: [postID],
    );
  }
}
