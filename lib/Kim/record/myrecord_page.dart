import 'package:flutter/material.dart';
import 'package:health/Kim/record/myrecord_statistic.dart'; // myrecord_machine.dart 파일을 임포트해야 합니다.
import 'package:health/Kim/record/myrecord_machine.dart';

class MyRecordPage extends StatelessWidget {
  final DateTime selectedDate; // 선택한 날짜를 저장하는 변수

  // 생성자 수정
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
          // 선택한 날짜 표시
          Text(
            '${selectedDate.month}월 ${selectedDate.day}일', // 선택된 날짜 표시
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
          const Text(
            '운동 부위',
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
              _buildExerciseButton(context, '엉덩이'),
              _buildExerciseButton(context, '등'),
              _buildExerciseButton(context, '복근'),
              _buildExerciseButton(context, '전신'),
              _buildExerciseButton(context, '유산소'),
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
          // 운동 부위 버튼을 눌렀을 때 myrecord_machine.dart로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyRecordMachinePage(
                exercise: text,
              ),
            ),
          );
        },
        child: Text(text),
      ),
    );
  }
}
