import 'package:flutter/material.dart';
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
  int? reportCount; // 신고 수 필드 추가
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
    this.reportCount, // 신고 수 필드 초기화
    this.timestamp,
    this.name,
  });

  // 맵 형식으로 변환
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
      'reportCount': reportCount, // 신고 수 필드 추가
    };
  }
}

// 댓글 클래스 Comment 정의
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

  // 맵 형식으로 변환
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

// DatabaseHelper 클래스 정의
class DatabaseHelper {
  static late Database _database;
  static const String commuDbName = 'commu.db';
  static const String postsTable = 'Posts';
  static const String commentsTable = 'Comments';

  // 데이터베이스 초기화
  static Future<Database> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), commuDbName),
      onCreate: (db, version) async {
        await _createTables(db);
        await _insertInitialData(db);
      },
      version: 3, // 버전 변경
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await _createTables(db);
        }
        if (oldVersion < 3) {
          await db.execute(
              'ALTER TABLE $postsTable ADD COLUMN reportCount INTEGER DEFAULT 0'); // 신고 수 필드 추가
        }
      },
    );
    return _database;
  }

  // 테이블 생성
  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $postsTable(
        postID INTEGER PRIMARY KEY,
        fk_memberNumber INTEGER,
        type TEXT,
        title TEXT,
        content TEXT,
        createdAt TEXT,
        name TEXT,
        likeCount INTEGER DEFAULT 0,
        reportCount INTEGER DEFAULT 0 // 신고 수 필드 추가
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

  // 초기 데이터 삽입
  static Future<void> _insertInitialData(Database db) async {
    final List<Map<String, dynamic>> initialData = [
      {
        'postID': 1,
        'fk_memberNumber': 1,
        'type': '자유게시판',
        'title': '첫 번째 게시물 제목',
        'content': '첫 번째 게시물 내용입니다.',
        'createdAt': DateTime.now().toIso8601String(),
        'name': '회원1',
      },
      {
        'postID': 2,
        'fk_memberNumber': 2,
        'type': '헬스 파트너 찾기',
        'title': '두 번째 게시물 제목',
        'content': '두 번째 게시물 내용입니다.',
        'createdAt': DateTime.now().toIso8601String(),
        'name': '회원2',
      },
      {
        'postID': 3,
        'fk_memberNumber': 3,
        'type': '운동 고민 게시판',
        'title': '세 번째 게시물 제목',
        'content': '세 번째 게시물 내용입니다.',
        'createdAt': DateTime.now().toIso8601String(),
        'name': '회원3',
      },
    ];

    for (final data in initialData) {
      await db.insert(postsTable, data);
    }
  }

  // 신고 수 업데이트 메서드 추가
  static Future<void> updateReportCount(int postID, int newReportCount) async {
    await _database.update(
      postsTable,
      {'reportCount': newReportCount},
      where: 'postID = ?',
      whereArgs: [postID],
    );
  }

  // 특정 게시물의 신고 수 가져오기
  static Future<int> getReportCount(int postID) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      postsTable,
      columns: ['reportCount'],
      where: 'postID = ?',
      whereArgs: [postID],
    );
    if (maps.isNotEmpty) {
      return maps.first['reportCount'];
    } else {
      return 0;
    }
  }

  // 특정 유형의 게시물 가져오기
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

  // 게시물 삽입
  static Future<void> insertPost(Commu post) async {
    await _database.insert(postsTable, post.toMap());
  }

  // 댓글 삽입
  static Future<void> insertComment(Comment comment) async {
    await _database.insert(commentsTable, comment.toMap());
  }

  // 특정 게시물의 댓글 가져오기
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

  // 모든 게시물 가져오기
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
          name: map['name'],
        ),
      );
    }

    return posts;
  }

  // 특정 게시물의 댓글 수 가져오기
  static Future<int> _getCommentCount(int postID) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      commentsTable,
      where: 'postID = ?',
      whereArgs: [postID],
    );
    return maps.length;
  }

  // 특정 게시물의 좋아요 수 가져오기
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

  // 특정 게시물의 좋아요 수 업데이트
  static Future<void> updateLikeCount(int postID, int newLikeCount) async {
    await _database.update(
      postsTable,
      {'likeCount': newLikeCount},
      where: 'postID = ?',
      whereArgs: [postID],
    );
  }

  // 게시물 검색
  static Future<List<Commu>> searchPosts(String query) async {
    final List<Map<String, dynamic>> maps = await _database.query(
      postsTable,
      where: 'content LIKE ? OR type LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
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
}
