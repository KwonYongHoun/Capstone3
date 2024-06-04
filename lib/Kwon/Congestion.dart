import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../health.dart';

class CongestionPage extends StatefulWidget {
  @override
  _CongestionPageState createState() => _CongestionPageState();
}

String congestionChange = '';

class _CongestionPageState extends State<CongestionPage> {
  @override
  void initState() {
    super.initState();
    _loadCongestionState();
  }

  Future<void> _loadCongestionState() async {
    await Firebase.initializeApp();
    String state = await DatabaseHelper.getCongestion();
    setState(() {
      congestionChange = state;
    });
  }

  void _updateCongestionState(String state) async {
    await DatabaseHelper.updateCongestion(state);
    setState(() {
      congestionChange = state;
    });
    print('$state');
    print('Congestion: $congestionChange');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('혼잡도 관리'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _updateCongestionState('여유'),
              child: Text('여유'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _updateCongestionState('보통'),
              child: Text('보통'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _updateCongestionState('혼잡'),
              child: Text('혼잡'),
            ),
            SizedBox(height: 32),
            Text(
              '현재 혼잡도: $congestionChange',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
