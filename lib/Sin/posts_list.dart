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
    return DatabaseHelper.getPostsByType(widget.boardType);
  }

  void _refreshPosts() {
    setState(() {
      _postsFuture = _fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardType),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Commu>>(
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
                      return Column(
                        children: [
                          PostWidget(
                            post: post,
                            onPostUpdated: _refreshPosts,
                          ),
                          Divider(
                            color: Colors.grey, // 선의 색상
                            height: 10, // 선의 높이
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WritePage(), // 글쓰기 페이지로 이동
            ),
          ).then((_) {
            _refreshPosts(); // 글쓰기 페이지에서 돌아오면 목록을 갱신합니다.
          });
        },
        child: Icon(Icons.create), // 연필 아이콘
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Commu post;
  final VoidCallback onPostUpdated;

  PostWidget({required this.post, required this.onPostUpdated});

  @override
  Widget build(BuildContext context) {
    String formattedTimestamp =
        '${post.createdAt.year}-${post.createdAt.month}-${post.createdAt.day} ${post.createdAt.hour}:${post.createdAt.minute}';

    if (post.title == null) {
      print('Post title is null for postID: ${post.postID}');
    } else {
      print('Post title for postID ${post.postID}: ${post.title}');
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(
              post: post,
              onCommentAdded: onPostUpdated,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title ?? 'No Title', // null인 경우 처리
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              post.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.comment),
                    SizedBox(width: 5),
                    Text(
                      '${post.commentCount}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  '$formattedTimestamp',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
