import 'package:flutter/material.dart';

class NicknameChangePage extends StatefulWidget {
  @override
  _NicknameChangePageState createState() => _NicknameChangePageState();
}

class _NicknameChangePageState extends State<NicknameChangePage> {
  final _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('닉네임 변경'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬을 위해 수정
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Text(
              '새 닉네임',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: _nicknameController,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 248, 245, 245),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13.0),
                ),
                hintText: '닉네임을 입력해 주세요.',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            Spacer(), // 나머지 공간을 모두 차지하도록 Spacer 추가
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0), // 하단 여백 조정
              child: ElevatedButton(
                onPressed: () {},
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
