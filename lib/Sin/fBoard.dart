import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart'; // sqflite 라이브러리 추가
import 'WPage.dart'; // WritePage를 import

class FBoardPage extends StatefulWidget {
  @override
  _FBoardPageState createState() => _FBoardPageState();
}

class _FBoardPageState extends State<FBoardPage> {
  List<Map<String, dynamic>> posts = []; // 게시물 목록을 저장할 리스트

  @override
  void initState() {
    super.initState();
    // initState 메서드에서 게시물을 가져오는 함수 호출
    fetchPosts();
  }

  // SQLite에서 게시물을 가져오는 함수
  Future<void> fetchPosts() async {
    // SQLite 데이터베이스 열기
    Database db = await openDatabase('capstone.db3');

    // SELECT 쿼리 실행
    var fetchedResults = await db.query(
      'Posts',
      columns: ['Title', 'Content', 'CreatedAt'],
    );

    // 결과를 리스트에 저장
    setState(() {
      posts = fetchedResults;
    });

    // 데이터베이스 닫기
    await db.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('자유게시판', style: TextStyle(fontSize: 20)),
      ),
      body: ListView.builder(
        itemCount: posts.length, // 게시물 수만큼 아이템 생성
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(
                posts[index]['Title'], // 게시물 제목
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    posts[index]['Content'], // 게시물 내용
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(posts[index]['CreatedAt'].toString()), // 작성 시간
                ],
              ),
              onTap: () {
                // TODO: 게시물 상세 페이지로 이동하는 로직 추가
                print('게시물 상세 페이지로 이동');
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 글쓰기 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WritePage()),
          );
        },
        label: Text('글쓰기'),
        icon: Icon(Icons.edit),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // 버튼 위치 설정
    );
  }
}
