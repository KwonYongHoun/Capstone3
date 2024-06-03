import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Member {
  final int memberNumber;
  final String password;
  final String name;
  final String nickname;
  final String phoneNumber;
  final DateTime registrationDate;
  final DateTime expirationDate;
  final String memberState;

  Member({
    required this.memberNumber,
    required this.password,
    required this.name,
    required this.nickname,
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
      'nickname': nickname,
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
      nickname: map['nickname'] ?? '',
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
      nickname: data['nickname'] ?? '',
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
      'password': password,
      'name': name,
      'nickname': nickname,
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
  final String name;
  final bool isAnonymous;
  int reportCount; // 신고 수 추가

  Comment({
    required this.commentID,
    required this.postID,
    required this.memberNumber,
    required this.content,
    required this.createdAt,
    required this.name,
    required this.isAnonymous,
    this.reportCount = 0, // 기본값은 0으로 설정
  });

  Map<String, dynamic> toMap() {
    return {
      'commentID': commentID,
      'postID': postID,
      'memberNumber': memberNumber,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'name': isAnonymous ? 'Anonymous' : name,
      'isAnonymous': isAnonymous,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentID: map['commentID'],
      postID: map['postID'],
      memberNumber: map['memberNumber'],
      content: map['content'],
      createdAt: DateTime.parse(map['createdAt']),
      name: map['isAnonymous'] ? 'Anonymous' : map['name'],
      isAnonymous: map['isAnonymous'],
    );
  }
}

class BodyInfo {
  final int memberNumber;
  final double height;
  final double weight;

  BodyInfo({
    required this.memberNumber,
    required this.height,
    required this.weight,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberNumber': memberNumber,
      'height': height,
      'weight': weight,
    };
  }

  factory BodyInfo.fromMap(Map<String, dynamic> map) {
    return BodyInfo(
      memberNumber: map['memberNumber'],
      height: map['height'],
      weight: map['weight'],
    );
  }

  factory BodyInfo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BodyInfo(
      memberNumber: data['memberNumber'],
      height: data['height'],
      weight: data['weight'],
    );
  }
}

class DatabaseHelper {
  static late FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String membersCollection = 'members';
  static const String postsCollection = 'posts';
  static const String commentsCollection = 'comments';
  static const String scrapsCollection = 'scraps';
  static const String bodyInfoCollection = 'bodyInfo';

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
    await _db
        .collection(commentsCollection)
        .doc(comment.commentID)
        .set(comment.toMap());
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

  // 댓글 수 가져오기
  static Future<int> getCommentCount(String postID) async {
    final querySnapshot = await _db
        .collection(commentsCollection)
        .where('postID', isEqualTo: postID)
        .get();
    return querySnapshot.docs.length;
  }

  // 댓글 수 업데이트
  static Future<void> updateCommentCount(
      String postID, int newCommentCount) async {
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

  //스크랩 추가
  static Future<void> addScrap(String memberNumber, String postID) async {
    await _db.collection('scraps').add({
      'memberNumber': memberNumber,
      'postID': postID,
      'scrapDate': DateTime.now().toIso8601String(),
    });
  }

  // 특정 사용자의 스크랩한 게시물 가져오기
  static Future<List<Commu>> getScrappedPosts(String memberNumber) async {
    final querySnapshot = await _db
        .collection('scraps')
        .where('memberNumber', isEqualTo: memberNumber)
        .get();
    List<String> postIDs = querySnapshot.docs
        .map((doc) => doc.data()['postID'] as String)
        .toList();
    if (postIDs.isEmpty) return [];
    final postsQuery = await _db
        .collection('posts') // 게시물 정보가 저장된 컬렉션
        .where(FieldPath.documentId, whereIn: postIDs)
        .get();
    return postsQuery.docs.map((doc) => Commu.fromMap(doc.data())).toList();
  }

  // 스크랩 삭제
  static Future<void> removeScrap(String memberNumber, String postID) async {
    final querySnapshot = await _db
        .collection('scraps')
        .where('memberNumber', isEqualTo: memberNumber)
        .where('postID', isEqualTo: postID)
        .get();
    for (final doc in querySnapshot.docs) {
      await _db.collection('scraps').doc(doc.id).delete();
    }
  }

  static Future<bool> isPostScrapped(String memberNumber, String postID) async {
    final querySnapshot = await _db
        .collection(scrapsCollection)
        .where('memberNumber', isEqualTo: memberNumber)
        .where('postID', isEqualTo: postID)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }

  static Future<Comment?> getComment(String commentID) async {
    final docSnapshot =
        await _db.collection(commentsCollection).doc(commentID).get();
    if (docSnapshot.exists) {
      return Comment.fromMap(docSnapshot.data()!);
    }
    return null;
  }

  // 댓글 신고 수 업데이트
  static Future<void> updateCommentReportCount(
      String commentID, int newReportCount) async {
    await _db.collection(commentsCollection).doc(commentID).update({
      'reportCount': newReportCount,
    });
  }

  //닉네임변경
  static Future<void> updateNickname(
      int memberNumber, String newNickname) async {
    try {
      await _db
          .collection(membersCollection)
          .doc(memberNumber.toString())
          .update({'nickname': newNickname});
      print('닉네임이 성공적으로 업데이트되었습니다.');
    } catch (e) {
      print('닉네임 업데이트 중 오류가 발생했습니다: $e');
    }
  }

  //회원신체정보

  static Future<void> updateBodyInfo(
      int memberNumber, double height, double weight) async {
    try {
      await _db
          .collection(bodyInfoCollection)
          .doc(memberNumber.toString())
          .set({
        'memberNumber': memberNumber,
        'height': height,
        'weight': weight,
      });
      print('신체 정보가 성공적으로 업데이트되었습니다.');
    } catch (e) {
      print('신체 정보 업데이트 중 오류가 발생했습니다: $e');
    }
  }

  static Future<BodyInfo?> getBodyInfo(int memberNumber) async {
    final docSnapshot = await _db
        .collection(bodyInfoCollection)
        .doc(memberNumber.toString())
        .get();
    if (docSnapshot.exists) {
      return BodyInfo.fromFirestore(docSnapshot);
    }
    return null;
  }

  //비밀번호변경
  static Future<void> updatePassword(
      int memberNumber, String newPassword) async {
    try {
      await _db
          .collection(membersCollection)
          .doc(memberNumber.toString())
          .update({
        'password': newPassword,
      });
      print('비밀번호가 성공적으로 업데이트되었습니다.');
    } catch (e) {
      print('비밀번호 업데이트 중 오류가 발생했습니다: $e');
    }
  }
}
