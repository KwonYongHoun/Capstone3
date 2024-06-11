import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Sin/post_detail.dart'; // PostDetailPage import
import '../health.dart'; // Commu 클래스 import

class ReportedPostsPage extends StatefulWidget {
  @override
  _ReportedPostsPageState createState() => _ReportedPostsPageState();
}

class _ReportedPostsPageState extends State<ReportedPostsPage> {
  final CollectionReference reportsCollection =
      FirebaseFirestore.instance.collection('reports');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('신고된 게시물 관리'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: reportsCollection.orderBy('reportCount', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('신고된 게시물이 없습니다.'));
            } else {
              final reportedPosts = snapshot.data!.docs;
              return ListView.builder(
                itemCount: reportedPosts.length,
                itemBuilder: (context, index) {
                  final post = reportedPosts[index];
                  final commu = Commu.fromFirestore(post);
                  return Card(
                    margin: EdgeInsets.only(bottom: 16.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            commu.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            commu.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            '신고 횟수: ${commu.reportCount}\n작성자: ${commu.name ?? 'Unknown'}',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deletePostAndReport(commu.postID!); // posts 컬렉션에서 게시물 삭제 및 reports 컬렉션에서 신고 기록 삭제
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  _deleteReport(post.id); // reports 컬렉션에서 신고 기록만 삭제
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _deletePostAndReport(String postId) async {
    try {
      // posts 컬렉션에서 게시물 삭제
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      // reports 컬렉션에서 신고 기록 삭제
      await reportsCollection.doc(postId).delete();
      // 삭제 성공 시 알림 표시 등 추가적인 처리
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('게시물 및 신고 기록이 삭제되었습니다.')));
    } catch (e) {
      // 삭제 실패 시 에러 처리
      print('Failed to delete post and report: $e');
      // 에러 메시지를 사용자에게 표시할 수도 있습니다.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('게시물 및 신고 기록 삭제에 실패했습니다.')));
    }
  }

  Future<void> _deleteReport(String reportId) async {
    try {
      // reports 컬렉션에서 신고 기록만 삭제
      await reportsCollection.doc(reportId).delete();
      // 삭제 성공 시 알림 표시 등 추가적인 처리
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('신고 기록이 삭제되었습니다.')));
    } catch (e) {
      // 삭제 실패 시 에러 처리
      print('Failed to delete report: $e');
      // 에러 메시지를 사용자에게 표시할 수도 있습니다.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('신고 기록 삭제에 실패했습니다.')));
    }
  }
}
