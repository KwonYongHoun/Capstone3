import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarDatabase {
  // Firebase Firestore 인스턴스 생성
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore에 저장된 레코드의 컬렉션 이름
  static const String _collectionName = 'records';

  // CalendarDatabase의 싱글톤 인스턴스
  static final CalendarDatabase instance = CalendarDatabase._init();

  // 내부 생성자
  CalendarDatabase._init();

  // Firestore의 컬렉션 참조를 가져오는 메서드
  CollectionReference<Map<String, dynamic>> get _recordsCollection {
    return _firestore.collection(_collectionName);
  }

  // Firestore에 레코드를 추가하는 메서드
  Future<void> insertRecord(
      String memberNumber, String date, int duration) async {
    String docId = '$memberNumber$date'; // 변경된 로직
    await _recordsCollection.doc(docId).set({
      'memberNumber': memberNumber,
      'date': date,
      'duration': duration,
    });
  }

  // 특정 사용자의 특정 날짜의 레코드를 가져오는 메서드
  Future<Map<String, dynamic>?> getRecordByDate(
      String memberNumber, String date) async {
    String docId = '$memberNumber$date';
    final docSnapshot = await _recordsCollection.doc(docId).get();

    if (docSnapshot.exists) {
      return docSnapshot.data();
    } else {
      return null;
    }
  }

  // 특정 사용자의 모든 레코드를 가져오는 메서드
  Future<List<Map<String, dynamic>>> getAllRecords(String memberNumber) async {
    final querySnapshot = await _recordsCollection
        .where('memberNumber', isEqualTo: memberNumber)
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // 특정 사용자의 특정 날짜의 레코드를 삭제하는 메서드
  Future<void> deleteRecord(String memberNumber, String date) async {
    String docId = '$memberNumber$date';
    await _recordsCollection.doc(docId).delete();
  }
}
