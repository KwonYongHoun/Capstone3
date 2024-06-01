import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../health.dart'; // DatabaseHelper와 Commu 클래스 import
import 'post_detail.dart'; // 게시물 상세 페이지 import
import 'WPage.dart'; // 글쓰기 페이지 import
import '../Sin/AuthProvider.dart'; // AuthProvider import

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
    await DatabaseHelper.initialize();
    return DatabaseHelper.getPostsByType(widget.boardType);
  }

  void _refreshPosts() {
    setState(() {
      _postsFuture = _fetchPosts();
    });
  }

  DecorationImage _getBackgroundImage(String boardType) {
    switch (boardType) {
      case '자유게시판':
        return DecorationImage(
          image: AssetImage('assets/images/001.png'),
          fit: BoxFit.cover,
        );
      case '헬스 파트너 찾기':
        return DecorationImage(
          image: AssetImage('assets/images/002.png'),
          fit: BoxFit.cover,
        );
      case '운동 고민 게시판':
        return DecorationImage(
          image: AssetImage('assets/images/003.png'),
          fit: BoxFit.cover,
        );
      default:
        return DecorationImage(
          image: AssetImage('assets/images/004.png'),
          fit: BoxFit.cover,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final loggedInMember = authProvider.loggedInMember;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardType),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: _getBackgroundImage(widget.boardType),
        ),
        child: Column(
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
                    return Center(child: Text('게시물이 없습니다.'));
                  } else {
                    final posts = snapshot.data!;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        final formattedTimestamp =
                            '${post.createdAt.year}-${post.createdAt.month}-${post.createdAt.day} ${post.createdAt.hour}:${post.createdAt.minute}';
                        return Column(
                          children: [
                            PostWidget(
                              post: post,
                              onPostUpdated: _refreshPosts,
                              commentCount: post.commentCount ?? 0,
                              title: post.title ?? '제목 없음',
                              formattedTimestamp: formattedTimestamp,
                            ),
                            Divider(
                              color: Color.fromARGB(255, 255, 255, 255),
                              height: 10,
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
      ),
      floatingActionButton: loggedInMember != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WritePage(),
                  ),
                ).then((_) {
                  _refreshPosts();
                });
              },
              child: Icon(Icons.create),
              backgroundColor: const Color.fromARGB(255, 241, 249, 253),
            )
          : null,
    );
  }
}

class PostWidget extends StatelessWidget {
  final Commu post;
  final VoidCallback onPostUpdated;
  final int commentCount;
  final String title;
  final String formattedTimestamp;

  PostWidget({
    required this.post,
    required this.onPostUpdated,
    required this.commentCount,
    required this.title,
    required this.formattedTimestamp,
  });

  @override
  Widget build(BuildContext context) {
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
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 253, 253, 253),
          border: Border.all(color: Color.fromARGB(255, 221, 220, 220)),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
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
                      '$commentCount',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Text(
                  formattedTimestamp,
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
