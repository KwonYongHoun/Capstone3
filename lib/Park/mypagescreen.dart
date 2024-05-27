import 'package:flutter/material.dart';

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
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(
              '$enteredName',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('회원 신체 정보'),
            trailing: Icon(Icons.arrow_forward_ios),
            leading: Icon(Icons.fitness_center),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BodyInfoPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.edit), // 닉네임 관리 아이콘
            title: Text('닉네임 관리'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NicknameChangePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock), // 비밀번호 관리 아이콘
            title: Text('비밀번호 관리'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PasswordChangePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.card_membership), // 회원권 관리 아이콘
            title: Text('회원권 관리'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => MembershipManagementPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app), // 로그아웃 아이콘
            title: Text('로그아웃'),
            trailing: Icon(Icons.arrow_forward_ios),
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
