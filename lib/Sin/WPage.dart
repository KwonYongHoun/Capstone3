import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../health.dart';
import '../Sin/AuthProvider.dart';
import 'dart:math';

class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String _selectedCategory = '자유게시판'; // Default category
  bool _isAnonymous = false; // Anonymous flag

  Future<void> _addPostToDatabase(Member loggedInMember) async {
    // Current time
    DateTime now = DateTime.now();
    // 익명 여부에 따른 작성자 설정
    String authorName = _isAnonymous ? '익명' : loggedInMember.name;

    // Commu 객체 생성
    Commu newPost = Commu(
      postID: '', // 초기값을 빈 문자열로 설정
      type: _selectedCategory,
      title: _titleController.text,
      content: _contentController.text,
      createdAt: now,
      name: authorName,
      fk_memberNumber: loggedInMember.memberNumber.toString(),
    );

    try {
      // Firestore에 글 추가
      await DatabaseHelper.insertPost(newPost);
      // 성공적으로 게시되었음을 알리는 스낵바 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('글이 성공적으로 게시되었습니다.')),
      );
      // 글 작성 페이지 닫기
      Navigator.pop(context);
    } catch (e) {
      // 오류 발생 시 스낵바 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('글 게시 중 오류가 발생했습니다.')),
      );
      // 콘솔에 오류 메시지 출력
      print('글 게시 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final loggedInMember = authProvider.loggedInMember;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('글쓰기'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    items: <String>[
                      '자유게시판',
                      '헬스 파트너 찾기',
                      '운동 고민 게시판',
                      '식단공유 게시판',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Checkbox(
                  value: _isAnonymous,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isAnonymous = newValue!;
                    });
                  },
                ),
                Text('익명'),
              ],
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '제목을 입력하세요',
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '내용을 입력하세요',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (loggedInMember != null) {
            // 현재 로그인된 회원의 정보를 이용하여 글 작성
            _addPostToDatabase(loggedInMember);
          } else {
            // 로그인되지 않은 경우에 대한 처리
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('로그인 후에 글을 작성할 수 있습니다.')),
            );
          }
        },
        label: Text('완료'),
        icon: Icon(Icons.done),
        backgroundColor: Colors.pink,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
