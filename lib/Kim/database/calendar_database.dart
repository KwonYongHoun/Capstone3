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

  // Firestore에 레코드 추가하는 메서드
  Future<void> insertRecord(
      String date, int duration, String startTime, String endTime) async {
    await _recordsCollection.add({
      'date': date,
      'duration': duration,
      'startTime': startTime,
      'endTime': endTime,
    });
  }

  // 특정 날짜의 레코드를 가져오는 메서드
  Future<Map<String, dynamic>?> getRecordByDate(String date) async {
    final querySnapshot =
        await _recordsCollection.where('date', isEqualTo: date).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      return null;
    }
  }

  // 모든 레코드를 가져오는 메서드
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final querySnapshot = await _recordsCollection.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}
