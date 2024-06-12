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
  List<Map<String, dynamic>> _exerciseDetails = [];

  @override
  void initState() {
    super.initState();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _loadExerciseDuration(); // 해당 일자에 운동한 시간 로드
    _loadExerciseDetails(); // 운동 상세 기록 로드
    _timer = Timer(Duration.zero, () {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadExerciseDetails(); // 화면에 표시될 때마다 호출하여 상세 운동 기록을 갱신합니다.
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

  Future<void> _loadExerciseDetails() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final memberNumber = authProvider.loggedInMemberNumber?.toString() ?? '';

    if (memberNumber.isNotEmpty) {
      final records = await CalendarDatabase.instance.getExerciseDetailsByDate(
          memberNumber, widget.selectedDate.toIso8601String().split('T')[0]);

      print('Exercise details for ${widget.selectedDate}: $records');

      if (records != null) {
        setState(() {
          _exerciseDetails = records;
        });
      } else {
        setState(() {
          _exerciseDetails = [];
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Divider(), // 이 부분이 추가된 선입니다.
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
                  color: Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
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
            const Divider(), // 추가된 선입니다.
            const SizedBox(height: 16),
            const SizedBox(height: 5),
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
            const SizedBox(height: 16),
            const Divider(), // 추가된 선입니다.
            const SizedBox(height: 16),
            Text(
              '저장된 운동 기록',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildExerciseDetails(),
          ],
        ),
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
                selectedDate:
                    widget.selectedDate.toIso8601String().split('T')[0],
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: const BorderSide(color: Colors.green),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseDetails() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _exerciseDetails.length,
      itemBuilder: (context, index) {
        final detail = _exerciseDetails[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail['exerciseName'] ?? '',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '운동 시간: ${detail['exerciseTime'] ?? '0'}',
                ),
                const SizedBox(height: 8),
                Text('운동 강도: ${detail['exerciseIntensity'] ?? ''}'),
                const SizedBox(height: 8),
                ...?(detail['detailedRecord'] is List
                    ? (detail['detailedRecord'] as List).map<Widget>((record) {
                        return Text(
                            '${record['type']} ${record['value']} ${record['unit']}');
                      }).toList()
                    : null),
              ],
            ),
          ),
        );
      },
    );
  }
}
