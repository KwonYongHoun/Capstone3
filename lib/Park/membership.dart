import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MembershipManagementPage extends StatelessWidget {
  const MembershipManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원권 관리'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Column(
              children: [
                MembershipCard(title: 'SPOLEX 멤버십', height: 110), // 크기를 키운 박스
                SizedBox(height: 10),
                MembershipCard(title: '회원복', height: 80), // 크기를 키운 박스
              ],
            ),
          ),
          Divider(),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 패딩 값 설정
            title: Text('회원권 이용'),
            trailing: Icon(Icons.arrow_forward_ios, size: 17),
            leading: Icon(FontAwesomeIcons.play),
            onTap: () {},
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0), // 패딩 값 설정
            title: Text('회원권 정지'),
            trailing: Icon(Icons.arrow_forward_ios, size: 17),
            leading: Icon(FontAwesomeIcons.pause),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class MembershipCard extends StatelessWidget {
  final String title;
  final double height;

  const MembershipCard({Key? key, required this.title, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height, // 높이 지정
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[100], // 박스의 배경색을 밝은 회색으로 설정
      ),
      child: Align(
        alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
            color: Colors.green, // 글씨색을 초록색으로 설정
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MembershipManagementPage(),
  ));
}
