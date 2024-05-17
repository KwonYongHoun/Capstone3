import 'package:flutter/material.dart';
import 'dart:async';

import 'package:health/Park/loginpage.dart';

class FindId extends StatefulWidget {
  @override
  _FindIdState createState() => _FindIdState();
}

class _FindIdState extends State<FindId> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();
  bool _isVerificationCodeValid = false;
  bool _isNameValid = false;
  bool _isPhoneValid = false; // 휴대폰 번호 유효성 검사 상태
  bool _isVerificationCodeSent = false; // 인증번호 보내기 버튼이 눌렸는지 확인하는 상태
  bool _isCodeValid = false;
  Timer? _timer;
  int _remainingTime = 180;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _verificationCodeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _sendVerificationCode() {
    print(
        '이름: ${_nameController.text}, 전화번호: ${_phoneController.text}, 인증번호: ${_verificationCodeController.text}');
    setState(() {
      _isVerificationCodeSent = true;
      _remainingTime = 180;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _verifyCode() {
    if (_remainingTime <= 0) {
      _showExpiredDialog();
    } else if (_verificationCodeController.text != "1234") {
      _showIncorrectCodeDialog();
    } else {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('인증 성공'),
          content: Text("회원번호는 'sku12340001'입니다."),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // 로그인 페이지로 이동
              },
            ),
          ],
        );
      },
    );
  }

  void _showIncorrectCodeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('인증번호 오류'),
          content: Text('인증번호를 다시 확인해주세요.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  void _showExpiredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('인증 시간 만료'),
          content: Text('인증시간이 만료되었습니다. 인증번호를 재전송해주세요.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('회원번호 찾기'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '이름',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    fillColor: Color.fromARGB(255, 248, 245, 245),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    hintText: '이름을 입력해 주세요.',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _isNameValid = value.isNotEmpty;
                      _isPhoneValid = value.isNotEmpty &&
                          _phoneController.text.length == 11;
                    });
                  },
                ),
                SizedBox(height: 10),
                Text('휴대폰 번호',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 248, 245, 245),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13.0),
                            borderSide: BorderSide(
                              color: _isPhoneValid ? Colors.grey : Colors.red,
                            ),
                          ),
                          hintText: '010-0000-0000',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          if (value.length <= 11) {
                            setState(() {
                              _isPhoneValid = value.length == 11;
                            });
                          } else {
                            // 사용자가 4자리를 초과하여 입력하는 경우, 입력값을 4자리로 제한
                            setState(() {
                              _phoneController.text = value.substring(0, 11);
                              _phoneController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _phoneController.text.length),
                              );
                              _isPhoneValid = true;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 13),
                    ElevatedButton(
                      onPressed: _isNameValid && _isPhoneValid
                          ? _sendVerificationCode
                          : null,
                      child: Text(
                        _isVerificationCodeSent
                            ? '        재전송        '
                            : '인증번호 보내기',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.green,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                            color: const Color.fromARGB(255, 160, 219, 162),
                            width: 1),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                if (_isVerificationCodeSent)
                  Center(
                    child: Text(
                      '남은 시간: ${_remainingTime ~/ 60}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                if (!_isPhoneValid &&
                    _phoneController.text.isNotEmpty &&
                    _phoneController.text.length < 11)
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.0, 10.0, 10.0, 10.0),
                    child: Text(
                      '올바른 휴대폰 번호를 입력해 주세요.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                if (_isVerificationCodeSent)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text('인증번호',
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                      SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        controller: _verificationCodeController,
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 248, 245, 245),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                          hintText: '인증번호를 입력해 주세요.',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          if (value.length <= 4) {
                            setState(() {
                              _isVerificationCodeValid = value.length == 4;
                            });
                          } else {
                            // 사용자가 4자리를 초과하여 입력하는 경우, 입력값을 4자리로 제한
                            setState(() {
                              _verificationCodeController.text =
                                  value.substring(0, 4);
                              _verificationCodeController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _verificationCodeController
                                        .text.length),
                              );
                              _isVerificationCodeValid = true;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                if (!_isCodeValid &&
                    _verificationCodeController.text.isNotEmpty &&
                    _verificationCodeController.text.length < 4)
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.0, 10.0, 10.0, 10.0),
                    child: Text(
                      '올바른 인증번호를 입력해 주세요.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: _isVerificationCodeValid ? _verifyCode : null,
                  child: Text('인증하기',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledForegroundColor: Colors.grey.withOpacity(0.38),
                    disabledBackgroundColor: Colors.grey.withOpacity(0.30),
                    padding:
                        EdgeInsets.symmetric(horizontal: 159, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: FindId()));
