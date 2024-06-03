import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Member {
  final int memberNumber;
  final String password;
  final String name;
  final String phoneNumber;
  final DateTime registrationDate;
  final DateTime expirationDate;
  final String memberState;

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

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      memberNumber: map['memberNumber'],
      password: map['password'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      registrationDate: DateTime.parse(map['registrationDate']),
      expirationDate: DateTime.parse(map['expirationDate']),
      memberState: map['memberState'],
    );
  }
  factory Member.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Member(
      memberNumber: data['memberNumber'],
      password: data['password'],
      name: data['name'],
      phoneNumber: data['phoneNumber'],
      registrationDate: _toDateTime(data['registrationDate']),
      expirationDate: _toDateTime(data['expirationDate']),
      memberState: data['memberState'],
    );
  }

  static DateTime _toDateTime(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    } else {
      throw ArgumentError('Invalid timestamp format');
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'memberNumber': memberNumber,
      'name': name,
      'phoneNumber': phoneNumber,
      'memberState': memberState,
      'registrationDate': registrationDate,
    };
  }
}

class Commu {
  String? postID;
  final String? fk_memberNumber;
  final String type;
  final String title;
  final String content;
  final DateTime createdAt;
  int? commentCount;
  int? reportCount;
  DateTime? timestamp;
  String? name;

  Commu({
    required this.postID,
    required this.fk_memberNumber,
    required this.type,
    required this.title,
    required this.content,
    required this.createdAt,
    this.commentCount,
    this.likeCount,
    this.reportCount,
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
      'commentCount': commentCount,
      'likeCount': likeCount,
      'reportCount': reportCount,
      'timestamp': timestamp?.toIso8601String(),
      'name': name,
    };
  }

