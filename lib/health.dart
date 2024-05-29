import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Member 클래스 정의
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

// Commu 클래스 정의
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

// Comment 클래스 정의
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

// 통합된 데이터베이스 헬퍼 클래스 정의
class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'health.db';
  static const String membersTable = 'members';
  static const String postsTable = 'Posts';
  static const String commentsTable = 'Comments';

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
      await _createTables(db);
      await _insertInitialData(db);
    });
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $membersTable(
        memberNumber INTEGER PRIMARY KEY AUTOINCREMENT,
        password TEXT,
        name TEXT,
        phoneNumber TEXT,
        registrationDate TEXT,
        expirationDate TEXT,
        memberState TEXT
      )
    ''');

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
        reportCount INTEGER DEFAULT 0,
        FOREIGN KEY (fk_memberNumber) REFERENCES $membersTable(memberNumber)
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
    final List<Map<String, dynamic>> initialMembersData = [
      {
        'memberNumber': 1,
        'password': 'password1',
        'name': '회원1',
        'phoneNumber': '010-1111-1111',
        'registrationDate': DateTime.now().toIso8601String(),
        'expirationDate':
            DateTime.now().add(Duration(days: 365)).toIso8601String(),
        'memberState': '정상'
      },
      {
        'memberNumber': 2,
        'password': 'password2',
        'name': '회원2',
        'phoneNumber': '010-2222-2222',
        'registrationDate': DateTime.now().toIso8601String(),
        'expirationDate':
            DateTime.now().add(Duration(days: 365)).toIso8601String(),
        'memberState': '정상'
      },
      {
        'memberNumber': 3,
        'password': 'password3',
        'name': '회원3',
        'phoneNumber': '010-3333-3333',
        'registrationDate': DateTime.now().toIso8601String(),
        'expirationDate':
            DateTime.now().add(Duration(days: 365)).toIso8601String(),
        'memberState': '정상'
      },
    ];

    for (final data in initialMembersData) {
      await db.insert(membersTable, data);
    }

    final List<Map<String, dynamic>> initialPostsData = [
      {
        'postID': 1,
        'fk_memberNumber': 1,
        'type': '자유게시판',
        'title': '첫 번째 게시물 제목',
        'content': '첫 번째 게시물 내용입니다.',
        'createdAt': DateTime.now().toIso8601String(),
        'name': '회원1',
        'likeCount': 0,
        'reportCount': 0
      },
      {
        'postID': 2,
        'fk_memberNumber': 2,
        'type': '헬스 파트너 찾기',
        'title': '두 번째 게시물 제목',
        'content': '두 번째 게시물 내용입니다.',
        'createdAt': DateTime.now().toIso8601String(),
        'name': '회원2',
        'likeCount': 0,
        'reportCount': 0
      },
      {
        'postID': 3,
        'fk_memberNumber': 3,
        'type': '운동 고민 게시판',
        'title': '세 번째 게시물 제목',
        'content': '세 번째 게시물 내용입니다.',
        'createdAt': DateTime.now().toIso8601String(),
        'name': '회원3',
        'likeCount': 0,
        'reportCount': 0
      },
    ];

    for (final data in initialPostsData) {
      await db.insert(postsTable, data);
    }
  }

  // memberNumber로 특정 회원 정보 가져오기
  Future<Map<String, dynamic>?> getMember(int memberNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      membersTable,
      where: 'memberNumber = ?',
      whereArgs: [memberNumber],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  static Future<void> insertMember(Member member) async {
    final db = await database;
    await db.insert(membersTable, member.toMap());
  }

  static Future<List<Member>> getMembers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(membersTable);
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
      membersTable,
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
      membersTable,
      where: 'memberNumber = ?',
      whereArgs: [memberNumber],
    );
  }

  static Future<void> updateMember(Member member) async {
    final db = await database;
    await db.update(
      membersTable,
      member.toMap(),
      where: 'memberNumber = ?',
      whereArgs: [member.memberNumber],
    );
  }

  static Future<List<Member>> searchMembers(String searchQuery) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      membersTable,
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
      membersTable,
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

  // 신고 수 업데이트 메서드 추가
  static Future<void> updateReportCount(int postID, int newReportCount) async {
    final db = await database;
    await db.update(
      postsTable,
      {'reportCount': newReportCount},
      where: 'postID = ?',
      whereArgs: [postID],
    );
  }

  // 특정 게시물의 신고 수 가져오기
  static Future<int> getReportCount(int postID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
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
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
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
    final db = await database;
    await db.insert(postsTable, post.toMap());
  }

  // 댓글 삽입
  static Future<void> insertComment(Comment comment) async {
    final db = await database;
    await db.insert(commentsTable, comment.toMap());
  }

  // 특정 게시물의 댓글 가져오기
  static Future<List<Comment>> getCommentsByPostID(int postID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
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
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(postsTable);

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
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      commentsTable,
      where: 'postID = ?',
      whereArgs: [postID],
    );
    return maps.length;
  }

  // 특정 게시물의 좋아요 수 가져오기
  static Future<int> getLikeCount(int postID) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
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
    final db = await database;
    await db.update(
      postsTable,
      {'likeCount': newLikeCount},
      where: 'postID = ?',
      whereArgs: [postID],
    );
  }

// 게시물 삭제 메서드 추가
  static Future<void> deletePost(int postID) async {
    final db = await database;
    await db.delete(
      postsTable,
      where: 'postID = ?',
      whereArgs: [postID],
    );
    // 해당 게시물의 댓글도 삭제
    await db.delete(
      commentsTable,
      where: 'postID = ?',
      whereArgs: [postID],
    );
  }

  // 게시물 검색
  static Future<List<Commu>> searchPosts(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      postsTable,
      where: 'title LIKE ? OR content LIKE ?', // 제목 또는 내용에 대한 조건
      whereArgs: ['%$query%', '%$query%'], // 쿼리를 제목과 내용에 대한 검색어로 대체
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
