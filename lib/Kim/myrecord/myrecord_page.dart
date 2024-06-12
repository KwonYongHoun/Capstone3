import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/Kim/myrecord/myrecord_page.dart';
import '/Kim/myrecord/myrecord_machine.dart';
import '../database/calendar_database.dart'; // 데이터베이스 파일 임포트
import '/Sin/AuthProvider.dart';

class MyRecordPage extends StatefulWidget {
  // StatelessWidget에서 StatefulWidget으로 변경
  final DateTime selectedDate;

  const MyRecordPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _MyRecordPageState createState() => _MyRecordPageState();
}

class _MyRecordPageState extends State<MyRecordPage> {
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  int _exerciseDuration = 0; // 해당 일자에 운동한 시간
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _loadExerciseDuration(); // 해당 일자에 운동한 시간 로드
    _timer = Timer(Duration.zero, () {});
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  String _formatDuration(int duration) {
    Duration dur = Duration(seconds: duration);
    return '${dur.inHours.toString().padLeft(2, '0')}:${(dur.inMinutes % 60).toString().padLeft(2, '0')}:${(dur.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  Future<void> _loadExerciseDuration() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final memberNumber = authProvider.loggedInMemberNumber?.toString() ?? '';

    if (memberNumber.isNotEmpty) {
      final record = await CalendarDatabase.instance.getRecordByDate(
          memberNumber, widget.selectedDate.toIso8601String().split('T')[0]);
      print('Database record for ${widget.selectedDate}: $record');

      if (record != null) {
        setState(() {
          _exerciseDuration = record['duration'] as int;
        });
      } else {
        setState(() {
          _exerciseDuration = 0; // 해당 일자에 운동한 시간이 없으면 0으로 설정
        });
      }
    }
  }

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
            '${widget.selectedDate.month}월 ${widget.selectedDate.day}일',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 16),

          Container(
            width: 100,
            padding: EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue, // 선의 색상
                width: 2, // 선의 두께
              ),
              borderRadius: BorderRadius.circular(10), // 박스의 모서리를 둥글게 만듦
            ),
            child: Column(
              children: [
                Text(
                  '오늘의 운동 시간 ',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${_formatDuration(_exerciseDuration)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
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
                selectedDate: widget.selectedDate
                    .toIso8601String()
                    .split('T')[0], // 선택한 날짜를 전달
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
