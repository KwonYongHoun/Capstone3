import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:health/Kim/exercise/exercise_guide.dart';
import 'package:health/Kim/record/myrecord_page.dart';
import 'mypagescreen.dart';
import 'homescreen.dart';
import 'findid.dart';
import 'findpassword.dart';
import 'passwordchange.dart';
import 'membership.dart';
import '../Sin/community.dart';
import '../Kim/exercise/exercise_guide.dart';
import '../Kim/record/myrecord_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 2;

  final List<Widget> _children = [
    CommunityPage(),
    ExerciseGuidePage(),
    HomeScreen(),
    MyRecordPage(selectedDate: DateTime.now()),
    MypageScreen(),
    FindId(),
    FindPassword(),
    PasswordChangePage(),
    MembershipManagementPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              '../assets/sku.jpeg', // 로고 이미지 경로
              height: 30, // 이미지 높이
              width: 50, // 이미지 너비
              fit: BoxFit.contain, // 이미지 채우기 옵션
            ),
            SizedBox(width: 5),
            Text(
              '헬스타임',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontStyle: FontStyle.italic, // 텍스트를 기울임
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Divider(
            // 수평 선
            height: 30,
            color: Colors.grey[200],
          ),
          Expanded(
            child: _children[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.lightGreen,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.0, // 선택된 항목의 폰트 크기
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 13.0, // 선택되지 않은 항목의 폰트 크기
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.userGroup),
            label: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.dumbbell),
            label: '운동기구',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartLine),
            label: '운동기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            label: '마이페이지',
          ),
        ],
      ),
    );
  }
}
