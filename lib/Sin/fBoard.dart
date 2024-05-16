import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Commu.dart'; // commu.dart 파일을 import합니다.

class FBoardPage extends StatefulWidget {
  @override
  _FBoardPageState createState() => _FBoardPageState();
}

class _FBoardPageState extends State<FBoardPage> {
  late DatabaseHelper _databaseHelper; // DatabaseHelper 객체를 선언합니다.
  List<Map<String, dynamic>> _posts = [];

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper(); // DatabaseHelper 객체를 초기화합니다.
    _initDatabaseAndFetchPosts();
  }

  Future<void> _initDatabaseAndFetchPosts() async {
    await DatabaseHelper.initDatabase(); // 데이터베이스를 초기화합니다.
    await _fetchPosts(); // 게시물을 가져옵니다.
  }

  Future<void> _fetchPosts() async {
    final List<Commu> fetchedResults =
        await DatabaseHelper.getPosts(); // DatabaseHelper를 통해 게시물 목록을 가져옵니다.
    setState(() {
      _posts = fetchedResults.map((post) => post.toMap()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 목록'),
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return ListTile(
            title: Text(post['content'] ?? ''),
            subtitle: Text(post['createdAt'] ?? ''),
            // 여기에 게시물 클릭 시 동작할 코드 작성
            onTap: () {},
          );
        },
      ),
    );
  }
}
