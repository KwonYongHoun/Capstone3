import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'passwordchange.dart';
import 'membership.dart';
import 'nicknamechange.dart';
import 'bodyinfo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../health.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MypageScreen> {
  String Name = enteredName;
  String Id = enteredId;
  double userHeight = 0; // cm
  double userWeight = 0; // kg

  @override
  void initState() {
    super.initState();
    _loadNickname();
    _loadBodyInfo();
  }

  Future<void> _loadNickname() async {
    Member? member = await DatabaseHelper.getMember(int.parse(Id));
    if (member != null) {
      setState(() {
        Name = member.nickname.isNotEmpty ? member.nickname : member.name;
      });
    }
  }

  Future<void> _loadBodyInfo() async {
    BodyInfo? bodyInfo = await DatabaseHelper.getBodyInfo(int.parse(Id));
    if (bodyInfo != null) {
      setState(() {
        userHeight = bodyInfo.height;
        userWeight = bodyInfo.weight;
      });
    }
  }

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
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
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
                    child: Icon(FontAwesomeIcons.user, size: 25.0),
                  ),
                  title: Text('$Name 님'), // 이름 또는 닉네임 표시
                  subtitle: Text('회원번호: $Id'),
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
          Divider(),
          ListTile(
              contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              title: Text('회원 신체 정보'),
              trailing: Icon(Icons.arrow_forward_ios, size: 17),
              leading: Icon(FontAwesomeIcons.person),
              onTap: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => BodyInfoPage(enteredId: Id)),
                );
                if (result != null && result is Map<String, double>) {
                  setState(() {
                    userHeight = result['height']!;
                    userWeight = result['weight']!;
                  });
                }
              }),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            leading: Icon(FontAwesomeIcons.edit),
            title: Text('닉네임 관리'),
            trailing: Icon(Icons.arrow_forward_ios, size: 17),
            onTap: () async {
              final newNickname = await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NicknameChangePage()),
              );
              if (newNickname != null) {
                setState(() {
                  Name = newNickname; // 닉네임을 Name에 덮어씌우기
                });
              }
            },
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            leading: Icon(FontAwesomeIcons.lock),
            title: Text('비밀번호 관리'),
            trailing: Icon(Icons.arrow_forward_ios, size: 17),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PasswordChangePage()),
              );
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            leading: Icon(FontAwesomeIcons.idCard),
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
            contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            leading: Icon(FontAwesomeIcons.signOutAlt),
            title: Text('로그아웃'),
            trailing: Icon(Icons.arrow_forward_ios, size: 17),
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }
}
