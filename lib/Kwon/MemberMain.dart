import 'package:flutter/material.dart';
import '../health.dart';
import 'AddMember.dart';
import 'MemberDetail.dart';
import 'SearchMember.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberManagementPage extends StatefulWidget {
  @override
  _MemberManagementPageState createState() => _MemberManagementPageState();
}

class _MemberManagementPageState extends State<MemberManagementPage> {
  List<Member> _members = [];
  int _currentMemberNumber = 0; // 현재 회원 번호를 저장하는 변수

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _calculateMemberNumber();
  }

  Future<void> _loadMembers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('members').get();
    final List<Member> members =
        snapshot.docs.map((doc) => Member.fromFirestore(doc)).toList();
    setState(() {
      _members = members;
    });
  }

  // 현재 회원 번호를 계산하는 메서드
  void _calculateMemberNumber() async {
    final now = DateTime.now();
    final snapshot = await FirebaseFirestore.instance
        .collection('members')
        .orderBy('memberNumber', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) {
      setState(() {
        _currentMemberNumber = int.parse(
            '${now.year.toString().substring(2)}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}000');
      });
    } else {
      final lastMember = Member.fromFirestore(snapshot.docs.first);
      final lastRegistrationDate = lastMember.registrationDate;
      if (lastRegistrationDate.year != now.year ||
          lastRegistrationDate.month != now.month ||
          lastRegistrationDate.day != now.day) {
        // 오늘 날짜와 마지막 등록일이 다른 경우
        setState(() {
          _currentMemberNumber = int.parse(
              '${now.year.toString().substring(2)}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}000');
        });
      } else {
        // 오늘 날짜와 마지막 등록일이 같은 경우
        setState(() {
          _currentMemberNumber = lastMember.memberNumber + 1;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원 관리'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => SearchDialog(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: _members.isEmpty
            ? Center(
                child: Text('등록된 회원이 없습니다'),
              )
            : DataTable(
                columnSpacing: MediaQuery.of(context).size.width * 0.08,
                columns: [
                  DataColumn(label: Text('회원 번호')),
                  DataColumn(label: Text('이름')),
                  DataColumn(label: Text('전화번호')),
                  DataColumn(label: Text('회원권')),
                ],
                rows: _members.map((member) {
                  return DataRow(
                    cells: [
                      DataCell(
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => MemberDetailsDialog(
                                member: member,
                                reloadMembers: _loadMembers,
                              ),
                            );
                          },
                          child: Text('${member.memberNumber}'),
                        ),
                      ),
                      DataCell(
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => MemberDetailsDialog(
                                member: member,
                                reloadMembers: _loadMembers,
                              ),
                            );
                          },
                          child: Text(member.name),
                        ),
                      ),
                      DataCell(
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => MemberDetailsDialog(
                                member: member,
                                reloadMembers: _loadMembers,
                              ),
                            );
                          },
                          child: Text(member.phoneNumber),
                        ),
                      ),
                      DataCell(
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => MemberDetailsDialog(
                                member: member,
                                reloadMembers: _loadMembers,
                              ),
                            );
                          },
                          child: Text(member.memberState),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final member = await showDialog<Member>(
            context: context,
            builder: (_) => AddMemberDialog(
              currentMemberNumber: _currentMemberNumber,
              reloadMembers: _loadMembers,
            ),
          );
          if (member != null) {
            await FirebaseFirestore.instance
                .collection('members')
                .add(member.toFirestore());
            _loadMembers();
            _currentMemberNumber++; // 회원 추가 후 회원 번호 증가
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
