import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Sin/AuthProvider.dart';
import '../health.dart';
import 'mypagescreen.dart';

class BodyInfoPage extends StatefulWidget {
  @override
  _BodyInfoPageState createState() => _BodyInfoPageState();
}

class _BodyInfoPageState extends State<BodyInfoPage> {
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _updateBodyInfo() async {
    double? height = double.tryParse(_heightController.text);
    double? weight = double.tryParse(_weightController.text);

    if (height == null || weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('유효한 키와 몸무게를 입력해 주세요.')),
      );
      return;
    }

    String enteredId =
        Provider.of<AuthProvider>(context, listen: false).enteredId;
    int? memberNumber = int.tryParse(enteredId);

    if (memberNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('잘못된 사용자 ID입니다.')),
      );
      return;
    }

    await DatabaseHelper.updateBodyInfo(memberNumber, height, weight);

    Navigator.pop(context, {'height': height, 'weight': weight});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 신체 정보'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30.0),
            Text(
              '키(cm)',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 248, 245, 245),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                hintText: '키(cm)를 입력해 주세요.',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30.0),
            Text(
              '몸무게(kg)',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 248, 245, 245),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                hintText: '몸무게(kg)를 입력해 주세요.',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              keyboardType: TextInputType.number,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: _updateBodyInfo,
                child: Text('변경하기',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  minimumSize: Size.fromHeight(50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
