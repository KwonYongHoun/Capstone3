import 'package:flutter/material.dart';
import '../health.dart'; // DatabaseHelper, Commu, Comment 클래스 import
import 'package:provider/provider.dart';
import '../health.dart';
import '../Sin/AuthProvider.dart';

class PostDetailPage extends StatefulWidget {
  final Commu post;
  final VoidCallback onCommentAdded;

  PostDetailPage({required this.post, required this.onCommentAdded});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  TextEditingController _commentController = TextEditingController();
  late Future<List<Comment>> _commentsFuture;
  int _likeCount = 0;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _fetchComments();
    _likeCount = widget.post.likeCount ?? 0;
  }

  Future<List<Comment>> _fetchComments() async {
    return DatabaseHelper.getCommentsByPostID(widget.post.postID!);
  }

  void _addComment(String postID, Member loggedInMember) async {
    if (_commentController.text.isNotEmpty) {
      Comment newComment = Comment(
        commentID: "",
        postID: postID,
        memberNumber: loggedInMember.memberNumber.toString(), // 예시로 사용한 회원 번호
        content: _commentController.text,
        createdAt: DateTime.now(),
      );

      await DatabaseHelper.insertComment(newComment);
      setState(() {
        _commentsFuture = _fetchComments();
        widget.onCommentAdded();
      });
      _commentController.clear();
    }
  }

  void _toggleLike() async {
    int currentLikeCount =
        await DatabaseHelper.getLikeCount(widget.post.postID!);
    setState(() {
      if (_isLiked) {
        _likeCount = currentLikeCount - 1;
      } else {
        _likeCount = currentLikeCount + 1;
      }
      _isLiked = !_isLiked;
    });
    await DatabaseHelper.updateLikeCount(widget.post.postID!, _likeCount);
  }

  void _reportPost() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('신고'),
        content: Text('신고하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('아니오'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              int currentReportCount =
                  await DatabaseHelper.getReportCount(widget.post.postID!);
              await DatabaseHelper.updateReportCount(
                  widget.post.postID!, currentReportCount + 1);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('신고가 접수되었습니다.')));
            },
            child: Text('예'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final loggedInMember = authProvider.loggedInMember;

    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 상세보기'),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark_border),
            onPressed: () {
              // 스크랩 기능 추후 추가 예정
            },
          ),
          IconButton(
            icon: Icon(Icons.report_problem), // 싸이렌 아이콘 사용
            onPressed: _reportPost,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.post.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.post.name ?? 'Unknown',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              widget.post.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.post.createdAt.year}년 ${widget.post.createdAt.month}월 ${widget.post.createdAt.day}일 ${widget.post.createdAt.hour}시 ${widget.post.createdAt.minute}분',
                  style: TextStyle(color: Colors.grey),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {},
                    ),
                    Text('${widget.post.commentCount ?? 0}'),
                    IconButton(
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.red : null,
                      ),
                      onPressed: _toggleLike,
                    ),
                    Text('$_likeCount'),
                  ],
                ),
              ],
            ),
            Divider(), // 선으로 구분
            SizedBox(height: 20),
            Text(
              '댓글',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Comment>>(
                future: _commentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('댓글이 없습니다.'));
                  } else {
                    final comments = snapshot.data!;
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          title: Text(comment.content),
                          subtitle: Text(
                            '${comment.createdAt.year}년 ${comment.createdAt.month}월 ${comment.createdAt.day}일 ${comment.createdAt.hour}시 ${comment.createdAt.minute}분',
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: '댓글을 입력하세요',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _addComment(widget.post.postID!, loggedInMember!);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
