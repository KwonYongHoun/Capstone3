import 'package:flutter/material.dart';
import 'package:health/Sin/post_detail.dart';
import '../health.dart'; // DatabaseHelper와 Commu, Comment 클래스 import

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<Commu> allPosts;

  CustomSearchDelegate(this.allPosts);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context); // Clear the suggestions
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text('검색어를 입력하세요'),
      );
    }

    return FutureBuilder<List<Commu>>(
      future: DatabaseHelper.searchPosts(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('에러: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('검색 결과가 없습니다.'));
        } else {
          final filteredPosts = snapshot.data!;
          return ListView.builder(
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.content),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(
                        post: post,
                        onCommentAdded: () {},
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Text('검색어를 입력하세요'),
      );
    }

    return FutureBuilder<List<Commu>>(
      future: DatabaseHelper.searchPosts(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('에러: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('추천 결과가 없습니다.'));
        } else {
          final suggestedPosts = snapshot.data!;
          return ListView.builder(
            itemCount: suggestedPosts.length,
            itemBuilder: (context, index) {
              final post = suggestedPosts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.content),
                onTap: () {
                  query = post.title;
                  showResults(context);
                },
              );
            },
          );
        }
      },
    );
  }
}
