import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseExplainPage extends StatelessWidget {
  final String exerciseName;
  final String description;
  final String imageUrl;
  final String url;

  const ExerciseExplainPage({
    Key? key,
    required this.exerciseName,
    required this.description,
    required this.imageUrl,
    required this.url,
  }) : super(key: key);

  Future<void> _launchURL(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Image.asset(
            imageUrl,
            height: 200,
          ),
          Container(
            width: double.infinity,
            height: 4,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          const Text(
            '운동 방법',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _launchURL(context, url);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.white), // 버튼의 배경색을 하얀색으로 지정
              foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.green), // 버튼의 텍스트 색상을 연두색으로 지정
              side: MaterialStateProperty.all<BorderSide>(
                  const BorderSide(color: Colors.green)), // 버튼의 테두리를 연두색으로 지정
            ),
            child: const Text('유튜브 검색'),
          ),
        ],
      ),
    );
  }
}
