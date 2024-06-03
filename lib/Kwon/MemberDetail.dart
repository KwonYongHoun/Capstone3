import 'package:flutter/material.dart';
import '../health.dart';

class MemberDetailsDialog extends StatefulWidget {
  final Member member;
  final Function reloadMembers;

  const MemberDetailsDialog({
    Key? key,
    required this.member,
    required this.reloadMembers,
  }) : super(key: key);

  @override
  _MemberDetailsDialogState createState() => _MemberDetailsDialogState();
}

class _MemberDetailsDialogState extends State<MemberDetailsDialog> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _memberStateController;
  late TextEditingController _passwordController;
  late DateTime _registrationDate;
  late DateTime _expirationDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.member.name);
    _phoneNumberController =
        TextEditingController(text: widget.member.phoneNumber);
    _memberStateController =
        TextEditingController(text: widget.member.memberState);
    _passwordController = TextEditingController(text: widget.member.password);
    _registrationDate = widget.member.registrationDate;
    _expirationDate = widget.member.expirationDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('회원 정보'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: '이름'),
          ),
          TextField(
            controller: _phoneNumberController,
            decoration: InputDecoration(labelText: '전화번호'),
          ),
          TextField(
            controller: _memberStateController,
            decoration: InputDecoration(labelText: '회원권 상태'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: '비밀번호'),
          ),
          SizedBox(height: 16),
          Text('등록일: ${_registrationDate.toString().substring(0, 10)}'),
          ElevatedButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _registrationDate,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                setState(() {
                  _registrationDate = selectedDate;
                });
              }
            },
            child: Text('등록일 선택'),
          ),
          SizedBox(height: 16),
          Text('만료일: ${_expirationDate.toString().substring(0, 10)}'),
          ElevatedButton(
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _expirationDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                setState(() {
                  _expirationDate = selectedDate;
                });
              }
            },
            child: Text('만료일 선택'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            final updatedMember = Member(
              memberNumber: widget.member.memberNumber,
              password: _passwordController.text,
              name: _nameController.text,
              phoneNumber: _phoneNumberController.text,
              registrationDate: _registrationDate,
              expirationDate: _expirationDate,
              memberState: _memberStateController.text,
            );
            await DatabaseHelper.updateMember(updatedMember); // 기존 회원 정보 업데이트
            Navigator.pop(context); // 다이얼로그 닫기
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('회원 정보가 업데이트되었습니다.')),
            );
            widget.reloadMembers(); // 회원 목록 다시 로드
          },
          child: Text('저장'),
        ),
        ElevatedButton(
          onPressed: () async {
            await DatabaseHelper.deleteMember(
                widget.member.memberNumber); // 회원 삭제
            Navigator.pop(context); // 다이얼로그 닫기
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('회원이 삭제되었습니다.')),
            );
            widget.reloadMembers(); // 회원 목록 다시 로드
          },
          child: Text('삭제'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // 다이얼로그 닫기
          },
          child: Text('취소'),
        ),
      ],
    );
  }
}
