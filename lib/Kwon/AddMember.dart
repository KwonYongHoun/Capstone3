import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../health.dart';
import '../Sin/AuthProvider.dart';

class AddMemberDialog extends StatefulWidget {
  final int currentMemberNumber;
  final Function reloadMembers;

  const AddMemberDialog({
    Key? key,
    required this.currentMemberNumber,
    required this.reloadMembers,
  }) : super(key: key);

  @override
  _AddMemberDialogState createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _nicknameController;
  late TextEditingController _memberStateController;
  late DateTime _registrationDate;
  late DateTime _expirationDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _nicknameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _memberStateController = TextEditingController();
    _registrationDate = DateTime.now();
    _expirationDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('회원 추가'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
          onPressed: () {
            final member = Member(
              memberNumber: widget.currentMemberNumber,
              password: _phoneNumberController.text,
              name: _nameController.text,
              nickname: _nicknameController.text,
              phoneNumber: _phoneNumberController.text,
              registrationDate: _registrationDate,
              expirationDate: _expirationDate,
              memberState: _memberStateController.text,
            );

            // 회원 추가
            DatabaseHelper.insertMember(member);

            Navigator.pop(context);
            widget.reloadMembers();
          },
          child: Text('추가'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('취소'),
        ),
      ],
    );
  }
}
