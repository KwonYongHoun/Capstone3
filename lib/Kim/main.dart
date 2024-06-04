import 'package:flutter/material.dart';
//import 'package:health/Kim/exercise/exercise_guide.dart';
//import 'package:health/Kim/record/myrecord_calendar.dart';
import '../Kim/myrecord/myrecord_calendar.dart';
import '../Kim//exercise/exercise_guide.dart';

// main.dart는 메뉴바(창)
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('메뉴'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('커뮤니티'),
            onTap: () {
              // 커뮤니티 페이지로 이동하는 코드 작성
            },
          ),
          ListTile(
            title: const Text('나의 기록'),
            onTap: () {
              // 나의 기록 페이지(캘린더 페이지)로 이동하는 코드 작성
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyrecordCalendarPage()),
              );
            },
          ),
          ListTile(
            title: const Text('운동 기구 사용 방법'),
            onTap: () {
              // 운동 기구 사용 방법 페이지로 이동하는 코드 작성
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ExerciseGuidePage()),
              );
            },
          ),
          ListTile(
            title: const Text('혼잡도'),
            onTap: () {
              // 혼잡도 페이지로 이동하는 코드 작성
            },
          ),
        ],
      ),
    );
  }
}

class MyRecordPage extends StatelessWidget {
  const MyRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 기록'),
      ),
      body: const Center(
        child: Text('캘린더 페이지'),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
