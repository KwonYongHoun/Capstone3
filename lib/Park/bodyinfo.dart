import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../health.dart';

class BodyInfoPage extends StatefulWidget {
  final String enteredId;

  BodyInfoPage({required this.enteredId});

  @override
  _BodyInfoPageState createState() => _BodyInfoPageState();
}

class _BodyInfoPageState extends State<BodyInfoPage> {
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _updateBodyInfo() async {
    double height = double.parse(_heightController.text);
    double weight = double.parse(_weightController.text);

    int memberNumber = int.parse(widget.enteredId); // widget.enteredId 사용
    await DatabaseHelper.updateBodyInfo(memberNumber, height, weight);

    // 업데이트 후 마이페이지로 돌아가기
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
            SizedBox(
              height: 30.0,
            ),
            Text(
              '키(cm)',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(
              height: 10.0,
            ),
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
            SizedBox(
              height: 30.0,
            ),
            Text(
              '몸무게(kg)',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(
              height: 10.0,
            ),
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
            Spacer(), // 나머지 공간을 모두 차지하도록 Spacer 추가
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0), // 하단 여백 조정
              child: ElevatedButton(
                onPressed: _updateBodyInfo,
                child: Text('변경하기',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 20.0), // 수직 패딩 조정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  minimumSize: Size.fromHeight(50), // 버튼의 최소 높이 지정
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
