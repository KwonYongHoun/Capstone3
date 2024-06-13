import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class FindId extends StatefulWidget {
  @override
  _FindIdState createState() => _FindIdState();
}

class _FindIdState extends State<FindId> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController _verificationCodeController = TextEditingController();
  bool _isVerificationCodeValid = false;
  bool _isPhoneValid = false;
  bool _isVerificationCodeSent = false;
  bool _isCodeValid = false;

  Timer? _timer;
  int _start = 180;
  String _verificationId = '';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _verificationCodeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _sendVerificationCode() async {
    String name = _nameController.text;
    String phoneNumber = _phoneController.text;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('members')
        .where('name', isEqualTo: name)
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    if (snapshot.docs.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('오류'),
            content: Text('이름과 전화번호를 다시 한 번 확인 해주세요.'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isVerificationCodeSent = true;
        _start = 180;
      });
      _startTimer();

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+82' + phoneNumber,
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Failed to verify phone number: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
        },
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void _verifyCode() async {
    String smsCode = _verificationCodeController.text.trim();

    if (_verificationId.isNotEmpty && smsCode.isNotEmpty) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: smsCode);

      try {
        await FirebaseAuth.instance.signInWithCredential(credential);
        // 인증 성공 처리
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('오류'),
              content: Text('인증 번호가 잘못되었습니다.'),
              actions: <Widget>[
                TextButton(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
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
                    Container(
                      width: 120,
                      child: ElevatedButton(
                        onPressed: _isPhoneValid ? _sendVerificationCode : null,
                        child: Text(
                          _isVerificationCodeSent ? '재전송' : '인증번호 보내기',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.green,
                          backgroundColor: Colors.white,
                          side: BorderSide(
                              color: const Color.fromARGB(255, 160, 219, 162),
                              width: 1),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                      Stack(
                        children: [
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
                          Positioned(
                            right: 10,
                            top: 15,
                            child: Text(
                              _formatTime(_start),
                              style: TextStyle(
                                color: _start == 0 ? Colors.red : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
                  onPressed: _isVerificationCodeValid && _start > 0
                      ? _verifyCode
                      : null,
                  child: Text('인증하기',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    disabledForegroundColor: Colors.grey.withOpacity(0.38),
                    disabledBackgroundColor: Colors.grey.withOpacity(0.30),
                    padding: EdgeInsets.fromLTRB(159.0, 20.0, 159.0, 20.0),
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
