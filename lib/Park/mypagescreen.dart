import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'loginpage.dart';
import 'passwordchange.dart';
import 'membership.dart';
import 'nicknamechange.dart';
import 'bodyinfo.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MypageScreen> {
  // 샘플 사용자 정보
  final String userName = "홍길동";
  final String userId = "sku12340001";
  final double userHeight = 175.0; // cm
  final double userWeight = 70.0; // kg

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그아웃'),
          content: Text('정말 로그아웃 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ); // LoginPage로 이동
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
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              gradient: LinearGradient(
                colors: [Colors.lightGreen, Colors.lightGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.green[100],
                    child: Icon(FontAwesomeIcons.userAlt, size: 25.0),
                  ),
                  title: Text(userName),
                  subtitle: Text('회원번호: $userId'),
                ),
                Divider(color: Colors.white),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 10, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('회원 신체 정보',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text('- 키: ${userHeight}cm',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Text('- 몸무게: ${userWeight}kg',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 패딩 값 설정
            title: Text('회원 신체 정보'),
            trailing: Icon(Icons.arrow_forward_ios, size: 17),
            leading: Icon(FontAwesomeIcons.person),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BodyInfoPage()),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 패딩 값 설정
            leading: Icon(FontAwesomeIcons.edit), // 닉네임 관리 아이콘
            title: Text('닉네임 관리'),
            trailing: Icon(Icons.arrow_forward_ios, size: 17),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NicknameChangePage()),
              );
            },
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 패딩 값 설정
            leading: Icon(FontAwesomeIcons.lock), // 비밀번호 관리 아이콘
            title: Text('비밀번호 관리'),
            trailing: Icon(Icons.arrow_forward_ios, size: 17),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PasswordChangePage()),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 패딩 값 설정
            leading: Icon(FontAwesomeIcons.idCard), // 회원권 관리 아이콘
            title: Text('회원권 관리'),
            trailing: Icon(Icons.arrow_forward_ios, size: 17),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => MembershipManagementPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 패딩 값 설정
            leading: Icon(FontAwesomeIcons.signOutAlt), // 로그아웃 아이콘
            title: Text('로그아웃'),
            trailing: Icon(Icons.arrow_forward_ios, size: 17),
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
