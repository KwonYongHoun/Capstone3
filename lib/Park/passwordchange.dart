import 'package:flutter/material.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({Key? key}) : super(key: key);

  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _changePassword() {
    // TODO: 여기에 비밀번호 변경 로직을 추가하세요. 예를 들어, 서버에 요청을 보낼 수 있습니다.

    // 비밀번호 변경 성공 가정
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('비밀번호가 변경되었습니다.')),
    );

    // 비밀번호 변경 성공 후, 일정 시간 후에 이전 화면으로 자동으로 돌아가기
    Future.delayed(Duration(seconds: 0), () {
      Navigator.of(context).pop(); // 현재 페이지 닫기
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Text(
                '기존 비밀번호',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _oldPasswordController,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(255, 248, 245, 245),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  hintText: '기존 비밀번호를 입력해 주세요.',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 30.0,
              ),
              Text(
                '새 비밀번호',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  fillColor: Color.fromARGB(255, 248, 245, 245),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13.0),
                  ),
                  hintText: '새 비밀번호를 입력해 주세요.',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 20.0,
              ),
              Spacer(), // 나머지 공간을 모두 차지하도록 Spacer 추가
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0), // 하단 여백 조정
                child: ElevatedButton(
                  onPressed: _changePassword,
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
      ),
    );
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}
