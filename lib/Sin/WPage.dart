import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../health.dart';

class WritePage extends StatefulWidget {
  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  String _selectedCategory = '자유게시판'; // Default category
  bool _isAnonymous = false; // Anonymous flag

  // Function to add a post to the database
  Future<void> addPostToDatabase() async {
    // SQLite database open
    Database db = await DatabaseHelper.initDatabase();

    // Current time
    DateTime now = DateTime.now();

    // Author name setting (based on anonymous flag)
    String authorName =
        _isAnonymous ? '익명' : '회원이름'; // Replace with actual user name

    // Create Commu instance
    Commu newPost = Commu(
      type: _selectedCategory,
      title: _titleController.text,
      content: _contentController.text,
      createdAt: now,
      name: authorName,
    );

    // Insert the post into the database
    await DatabaseHelper.insertPost(newPost);

    // Close the database
    await db.close();

    // Close the write page and navigate back to the previous page
    Navigator.pop(context as BuildContext);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('글쓰기'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    items: <String>[
                      '자유게시판',
                      '헬스 파트너 찾기',
                      '운동 고민 게시판',
                      '식단공유 게시판',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Checkbox(
                  value: _isAnonymous,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isAnonymous = newValue!;
                    });
                  },
                ),
                Text('익명'),
              ],
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: '제목을 입력하세요',
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: '내용을 입력하세요',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          addPostToDatabase();
        },
        label: Text('완료'),
        icon: Icon(Icons.done),
        backgroundColor: Colors.pink,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
