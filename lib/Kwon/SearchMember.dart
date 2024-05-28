import 'package:flutter/material.dart';
import 'package:health/Kwon/MemberDetail.dart';
import '../member.dart';

class SearchDialog extends StatefulWidget {
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() {});
  }

  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('검색'),
      content: TextField(
        decoration: InputDecoration(
          hintText: '검색어를 입력하세요',
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value; // 검색어를 업데이트합니다.
          });
        },
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            // 검색 버튼을 눌렀을 때의 로직
            // Member 데이터베이스에서 검색어와 일치하는 회원을 찾습니다.
            List<Member> matchingMembers =
                await DatabaseHelper.searchMembers(_searchQuery);
            if (matchingMembers.isNotEmpty) {
              // 일치하는 회원이 있을 경우, 첫 번째 일치하는 회원의 정보를 출력합니다.
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('검색 결과'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('회원 번호: ${matchingMembers[0].memberNumber}'),
                      Text('이름: ${matchingMembers[0].name}'),
                      Text('전화번호: ${matchingMembers[0].phoneNumber}'),
                      Text('회원권: ${matchingMembers[0].memberState}'),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // 결과 다이얼로그 닫기
                        showDialog(
                          context: context,
                          builder: (_) => MemberDetailsDialog(
                            member:
                                matchingMembers[0], // 첫 번째 일치하는 회원 정보를 전달합니다.
                            reloadMembers:
                                _loadMembers, // 회원 목록을 다시 로드하는 함수를 전달합니다.
                          ),
                        );
                      },
                      child: Text('수정'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 결과 다이얼로그 닫기
                      },
                      child: Text('닫기'),
                    ),
                  ],
                ),
              );
            } else {
              // 일치하는 회원이 없을 경우, 알림을 표시합니다.
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('검색 결과'),
                  content: Text('일치하는 회원이 없습니다.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 알림 닫기
                      },
                      child: Text('닫기'),
                    ),
                  ],
                ),
              );
            }
          },
          child: Text('검색'),
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
