import 'package:flutter/material.dart';
import 'Commu.dart'; // Commu 클래스 import

class PostDetailPage extends StatelessWidget {
  final Commu post;

  PostDetailPage({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 상세보기'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.type,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              post.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              '작성일: ${post.createdAt.toLocal()}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
