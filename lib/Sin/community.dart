import 'package:flutter/material.dart';
import 'fBoard.dart'; // fBoard 페이지를 import

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('메뉴바 아이콘을 눌렀을 때의 기능 추가');
          },
        ),
        title: Text('커뮤니티', style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              print('검색 기능 추가');
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              print('마이페이지로 이동');
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              print('스크랩 게시물 페이지로 이동');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1), // 선의 높이
          child: Divider(
            color: Colors.grey, // 선의 색상
            height: 0, // 선의 높이
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
                    builder: (context) => FBoardPage()), // fBoard 페이지로 이동
              );
            }),
            _buildBoardButton(context, "헬스 파트너 찾기", 'assets/images/b.b_2.png',
                () {
              // 다른 보드를 눌렀을 때의 동작 추가
            }),
            _buildBoardButton(context, "운동 고민 게시판", 'assets/images/b.b_3.png',
                () {
              // 다른 보드를 눌렀을 때의 동작 추가
            }),
            _buildBoardButton(context, "식단공유 게시판", 'assets/images/b.b_4.png',
                () {
              // 다른 보드를 눌렀을 때의 동작 추가
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.insert_chart),
              onPressed: () {
                print('통계 페이지로 이동');
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                print('홈 페이지로 이동');
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                print('마이페이지로 이동');
              },
            ),
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
