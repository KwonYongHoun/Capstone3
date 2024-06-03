import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health/Sin/post_detail.dart';
import 'package:health/health.dart'; // Firebase Firestore 관련 패키지

class CustomSearchDelegate extends SearchDelegate<String> {
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection('posts');

  CustomSearchDelegate(List list); // Firebase posts 컬렉션 참조

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

    return FutureBuilder<QuerySnapshot>(
      future: postsCollection.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('에러: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('검색 결과가 없습니다.'));
        } else {
          final filteredPosts = snapshot.data!.docs.where((doc) {
            final post = doc.data() as Map<String, dynamic>;
            final title = post['title'] as String;
            final content = post['content'] as String;
            return title.contains(query) || content.contains(query);
          }).toList();

          if (filteredPosts.isEmpty) {
            return Center(child: Text('검색 결과가 없습니다.'));
          }

          return ListView.builder(
            itemCount: filteredPosts.length,
            itemBuilder: (context, index) {
              final post = filteredPosts[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(post['title']),
                subtitle: Text(post['content']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        final commu = Commu.fromMap(post);
                        return PostDetailPage(
                          post: commu,
                          onCommentAdded: () {},
                        );
                      },
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

    return FutureBuilder<QuerySnapshot>(
      future: postsCollection.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('에러: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('추천 결과가 없습니다.'));
        } else {
          final suggestedPosts = snapshot.data!.docs.where((doc) {
            final post = doc.data() as Map<String, dynamic>;
            final title = post['title'] as String;
            final content = post['content'] as String;
            return title.contains(query) || content.contains(query);
          }).toList();

          if (suggestedPosts.isEmpty) {
            return Center(child: Text('추천 결과가 없습니다.'));
          }

          return ListView.builder(
            itemCount: suggestedPosts.length,
            itemBuilder: (context, index) {
              final post = suggestedPosts[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(post['title']),
                subtitle: Text(post['content']),
                onTap: () {
                  query = post['title'];
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
