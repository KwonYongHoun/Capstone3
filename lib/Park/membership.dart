import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MembershipManagementPage extends StatefulWidget {
  @override
  _MembershipManagementPageState createState() =>
      _MembershipManagementPageState();
}

class _MembershipManagementPageState extends State<MembershipManagementPage> {
  late String memberState;
  late String memberNumber;
  DateTime? registrationDate;
  DateTime? expirationDate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMemberState();
  }

  Future<void> _loadMemberState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    memberNumber = prefs.getString('memberNumber') ?? '';
    memberState = prefs.getString('memberState') ?? '';

    if (memberNumber.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('members')
        .doc(memberNumber)
        .get();
    if (doc.exists) {
      setState(() {
        memberState = doc['memberState'];
        registrationDate = _parseDate(doc['registrationDate']);
        expirationDate = _parseDate(doc['expirationDate']);
        isLoading = false;
      });
      await _checkExpirationAndUpdateState(); // 만료일 체크 및 상태 업데이트
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateMemberState(String newState) async {
    await FirebaseFirestore.instance
        .collection('members')
        .doc(memberNumber)
        .update({
      'memberState': newState,
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('memberState', newState);
    setState(() {
      memberState = newState;
    });
  }

  Future<void> _checkExpirationAndUpdateState() async {
    if (expirationDate != null) {
      final now = DateTime.now();
      final expirationDateOnly = DateTime(
          expirationDate!.year, expirationDate!.month, expirationDate!.day);
      final todayOnly = DateTime(now.year, now.month, now.day);

      if (expirationDateOnly.isAtSameMomentAs(todayOnly)) {
        await _updateMemberState('X');
      }
    }
  }

  void _suspendMembership() {
    _updateMemberState('stop');
  }

  void _activateMembership() {
    _updateMemberState('ing');
  }

  void _showMembershipDialog() {
    if (memberState != 'ing' && memberState != 'stop') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('멤버십을 구독해야만 가능한 메뉴입니다'),
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
                  _suspendMembership();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('이용'),
                onPressed: () {
                  _activateMembership();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('회원권 관리'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SPOLEX 멤버십',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: _getMembershipTitleColor(),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          _getMembershipStatusText(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: _getMembershipStatusColor(),
                          ),
                        ),
                        if (memberState == 'ing' || memberState == 'stop') ...[
                          SizedBox(height: 8),
                          if (registrationDate != null) ...[
                            Text(
                              '등록일: ${_formatDate(registrationDate!)}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                          ],
                          if (expirationDate != null) ...[
                            Text(
                              '만료일: ${_formatDate(expirationDate!)}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ],
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
              onTap: _showMembershipDialog,
            ),
          ],
        ),
      ),
    );
  }

  String _getMembershipStatusText() {
    if (memberState == 'ing') {
      return '이용 중';
    } else if (memberState == 'stop') {
      return '정지 중';
    } else {
      return '멤버십을 구독해주세요';
    }
  }

  Color _getMembershipStatusColor() {
    if (memberState == 'ing') {
      return Colors.green;
    } else if (memberState == 'stop') {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  Color _getMembershipTitleColor() {
    if (memberState == 'ing' || memberState == 'stop') {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  DateTime? _parseDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    } else if (date is String) {
      return DateTime.tryParse(date);
    }
    return null;
  }
}
