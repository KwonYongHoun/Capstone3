import 'package:flutter/material.dart';
import 'Commu.dart'; // DatabaseHelper와 Commu 클래스 import
import 'post_detail.dart'; // 게시물 상세 페이지 import
import 'WPage.dart'; // 글쓰기 페이지 import

class PostsListPage extends StatefulWidget {
  final String boardType;

  PostsListPage({required this.boardType});

  @override
  _PostsListPageState createState() => _PostsListPageState();
}

class _PostsListPageState extends State<PostsListPage> {
  late Future<List<Commu>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _fetchPosts();
  }

  Future<List<Commu>> _fetchPosts() async {
    await DatabaseHelper.initDatabase();
    return DatabaseHelper.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardType),
      ),
      body: FutureBuilder<List<Commu>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts available.'));
          } else {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.type),
                  subtitle: Text(
                    post.content.length > 50
                        ? '${post.content.substring(0, 50)}...'
                        : post.content,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailPage(post: post),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WritePage(), // 글쓰기 페이지로 이동
            ),
          );
        },
        child: Icon(Icons.create), // 연필 아이콘
        backgroundColor: Colors.pink, // 분홍색 배경색
      ),
    );
  }
}
