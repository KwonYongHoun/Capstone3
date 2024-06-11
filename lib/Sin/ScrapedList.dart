import 'package:flutter/material.dart';
import 'package:health/Sin/post_detail.dart';
import 'package:provider/provider.dart';
import '../health.dart'; // Commu 클래스 import
import '../Sin/AuthProvider.dart'; // AuthProvider import

class ScrapedPostsListPage extends StatefulWidget {
  @override
  _ScrapedPostsListPageState createState() => _ScrapedPostsListPageState();
}

class _ScrapedPostsListPageState extends State<ScrapedPostsListPage> {
  late Future<List<Commu>> _scrapedPostsFuture;

  @override
  void initState() {
    super.initState();
    _scrapedPostsFuture = _fetchScrapedPosts();
  }

  Future<List<Commu>> _fetchScrapedPosts() async {
    // 현재 로그인된 사용자의 회원 번호를 가져오는 로직 추가
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final loggedInMember = authProvider.loggedInMember;
    if (loggedInMember != null) {
      String memberNumber = loggedInMember.memberNumber.toString();
      // 회원 번호를 이용해서 스크랩한 게시물 가져오기
      return DatabaseHelper.getScrappedPosts(memberNumber);
    } else {
      // 로그인된 사용자가 없으면 빈 리스트 반환
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스크랩한 게시물'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Commu>>(
              future: _scrapedPostsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('스크랩한 게시물이 없습니다.'));
                } else {
                  final scrapedPosts = snapshot.data!;
                  return ListView.builder(
                    itemCount: scrapedPosts.length,
                    itemBuilder: (context, index) {
                      final post = scrapedPosts[index];
                      final formattedTimestamp =
                          '${post.createdAt.year}-${post.createdAt.month}-${post.createdAt.day} ${post.createdAt.hour}:${post.createdAt.minute}';
                      return PostWidget(
                        post: post,
                        formattedTimestamp: formattedTimestamp,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Commu post;
  final String formattedTimestamp;

  PostWidget({
    required this.post,
    required this.formattedTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final loggedInMember = authProvider.loggedInMember;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailPage(
              post: post,
              // 현재 로그인한 사용자 정보를 상세 페이지로 전달
              loggedInMember: loggedInMember, onCommentAdded: () {},
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
              post.title ?? '제목 없음',
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
