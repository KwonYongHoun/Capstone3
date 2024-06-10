import 'package:cloud_firestore/cloud_firestore.dart';

class MachineRecordDatabase {
  late FirebaseFirestore _firestore;

  MachineRecordDatabase() {
    _firestore = FirebaseFirestore.instance;
  }

  // 운동 기록 삽입
  Future<void> insertRecord(Map<String, dynamic> record) async {
    await _firestore.collection('records').add(record);
  }

  // 모든 운동 기록 조회
  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final querySnapshot = await _firestore.collection('records').get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // 특정 운동 기록 삭제
  Future<void> deleteRecord(String id) async {
    await _firestore.collection('records').doc(id).delete();
  }

  // 데이터베이스를 여는 메서드, 데이터베이스를 열 필요가 없으므로 빈 메서드로 정의
  void openDB() {}

  // 데이터베이스를 닫는 메서드, 데이터베이스를 닫을 필요가 없으므로 빈 메서드로 정의
  void closeDB() {}
}
