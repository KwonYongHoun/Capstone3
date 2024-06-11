import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:health/Kwon/MemberMain.dart';
import 'package:health/Kwon/ReportedPostsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Congestion.dart';
import 'EntryRecord.dart';

//관리자모드 페이지
class AdminModeHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Mode'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemberManagementPage()),
                );
              },
              child: Text('회원 관리'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportedPostsPage()),
                );
              },
              child: Text('커뮤니티 관리'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // QR 코드 스캔
                String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666', 'Cancel', true, ScanMode.QR);

                if (barcodeScanRes != '-1') {
                  // Firestore에 스캔한 QR 코드 기록
                  FirebaseFirestore.instance.collection('entryLogs').add({
                    'memberId': barcodeScanRes,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  print('Logged entry for QR Code: $barcodeScanRes');
                }
              },
              child: Text('QR 카메라 실행'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CongestionPage()),
                );
              },
              child: Text('혼잡도 관리'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EntryLogsPage()),
                );
              },
              child: Text('입장 로그 보기'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // 테스트 데이터 Firestore에 추가
                FirebaseFirestore.instance.collection('entryLogs').add({
                  'memberId': 'test1',
                  'timestamp': FieldValue.serverTimestamp(),
                });
                print('Logged entry for test QR Code');
              },
              child: Text('테스트 데이터 추가'),
            ),
          ],
        ),
      ),
    );
  }
}