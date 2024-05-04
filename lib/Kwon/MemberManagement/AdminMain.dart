import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:health/Kwon/MemberManagement/MemberMain.dart';

//관리자모드 페이지
class AdminModeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Mode',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AdminModeHomePage(),
    );
  }
}

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
                  MaterialPageRoute(
                      builder: (context) => MemberManagementPage()),
                );
              },
              child: Text('회원 관리'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Board Management Page
              },
              child: Text('커뮤니티 관리'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                // Scan QR Code
                String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                    '#ff6666', 'Cancel', true, ScanMode.QR);

                // Handle scanned QR Code
                print('Scanned QR Code: $barcodeScanRes');
              },
              child: Text('QR 카메라 실행'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Congestion Management Page
              },
              child: Text('혼잡도 관리'),
            ),
          ],
        ),
      ),
    );
  }
}
