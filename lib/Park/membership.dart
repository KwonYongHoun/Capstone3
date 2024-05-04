import 'package:flutter/material.dart';

class MembershipManagementPage extends StatefulWidget {
  const MembershipManagementPage({Key? key}) : super(key: key);

  @override
  State<MembershipManagementPage> createState() =>
      _MembershipManagementPageState();
}

class _MembershipManagementPageState extends State<MembershipManagementPage> {
  bool isMembershipActive = true; // 예시로 회원권 상태를 나타내는 변수입니다.

  void _suspendMembership() {
    setState(() {
      isMembershipActive = false;
    });
  }

  void _showMembershipDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('회원권 정지 및 이용'),
          content: Text('회원권을 정지하시겠습니까, 아니면 계속 이용하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: Text('정지'),
              onPressed: () {
                _suspendMembership(); // 회원권을 정지하는 함수를 호출
                Navigator.of(context).pop(); // 다이얼로그를 닫음
              },
            ),
            TextButton(
              child: Text('이용'),
              onPressed: () {
                _activateMembership(); // 회원권을 이용하는 상태로 전환하는 함수를 호출
                Navigator.of(context).pop(); // 다이얼로그를 닫음
              },
            ),
          ],
        );
      },
    );
  }

  void _activateMembership() {
    setState(() {
      isMembershipActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원권 관리'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(50.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Row 내부의 위젯들을 상단으로 정렬합니다.
                children: [
                  Expanded(
                    // Column을 Expanded로 감싸서 가능한 모든 영역을 차지하도록 합니다.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Column의 내부 위젯들을 좌측으로 정렬합니다.
                      children: [
                        Text(
                          'SPOLEX 멤버십',
                          style: TextStyle(
                            fontSize: 24.0, // 크기를 조절하여 제목처럼 보이게 합니다.
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8), // 두 텍스트 사이에 간격을 줍니다.
                        Text(
                          isMembershipActive ? "이용 중" : "정지 중",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: isMembershipActive
                                ? Colors.green
                                : Colors.red, // 상태에 따라 색상을 변경합니다.
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            ListTile(
              title: Text('회원권 정지 및 이용'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: _showMembershipDialog, // 여기에 메서드 호출
            ),
          ],
        ),
      ),
    );
  }
}
