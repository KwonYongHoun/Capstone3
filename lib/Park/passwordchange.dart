import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Sin/AuthProvider.dart';
import '../health.dart';
import 'loginpage.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({Key? key}) : super(key: key);

  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  void _changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;

    final loggedInMember =
        Provider.of<AuthProvider>(context, listen: false).loggedInMember;

    if (loggedInMember == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 정보가 없습니다.')),
      );
      return;
    }

    try {
      if (_formKey.currentState!.validate()) {
        // 기존 비밀번호가 현재 비밀번호 또는 초기 전화번호와 일치하는지 확인합니다.
        if (oldPassword == loggedInMember.password ||
            oldPassword == loggedInMember.phoneNumber) {
          // 비밀번호 변경
          await DatabaseHelper.updatePassword(
              loggedInMember.memberNumber, newPassword);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('비밀번호가 변경되었습니다.')),
          );

          // 비밀번호 변경 성공 후, 로그인 페이지로 이동
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('기존 비밀번호가 올바르지 않습니다.')),
          );
        }
      }
    } catch (e) {
      print('예외 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류가 발생했습니다. 다시 시도해 주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 변경'),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '기존 비밀번호를 입력해 주세요.';
                  }
                  return null;
                },
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '새 비밀번호를 입력해 주세요.';
                  }
                  return null;
                },
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
