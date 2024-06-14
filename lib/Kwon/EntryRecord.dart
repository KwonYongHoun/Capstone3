import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // 날짜 포맷을 위해 추가

class EntryLogsPage extends StatefulWidget {
  @override
  _EntryLogsPageState createState() => _EntryLogsPageState();
}

class _EntryLogsPageState extends State<EntryLogsPage> {
  bool showMultipleEntries = false;
  DateTime selectedDate = DateTime.now(); // 선택된 날짜 저장
  List<QueryDocumentSnapshot> multipleEntriesDocs = [];

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020), // 원하는 날짜 범위 설정
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      if (showMultipleEntries) {
        filterMultipleEntries();
      }
    }
  }

  Future<void> filterMultipleEntries() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('entryLogs')
        .orderBy('timestamp', descending: true)
        .get();

    var startOfDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    var endOfDay = startOfDay.add(Duration(days: 1));
    var entriesCount = <String, int>{};

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      var timestamp = data['timestamp'] as Timestamp?;
      var date = timestamp?.toDate();

      if (date != null && date.isAfter(startOfDay) && date.isBefore(endOfDay)) {
        var memberId = data['memberId'] as String;
        entriesCount[memberId] = (entriesCount[memberId] ?? 0) + 1;
      }
    }

    setState(() {
      multipleEntriesDocs = snapshot.docs.where((doc) {
        var data = doc.data() as Map<String, dynamic>;
        var timestamp = data['timestamp'] as Timestamp?;
        var date = timestamp?.toDate();
        var memberId = data['memberId'] as String;
        return date != null &&
            date.isAfter(startOfDay) &&
            date.isBefore(endOfDay) &&
            (entriesCount[memberId] ?? 0) > 1;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('입장 로그'),
        actions: [
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () => selectDate(context),
          ),
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              setState(() {
                showMultipleEntries = !showMultipleEntries;
              });
              if (showMultipleEntries) {
                filterMultipleEntries();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('entryLogs')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No entries found.'));
          }

          if (showMultipleEntries) {
            if (multipleEntriesDocs.isEmpty) {
              return Center(child: Text('선택한 날짜에 두 번 이상 입장한 회원이 없습니다.'));
            }
            return ListView(
              children: multipleEntriesDocs.map((doc) {
                var data = doc.data() as Map<String, dynamic>;
                var timestamp = data['timestamp'] as Timestamp?;
                var date = timestamp != null ? timestamp.toDate() : null;
                return ListTile(
                  title: Text('회원번호: ${data['memberId']}'),
                  subtitle: Text('입장시간: ${date?.toString() ?? 'N/A'}'),
                );
              }).toList(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              var timestamp = data['timestamp'] as Timestamp?;
              var date = timestamp != null ? timestamp.toDate() : null;
              return ListTile(
                title: Text('회원번호: ${data['memberId']}'),
                subtitle: Text('입장시간: ${date?.toString() ?? 'N/A'}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
