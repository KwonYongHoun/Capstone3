import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _recordsCollectionName = 'records';
  static const String _exercisesCollectionName = 'exercises';

  static final CalendarDatabase instance = CalendarDatabase._init();
  CalendarDatabase._init();

  CollectionReference<Map<String, dynamic>> get _recordsCollection {
    return _firestore.collection(_recordsCollectionName);
  }

  CollectionReference<Map<String, dynamic>> get _exercisesCollection {
    return _firestore.collection(_exercisesCollectionName);
  }

  Future<void> insertRecord(
      String memberNumber, String date, int duration) async {
    String docId = '$memberNumber$date';
    await _recordsCollection.doc(docId).set({
      'memberNumber': memberNumber,
      'date': date,
      'duration': duration,
    });
  }

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

  Future<List<Map<String, dynamic>>> getAllRecords(String memberNumber) async {
    final querySnapshot = await _recordsCollection
        .where('memberNumber', isEqualTo: memberNumber)
        .get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteRecord(String memberNumber, String date) async {
    String docId = '$memberNumber$date';
    await _recordsCollection.doc(docId).delete();
  }

  Future<void> saveExerciseRecord({
    required String memberNumber,
    required String exerciseName,
    required String exerciseDate,
    required String exerciseTime,
    required String exerciseIntensity,
    required List<Map<String, dynamic>> detailedRecord,
  }) async {
    try {
      await _exercisesCollection.add({
        'memberNumber': memberNumber,
        'exerciseName': exerciseName,
        'exerciseDate': exerciseDate,
        'exerciseTime': exerciseTime,
        'exerciseIntensity': exerciseIntensity,
        'detailedRecord': detailedRecord,
      });
    } catch (e) {
      print('Error saving exercise record: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> getExerciseDetailsByDate(
      String memberNumber, String date) async {
    final querySnapshot = await _exercisesCollection
        .where('memberNumber', isEqualTo: memberNumber)
        .where('exerciseDate', isEqualTo: date)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } else {
      return null;
    }
  }
}
