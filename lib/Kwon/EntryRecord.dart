import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EntryLogsPage extends StatefulWidget {
  @override
  _EntryLogsPageState createState() => _EntryLogsPageState();
}

class _EntryLogsPageState extends State<EntryLogsPage> {
  bool showMultipleEntries = false;
  DateTime selectedDate = DateTime.now();
  List<QueryDocumentSnapshot> multipleEntriesDocs = [];

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
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

  Future<void> deleteLog(String docId) async {
    await FirebaseFirestore.instance.collection('entryLogs').doc(docId).delete();
  }

  List<Widget> buildLogList(List<QueryDocumentSnapshot> docs) {
    Map<String, List<Widget>> dateGroupedLogs = {};

    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;
      var timestamp = data['timestamp'] as Timestamp?;
      var date = timestamp?.toDate();
      var formattedDate = DateFormat('yyyy-MM-dd').format(date!);

      if (!dateGroupedLogs.containsKey(formattedDate)) {
        dateGroupedLogs[formattedDate] = [];
      }

      dateGroupedLogs[formattedDate]!.add(
        Card(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: ListTile(
            title: Text('회원번호: ${data['memberId']}'),
            subtitle: Text('입장시간: ${date.toString()}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteLog(doc.id);
              },
            ),
          ),
        ),
      );
    }

    List<Widget> logList = [];
    dateGroupedLogs.forEach((date, logs) {
      logList.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Text(
                date,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center, // 날짜 가운데 정렬
              ),
            ),
            ...logs,
          ],
        ),
      );
    });

    return logList;
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

          List<QueryDocumentSnapshot> docs = showMultipleEntries
              ? multipleEntriesDocs
              : snapshot.data!.docs;

          return ListView(
            children: buildLogList(docs),
          );
        },
      ),
    );
  }
}
