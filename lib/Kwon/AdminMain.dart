import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health/Kwon/MemberMain.dart';
import 'package:health/Kwon/ReportedPostsPage.dart';
import 'Congestion.dart';
import 'EntryRecord.dart';

class AdminModeHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('관리자 모드'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAdminButton(
              text: '회원 관리',
              icon: Icons.person,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemberManagementPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildAdminButton(
              text: '커뮤니티 관리',
              icon: Icons.chat,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportedPostsPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildAdminButton(
              text: 'QR 코드 스캔',
              icon: Icons.qr_code,
              onPressed: () async {
                String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                  '#ff6666', 'Cancel', true, ScanMode.QR);

                if (barcodeScanRes != '-1') {
                  FirebaseFirestore.instance.collection('entryLogs').add({
                    'memberId': barcodeScanRes,
                    'timestamp': FieldValue.serverTimestamp(),
                  });
                  print('Logged entry for QR Code: $barcodeScanRes');
                }
              },
            ),
            SizedBox(height: 16),
            _buildAdminButton(
              text: '혼잡도 관리',
              icon: Icons.traffic,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CongestionPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildAdminButton(
              text: '입장 로그 보기',
              icon: Icons.history,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EntryLogsPage()),
                );
              },
            ),
            SizedBox(height: 16),
            _buildAdminButton(
              text: '테스트 데이터 추가',
              icon: Icons.add,
              onPressed: () async {
                FirebaseFirestore.instance.collection('entryLogs').add({
                  'memberId': 'test2',
                  'timestamp': FieldValue.serverTimestamp(),
                });
                print('Logged entry for test QR Code');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
