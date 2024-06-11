import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EntryLogsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('입장 로그'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('entryLogs').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No entries found.'));
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
