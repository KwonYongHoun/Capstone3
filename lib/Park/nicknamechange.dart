import 'package:flutter/material.dart';
import 'package:health/Park/loginpage.dart';
import 'package:health/Park/mypagescreen.dart';
import 'package:provider/provider.dart';
import '../health.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Sin/AuthProvider.dart';

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

  Future<void> _updateNickname() async {
    String newNickname = _nicknameController.text;

    if (newNickname.isNotEmpty) {
      // AuthProvider에서 로그인된 사용자 정보 가져오기
      Member? loggedInMember =
          Provider.of<AuthProvider>(context, listen: false).loggedInMember;

      if (loggedInMember != null) {
        await DatabaseHelper.updateNickname(
            loggedInMember.memberNumber, newNickname);

        // 업데이트 후 MypageScreen을 갱신합니다.
        Navigator.pop(context, newNickname); // 변경된 닉네임 전달
      } else {
        // 로그인된 사용자가 없는 경우 경고를 표시합니다.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인된 사용자가 없습니다.')),
        );
      }
    } else {
      // 닉네임이 비어있는 경우 경고를 표시합니다.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('닉네임을 입력해 주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('닉네임 변경'),
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
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: ElevatedButton(
                onPressed: _updateNickname,
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
