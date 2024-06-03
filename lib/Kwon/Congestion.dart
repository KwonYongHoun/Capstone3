import 'package:flutter/material.dart';

class CongestionPage extends StatefulWidget {
  @override
  _CongestionPageState createState() => _CongestionPageState();
}

String congestionChange = '';

class _CongestionPageState extends State<CongestionPage> {
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
              onPressed: () {
                setState(() {
                  congestionChange = '여유';
                });
                print('여유');
                print('Congestion: $congestionChange');
              },
              child: Text('여유'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  congestionChange = '보통';
                });
                print('보통');
                print('Congestion: $congestionChange');
              },
              child: Text('보통'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  congestionChange = '혼잡';
                });
                print('혼잡');
                print('Congestion: $congestionChange');
              },
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