  factory Commu.fromMap(Map<String, dynamic> map) {
    return Commu(
      postID: map['postID'],
      fk_memberNumber: map['fk_memberNumber'],
      type: map['type'],
      title: map['title'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      commentCount: map['commentCount'],
      likeCount: map['likeCount'],
      reportCount: map['reportCount'],
      name: map['name'],
    );
  }
}

class Comment {
  final String commentID;
  final String postID;
  final String memberNumber;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.commentID,
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

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentID: map['commentID'],
      postID: map['postID'],
      memberNumber: map['memberNumber'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class DatabaseHelper {
  static late FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String membersCollection = 'members';
  static const String postsCollection = 'posts';
  static const String commentsCollection = 'comments';
// Firestore 초기화
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    _db = FirebaseFirestore.instance;
  }

  // 회원 추가
  static Future<void> insertMember(Member member) async {
    await _db
        .collection(membersCollection)
        .doc(member.memberNumber.toString())
        .set(member.toMap());
  }

  // 모든 회원 가져오기
  static Future<List<Member>> getMembers() async {
    final querySnapshot = await _db.collection(membersCollection).get();
    return querySnapshot.docs.map((doc) => Member.fromMap(doc.data())).toList();
  }

  // 특정 회원 정보 가져오기
  static Future<Member?> getMember(int memberNumber) async {
    final docSnapshot = await _db
        .collection(membersCollection)
        .doc(memberNumber.toString())
        .get();
    if (docSnapshot.exists) {
      return Member.fromMap(docSnapshot.data()!);
    }
    return null;
  }

  // 회원 삭제
  static Future<void> deleteMember(int memberNumber) async {
    await _db
        .collection(membersCollection)
        .doc(memberNumber.toString())
        .delete();
  }

  // 회원 업데이트
  static Future<void> updateMember(Member member) async {
    await _db
        .collection(membersCollection)
        .doc(member.memberNumber.toString())
        .update(member.toMap());
  }

  // 회원 검색
  static Future<List<Member>> searchMembers(String searchQuery) async {
    final querySnapshot = await _db
        .collection(membersCollection)
        .where('name', isEqualTo: searchQuery)
        .get();
    return querySnapshot.docs.map((doc) => Member.fromMap(doc.data())).toList();
  }

  // 아이디 확인
  static Future<List<Member>> IDCheck(String id, String password) async {
    final querySnapshot = await _db
        .collection(membersCollection)
        .where('memberNumber', isEqualTo: int.parse(id))
        .where('password', isEqualTo: password)
        .get();
    return querySnapshot.docs.map((doc) => Member.fromMap(doc.data())).toList();
  }

  // 신고 수 업데이트
  static Future<void> updateReportCount(
      String postID, int newReportCount) async {
    await _db
        .collection(postsCollection)
        .doc(postID)
        .update({'reportCount': newReportCount});
  }

  // 특정 게시물의 신고 수 가져오기
  static Future<int> getReportCount(String postID) async {
    final docSnapshot = await _db.collection(postsCollection).doc(postID).get();
    if (docSnapshot.exists) {
      return docSnapshot.data()!['reportCount'];
    }
    return 0;
  }

  // 특정 유형의 게시물 가져오기
  static Future<List<Commu>> getPostsByType(String type) async {
    final querySnapshot = await _db
        .collection(postsCollection)
        .where('type', isEqualTo: type)
        .get();
    return querySnapshot.docs.map((doc) => Commu.fromMap(doc.data())).toList();
  }

  // 게시물 삽입
  static Future<void> insertPost(Commu post) async {
    final now = DateTime.now();
    final uniqueID = now.microsecondsSinceEpoch.toString(); // 고유한 ID 생성

    // Commu 객체에 postID 설정
    post.postID = uniqueID;

    // Firestore에 게시물 추가
    await _db.collection(postsCollection).doc(uniqueID).set(post.toMap());
  }

// 댓글 삽입
  static Future<void> insertComment(Comment comment) async {
    await _db.collection(commentsCollection).add(comment.toMap());
  }

  // 특정 게시물의 댓글 가져오기
  static Future<List<Comment>> getCommentsByPostID(String postID) async {
    final querySnapshot = await _db
        .collection(commentsCollection)
        .where('postID', isEqualTo: postID)
        .get();
    return querySnapshot.docs
        .map((doc) => Comment.fromMap(doc.data()))
        .toList();
  }

  // 모든 게시물 가져오기
  static Future<List<Commu>> getPosts() async {
    final querySnapshot = await _db.collection(postsCollection).get();
    return querySnapshot.docs.map((doc) => Commu.fromMap(doc.data())).toList();
  }

  // 특정 게시물의 댓글 수 가져오기
  static Future<int> _getCommentCount(String postID) async {
    final querySnapshot = await _db
        .collection(commentsCollection)
        .where('postID', isEqualTo: postID)
        .get();
    return querySnapshot.docs.length;
  }

  // 특정 게시물의 좋아요 수 가져오기
  static Future<int> getLikeCount(String postID) async {
    final docSnapshot = await _db.collection(postsCollection).doc(postID).get();
    if (docSnapshot.exists) {
      return docSnapshot.data()!['likeCount'];
    }
    return 0;
  }

  // 특정 게시물의 좋아요 수 업데이트
  static Future<void> updateLikeCount(String postID, int newLikeCount) async {
    await _db
        .collection(postsCollection)
        .doc(postID)
        .update({'commentCount': newCommentCount});
  }

  // 모든 게시물 가져오기
  static Future<List<Commu>> getPosts() async {
    final querySnapshot = await _db.collection(postsCollection).get();
    return querySnapshot.docs.map((doc) => Commu.fromMap(doc.data())).toList();
  }

  // 댓글 삭제
  static Future<void> deleteComment(String commentID) async {
    await _db.collection(commentsCollection).doc(commentID).delete();
  }

  // 댓글 신고
  static Future<void> reportComment(String commentID) async {
    final docSnapshot =
        await _db.collection(commentsCollection).doc(commentID).get();
    if (docSnapshot.exists) {
      int currentReportCount = docSnapshot.data()!['reportCount'] ?? 0;
      await _db
          .collection(commentsCollection)
          .doc(commentID)
          .update({'reportCount': currentReportCount + 1});
    }
  }

  // 게시물 삭제 메서드 수정
  static Future<void> deletePost(String postID) async {
    await _db.collection(postsCollection).doc(postID).delete();
    // 해당 게시물의 댓글도 삭제
    final querySnapshot = await _db
        .collection(commentsCollection)
        .where('postID', isEqualTo: postID)
        .get();
    for (var doc in querySnapshot.docs) {
      await _db.collection(commentsCollection).doc(doc.id).delete();
    }
  }

  // 게시물 검색
  static Future<List<Commu>> searchPosts(String query) async {
    final querySnapshot = await _db
        .collection(postsCollection)
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .get();
    return querySnapshot.docs.map((doc) => Commu.fromMap(doc.data())).toList();
  }
}
