import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import '../database/calendar_database.dart';
import '/Sin/AuthProvider.dart';
import '/Kim/myrecord/myrecord_machine.dart';
import '/Kim/myrecord/myrecord_page.dart';
import '/main.dart'; // RouteObserver가 있는 파일을 임포트

class MyRecordPage extends StatefulWidget {
  final DateTime selectedDate;

  const MyRecordPage({Key? key, required this.selectedDate}) : super(key: key);

  @override
  _MyRecordPageState createState() => _MyRecordPageState();
}

class _MyRecordPageState extends State<MyRecordPage> with RouteAware {
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  int _exerciseDuration = 0;
  late Timer _timer;
  List<Map<String, dynamic>> _exerciseDetails = [];

  @override
  void initState() {
    super.initState();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    _loadExerciseDuration();
    _loadExerciseDetails();
    _timer = Timer(Duration.zero, () {});
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   routeObserver.subscribe(this, ModalRoute.of(context)!);
  // }

  @override
  void dispose() {
    _startTimeController.dispose();
    _endTimeController.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadExerciseDuration();
    _loadExerciseDetails();
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
          _exerciseDuration = 0;
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

  String _formatDuration(int duration) {
    Duration dur = Duration(seconds: duration);
    return '${dur.inHours.toString().padLeft(2, '0')}:${(dur.inMinutes % 60).toString().padLeft(2, '0')}:${(dur.inSeconds % 60).toString().padLeft(2, '0')}';
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
            const Divider(),
            const SizedBox(height: 10),
            Text(
              '${widget.selectedDate.month}월 ${widget.selectedDate.day}일',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              width: 100,
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Column(
                children: [
                  Text(
                    '오늘의 운동 시간 ',
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${_formatDuration(_exerciseDuration)}',
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 26, 175, 7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 16),
            const SizedBox(height: 5),
            const Text(
              '추가할 운동 부위\n',
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
            const Divider(),
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
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyRecordMachinePage(
                exercise: text,
                selectedDate:
                    widget.selectedDate.toIso8601String().split('T')[0],
              ),
            ),
          );
          _loadExerciseDetails(); // 돌아왔을 때 새로고침
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
