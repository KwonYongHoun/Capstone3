import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'loginpage.dart';
import 'passwordchange.dart';
import 'membership.dart';
import 'nicknamechange.dart';
import 'bodyinfo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../health.dart';
import '../Sin/AuthProvider.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MypageScreen> {
  String name = '';
  String id = '';
  double userHeight = 0; // cm
  double userWeight = 0; // kg
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final loggedInMember =
        Provider.of<AuthProvider>(context, listen: false).loggedInMember;

    if (loggedInMember != null) {
      final bodyInfo =
          await DatabaseHelper.getBodyInfo(loggedInMember.memberNumber);
      setState(() {
        name = loggedInMember.nickname.isNotEmpty
            ? loggedInMember.nickname
            : loggedInMember.name;
        id = loggedInMember.memberNumber.toString();
        if (bodyInfo != null) {
          userHeight = bodyInfo.height;
          userWeight = bodyInfo.weight;
        }
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용자 정보를 불러올 수 없습니다.')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
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
                          child: Icon(Icons.person, size: 25.0),
                        ),
                        title: Text('$name 님'),
                        subtitle: Text('회원번호: $id'),
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
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                            Text('- 몸무게: ${userWeight}kg',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 패딩 값 설정
                  title: Text('회원 신체 정보'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 17),
                  leading: Icon(Icons.person),
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => BodyInfoPage()),
                    );

                    if (result != null) {
                      setState(() {
                        userHeight = result['height'];
                        userWeight = result['weight'];
                      });
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 패딩 값 설정
                  leading: Icon(Icons.edit), // 닉네임 관리 아이콘
                  title: Text('닉네임 관리'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 17),
                  onTap: () async {
                    final newNickname = await Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => NicknameChangePage()),
                    );

                    if (newNickname != null) {
                      setState(() {
                        name = newNickname;
                      });
                    }
                  },
                ),
                Divider(),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 패딩 값 설정
                  leading: Icon(Icons.lock), // 비밀번호 관리 아이콘
                  title: Text('비밀번호 관리'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 17),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => PasswordChangePage()),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 패딩 값 설정
                  leading: Icon(Icons.card_membership), // 회원권 관리 아이콘
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
                  leading: Icon(Icons.logout), // 로그아웃 아이콘
                  title: Text('로그아웃'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 17),
                  onTap: _showLogoutDialog,
                ),
              ],
            ),
    );
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
                Provider.of<AuthProvider>(context, listen: false).logout();
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
  void dispose() {
    super.dispose();
  }
}
