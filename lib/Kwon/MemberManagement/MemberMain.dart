import 'package:flutter/material.dart';
import '../../member.dart';
import 'AddMember.dart';
import 'MemberDetail.dart';
import 'SearchMember.dart';

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
    List<Member> members = await DatabaseHelper.getMembers();
    setState(() {
      _members = members;
    });
  }

  // 현재 회원 번호를 계산하는 메서드
  void _calculateMemberNumber() async {
    // 현재 날짜로부터 회원번호를 생성합니다.
    final now = DateTime.now();
    // 가장 최근의 회원 번호를 데이터베이스에서 가져옵니다.
    List<Member> members = await DatabaseHelper.getMembers();
    if (members.isEmpty) {
      _currentMemberNumber = int.parse(
          '${now.year.toString().substring(2)}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}000');
    } else {
      // 데이터베이스에 회원이 있는 경우 가장 최근의 회원 번호를 가져옵니다.
      _currentMemberNumber = members.last.memberNumber + 1;
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
            DatabaseHelper.insertMember(member);
            _loadMembers();
            _currentMemberNumber++; // 회원 추가 후 회원 번호 증가
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
