import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // sqflite 라이브러리 추가

class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  // SQLite 데이터베이스에 게시물 추가하는 함수
  Future<void> addPostToDatabase() async {
    // SQLite 데이터베이스 열기
    Database db = await openDatabase('capstone.db3');

    // 현재 시간 가져오기
    DateTime now = DateTime.now();

    // INSERT 쿼리 실행
    await db.insert(
      'Posts',
      {
        'Title': _titleController.text,
        'Content': _contentController.text,
        'CreatedAt': now.toString(),
        // 추가로 필요한 작성자 정보 등을 여기에 추가할 수 있음
      },
    );

    // 데이터베이스 닫기
    await db.close();

    // 글쓰기 페이지 닫기 및 이전 페이지로 이동
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // 뒤로가기 버튼을 눌렀을 때 현재 페이지 닫기
            Navigator.pop(context);
          },
        ),
        title: Text('글쓰기'),
        actions: [
          TextButton(
            onPressed: () {
              // 완료 버튼을 눌렀을 때 데이터베이스에 게시물 추가
              addPostToDatabase();
            },
            child: Text(
              '완료',
              style: TextStyle(color: Colors.pink),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
          // 글쓰기 완료 버튼과 동일한 기능 수행
          addPostToDatabase();
        },
        label: Text('완료'),
        icon: Icon(Icons.done),
        backgroundColor: Colors.pink,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
