import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../health.dart';

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
  DateTime? suspendStartDate;
  DateTime? suspendEndDate;
  TextEditingController _suspendReasonController = TextEditingController();
  bool isLoading = true;

  final MembershipService _membershipService = MembershipService();

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

    var memberData = await _membershipService.getMemberData(memberNumber);
    if (memberData != null) {
      setState(() {
        memberState = memberData['memberState'];
        registrationDate = _parseDate(memberData['registrationDate']);
        expirationDate = _parseDate(memberData['expirationDate']);
        suspendStartDate =
            _parseDate(prefs.getString('suspendStartDate_$memberNumber'));
        suspendEndDate =
            _parseDate(prefs.getString('suspendEndDate_$memberNumber'));
        _suspendReasonController.text =
            prefs.getString('suspendReason_$memberNumber') ?? '';
        isLoading = false;
      });
      await _checkExpirationAndUpdateState();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateMemberState(String newState,
      {DateTime? newExpirationDate}) async {
    await _membershipService.updateMemberState(memberNumber, newState,
        newExpirationDate: newExpirationDate);
    setState(() {
      memberState = newState;
      if (newExpirationDate != null) {
        expirationDate = newExpirationDate;
      }
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

    if (suspendEndDate != null) {
      final now = DateTime.now();
      final suspendEndDateOnly = DateTime(
          suspendEndDate!.year, suspendEndDate!.month, suspendEndDate!.day);
      final todayOnly = DateTime(now.year, now.month, now.day);

      if (suspendEndDateOnly.isBefore(todayOnly)) {
        await _membershipService.updateMemberState(memberNumber, 'ing');
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'lastSuspendEndDate', suspendEndDate!.toIso8601String());
        await prefs.remove('suspendStartDate');
        await prefs.remove('suspendEndDate');
        await prefs.remove('suspendReason');
        setState(() {
          suspendStartDate = null;
          suspendEndDate = null;
          _suspendReasonController.clear();
        });
      }
    }
  }

  void _selectSuspendPeriod() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        suspendStartDate = picked.start;
        suspendEndDate = picked.end;
      });
    }
  }

  void _showSuspendMembershipDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSuspendEndDateStr = prefs.getString('lastSuspendEndDate');
    DateTime? lastSuspendEndDate = lastSuspendEndDateStr != null
        ? DateTime.parse(lastSuspendEndDateStr)
        : null;

    if (memberState != 'ing' && memberState != 'stop') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('멤버십을 구독해주세요'),
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
      return;
    }

    if (memberState == 'stop') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('알림'),
            content: Text('이미 멤버십이 정지 중입니다.'),
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
      return;
    }

    if (lastSuspendEndDate != null) {
      final now = DateTime.now();
      final allowedSuspendDate = lastSuspendEndDate.add(Duration(days: 30));

      if (now.isBefore(allowedSuspendDate)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('알림'),
              content: Text(
                  '정지가 풀린 후 한 달 동안 다시 정지할 수 없습니다. 다음 정지 가능 날짜: ${_formatDate(allowedSuspendDate)}'),
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
        return;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('멤버십 정지'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('멤버십을 정지하시겠습니까?'),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _selectSuspendPeriod,
                child: Text('정지 기간 선택'),
              ),
              if (suspendStartDate != null && suspendEndDate != null)
                Text(
                    '선택된 기간: ${_formatDate(suspendStartDate!)} - ${_formatDate(suspendEndDate!)}'),
              TextField(
                controller: _suspendReasonController,
                decoration: InputDecoration(labelText: '정지 사유'),
              ),
            ],
          ),
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
                _confirmSuspend();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _confirmSuspend() async {
    if (suspendStartDate != null && suspendEndDate != null) {
      int suspendDays = suspendEndDate!.difference(suspendStartDate!).inDays;
      DateTime newExpirationDate =
          expirationDate!.add(Duration(days: suspendDays));

      await _membershipService.updateMemberState(memberNumber, 'stop',
          newExpirationDate: newExpirationDate);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('suspendStartDate_$memberNumber',
          suspendStartDate!.toIso8601String());
      await prefs.setString(
          'suspendEndDate_$memberNumber', suspendEndDate!.toIso8601String());
      await prefs.setString(
          'suspendReason_$memberNumber', _suspendReasonController.text);

      setState(() {
        memberState = 'stop';
        expirationDate = newExpirationDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('멤버십 관리'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('멤버십 관리'),
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
                          if (memberState == 'stop' &&
                              suspendStartDate != null &&
                              suspendEndDate != null) ...[
                            Text(
                              '정지 기간: ${_formatDate(suspendStartDate!)} - ${_formatDate(suspendEndDate!)}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '정지 사유: ${_suspendReasonController.text}',
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
              title: Text('멤버십 정지'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: _showSuspendMembershipDialog,
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
