import 'package:flutter/material.dart';
import '../health.dart'; // DatabaseHelper, Commu, Comment 클래스 import
import 'package:provider/provider.dart';
import '../Sin/AuthProvider.dart';

class PostDetailPage extends StatefulWidget {
  final Commu post;
  final VoidCallback onCommentAdded;

  PostDetailPage({
    required this.post,
    required this.onCommentAdded,
    Member? loggedInMember,
  });

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  TextEditingController _commentController = TextEditingController();
  late Future<List<Comment>> _commentsFuture;
  bool _isAnonymous = false;
  late Future<bool> _isScrappedFuture;

  @override
  void initState() {
    super.initState();
    _commentsFuture = _fetchComments();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final loggedInMember = authProvider.loggedInMember;
    _isScrappedFuture = loggedInMember != null
        ? DatabaseHelper.isPostScrapped(
            loggedInMember.memberNumber.toString(), widget.post.postID!)
        : Future.value(false);
  }

  Future<List<Comment>> _fetchComments() async {
    return DatabaseHelper.getCommentsByPostID(widget.post.postID!);
  }

  void _addComment(String postID, Member loggedInMember) async {
    if (_commentController.text.isNotEmpty) {
      String currentTimeMillis =
          DateTime.now().millisecondsSinceEpoch.toString();
      String commentID = "c" + currentTimeMillis;

      Comment newComment = Comment(
        commentID: commentID,
        postID: postID,
        memberNumber: loggedInMember.memberNumber.toString(),
        name: _isAnonymous ? '익명' : loggedInMember.name,
        content: _commentController.text,
        createdAt: DateTime.now(),
        isAnonymous: _isAnonymous,
        reportCount: 0,
      );

      await DatabaseHelper.insertComment(newComment);

      int newCommentCount = await DatabaseHelper.getCommentCount(postID);
      await DatabaseHelper.updateCommentCount(postID, newCommentCount);

      setState(() {
        _commentsFuture = _fetchComments();
        widget.onCommentAdded();
        widget.post.commentCount = newCommentCount;
      });
      _commentController.clear();
    }
  }

  void _showDeleteConfirmationDialog(String commentID, Member loggedInMember) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('삭제 확인'),
        content: Text('댓글을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('아니오'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteComment(commentID);
            },
            child: Text('예'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteComment(String commentID) async {
    try {
      await DatabaseHelper.deleteComment(commentID);
      int totalCommentCount =
          await DatabaseHelper.getCommentCount(widget.post.postID!);
      setState(() {
        _commentsFuture = _fetchComments();
        widget.post.commentCount = totalCommentCount;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글이 삭제되었습니다.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('댓글 삭제 중 오류가 발생했습니다.')),
      );
    }
  }

  void _reportComment(String commentID) async {
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('신고'),
          content: Text('이 댓글을 신고하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('아니오'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Comment? reportedComment =
                    await DatabaseHelper.getComment(commentID);
                if (reportedComment != null) {
                  int currentReportCount = reportedComment.reportCount ?? 0;
                  await DatabaseHelper.updateCommentReportCount(
                      commentID, currentReportCount + 1);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('댓글이 신고되었습니다.')));
                }
              },
              child: Text('예'),
            ),
          ],
        ),
      );
    }
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

  void _scrapPost(String memberNumber, String postID) async {
    List<Commu> scrappedPosts =
        await DatabaseHelper.getScrappedPosts(memberNumber);

    bool isScrapped = scrappedPosts.any((post) => post.postID == postID);

    if (isScrapped) {
      await DatabaseHelper.removeScrap(memberNumber, postID);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('게시물 스크랩이 취소되었습니다.')));
    } else {
      await DatabaseHelper.addScrap(memberNumber, postID);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('게시물이 스크랩되었습니다.')));
    }

    setState(() {
      _isScrappedFuture = DatabaseHelper.isPostScrapped(memberNumber, postID);
    });
  }

  void _deleteScrappedPost(String memberNumber, String postID) async {
    await DatabaseHelper.removeScrap(memberNumber, postID);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('스크랩된 게시물이 삭제되었습니다.')));

    setState(() {
      _isScrappedFuture = DatabaseHelper.isPostScrapped(memberNumber, postID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final loggedInMember = authProvider.loggedInMember;

    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 상세보기'),
        actions: [
          if (loggedInMember!.memberNumber.toString() ==
              widget.post.fk_memberNumber)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmationDialog(
                widget.post.postID!,
                loggedInMember,
              ),
            ),
          FutureBuilder<bool>(
            future: _isScrappedFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Icon(Icons.bookmark_border);
              } else if (snapshot.hasData && snapshot.data!) {
                return IconButton(
                  icon: Icon(Icons.bookmark),
                  color: Colors.yellow,
                  onPressed: () {
                    _scrapPost(loggedInMember.memberNumber.toString(),
                        widget.post.postID!);
                  },
                );
              } else {
                return IconButton(
                  icon: Icon(Icons.bookmark_border),
                  onPressed: () {
                    _scrapPost(loggedInMember.memberNumber.toString(),
                        widget.post.postID!);
                  },
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.report_problem),
            onPressed: _reportPost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title ?? '제목 없음',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(widget.post.content),
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
                  ],
                ),
              ],
            ),
            Divider(),
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
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                comment.isAnonymous ? '익명' : comment.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (loggedInMember.memberNumber.toString() ==
                                  comment.memberNumber)
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('삭제'),
                                    ),
                                  ],
                                  onSelected: (String value) {
                                    if (value == 'delete') {
                                      _showDeleteConfirmationDialog(
                                          comment.commentID, loggedInMember);
                                    }
                                  },
                                ),
                              if (loggedInMember.memberNumber.toString() !=
                                  comment.memberNumber)
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'report',
                                      child: Text('신고'),
                                    ),
                                  ],
                                  onSelected: (String value) {
                                    if (value == 'report') {
                                      _reportComment(comment.commentID);
                                    }
                                  },
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comment.content),
                              Text(
                                '${comment.createdAt.year}년 ${comment.createdAt.month}월 ${comment.createdAt.day}일 ${comment.createdAt.hour}시 ${comment.createdAt.minute}분',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
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
                Checkbox(
                  value: _isAnonymous,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAnonymous = value ?? false;
                    });
                  },
                ),
                Text('익명'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
