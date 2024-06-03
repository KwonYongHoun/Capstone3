import 'package:flutter/material.dart';
import '../health.dart';
import 'posts_list.dart';
import 'search.dart'; // CustomSearchDelegate import
import 'ScrapedList.dart'; // ScrapedPostsListPage import 추가

class CommunityPage extends StatelessWidget {
  final List<Commu> allPosts; // 모든 게시물 리스트

  CommunityPage({required this.allPosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          leading: Container(),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate:
                      CustomSearchDelegate(allPosts.isNotEmpty ? allPosts : []),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.bookmark),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ScrapedPostsListPage(), // 스크랩된 게시물 목록 화면으로 이동
                  ),
                );
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(
              color: Colors.grey,
              height: 10,
            ),
          ),
          title: Row(
            children: [
              SizedBox(width: 16),
              Text(
                '커뮤니티',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10), // 상단바와 자유게시판 사이 간격 조정
        child: Column(
          children: [
            _buildBoardButton(context, "자유게시판", 'assets/images/b.b_1.png', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PostsListPage(boardType: '자유게시판')), // PostsListPage로 이동
              );
            }),
            _buildBoardButton(context, "헬스 파트너 찾기", 'assets/images/b.b_2.png',
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PostsListPage(boardType: '헬스 파트너 찾기')),
              );
            }),
            _buildBoardButton(context, "운동 고민 게시판", 'assets/images/b.b_3.png',
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PostsListPage(boardType: '운동 고민 게시판')),
              );
            }),
            _buildBoardButton(context, "식단공유 게시판", 'assets/images/b.b_4.png',
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostsListPage(boardType: '식단공유 게시판')),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBoardButton(BuildContext context, String boardTitle,
      String imagePath, Function() onTap) {
    // onTap 함수 추가
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child: GestureDetector(
        onTap: onTap, // onTap 함수 적용
        child: Container(
          width: 420,
          height: 160,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  boardTitle,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "바로가기",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 27, 29, 129)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
