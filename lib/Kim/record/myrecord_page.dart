import 'package:flutter/material.dart';
import 'package:health/Kim/record/myrecord_machine.dart';

class MyRecordPage extends StatelessWidget {
  final DateTime selectedDate;

  const MyRecordPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 운동 기록'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            '${selectedDate.month}월 ${selectedDate.day}일',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),
          const Text(
            '실제 운동한 시간',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            '운동 시작 시간 - 운동 종료 시간',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          const SizedBox(height: 5), // '운동 부위'와 버튼 사이의 간격 조절
          const Text(
            '운동 부위\n',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: [
              _buildExerciseButton(context, '가슴'),
              _buildExerciseButton(context, '어깨'),
              _buildExerciseButton(context, '하체'),
              _buildExerciseButton(context, '팔'),
              _buildExerciseButton(context, '등'),
              _buildExerciseButton(context, '복근'),
              _buildExerciseButton(context, '유산소'),
              _buildExerciseButton(context, '기타'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseButton(BuildContext context, String text) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyRecordMachinePage(
                exercise: text,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, // 배경색을 하얀색으로 설정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.green), // 테두리를 회색으로 설정
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black, // 글꼴색을 검은색으로 설정
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
