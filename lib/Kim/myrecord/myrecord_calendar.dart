import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../myrecord/myrecord_page.dart';
import '../myrecord/myrecord_statistic.dart';
import '../database/calendar_database.dart'; // 데이터베이스 파일 임포트
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '나의 운동 기록',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyrecordCalendarPage(),
    );
  }
}

class MyrecordCalendarPage extends StatefulWidget {
  const MyrecordCalendarPage({Key? key}) : super(key: key);

  @override
  _MyrecordCalendarPageState createState() => _MyrecordCalendarPageState();
}

class _MyrecordCalendarPageState extends State<MyrecordCalendarPage> {
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late Timer _timer;
  late Duration _elapsed;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _focusedDay = _selectedDay;
    _calendarFormat = CalendarFormat.month;
    _elapsed = Duration.zero;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed = Duration(seconds: _elapsed.inSeconds + 1);
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  Future<void> _saveRecord() async {
    String date = _selectedDay.toIso8601String().split('T').first;
    int duration = _elapsed.inSeconds;

    await CalendarDatabase().insertRecord(date, duration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 운동 기록'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyRecordStatisticPage(),
                ),
              );
            },
            icon: const Icon(Icons.bar_chart),
            tooltip: '통계',
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(),
              defaultTextStyle: const TextStyle(color: Colors.black),
              outsideTextStyle: const TextStyle(color: Colors.black),
              todayTextStyle: const TextStyle(color: Colors.green),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(color: Colors.green, width: 1.5),
              ),
              selectedTextStyle: const TextStyle(color: Colors.black),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
              weekdayStyle: TextStyle(color: Colors.black),
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyRecordPage(selectedDate: _selectedDay),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.green, width: 2),
              ),
            ),
            child: const Text(
              '나의 운동 기록 추가하기',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            ' ${_elapsed.inHours.toString().padLeft(2, '0')}:${(_elapsed.inMinutes % 60).toString().padLeft(2, '0')}:${(_elapsed.inSeconds % 60).toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isRunning
                    ? null
                    : () {
                        setState(() {
                          _isRunning = true;
                        });
                        _startTimer();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text(
                  '운동 시작',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: !_isRunning
                    ? null
                    : () {
                        setState(() {
                          _isRunning = false;
                        });
                        _stopTimer();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text(
                  '운동 중단',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_isRunning) {
                    _stopTimer();
                  }
                  await _saveRecord(); // 시간 저장
                  setState(() {
                    _isRunning = false;
                    _elapsed = Duration.zero;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text(
                  '운동 끝',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
