import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/Kim/myrecord/myrecord_page.dart';
import '../database/calendar_database.dart'; // 데이터베이스 파일 임포트
import '/Sin/AuthProvider.dart'; // 로그인 정보를 가져오는 provider 파일

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
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
  bool _isEditingDuration = false; // 운동 시간을 수정 중인지 여부
  int _exerciseDuration = 0; // 해당 일자에 운동한 시간
  Map<DateTime, List<String>> _events = {}; // 이벤트 맵

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _focusedDay = _selectedDay;
    _calendarFormat = CalendarFormat.month;
    _elapsed = Duration.zero;
    _loadEvents(_selectedDay); // 이벤트 로드
    _loadExerciseDuration(_selectedDay); // 해당 일자에 운동한 시간 로드
    _timer = Timer(Duration.zero, () {});
  }

  void _loadEvents(DateTime selectedDay) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final memberNumber = authProvider.loggedInMemberNumber?.toString() ?? '';

    if (memberNumber.isNotEmpty) {
      final record = await CalendarDatabase.instance.getRecordByDate(
          memberNumber, selectedDay.toIso8601String().split('T')[0]);
      print('Loaded record: $record');
      setState(() {
        if (record != null) {
          String dateStr = record['date'];
          String durationStr = record['duration'].toString();
          // 키를 날짜 문자열로 변경하여 사용
          _events[DateTime.parse(dateStr)] = [durationStr]; // 여기에 추가
        } else {
          // 키를 selectedDay로 변경하여 사용
          _events[selectedDay] = []; // 여기에 추가
        }
        print('Events: $_events');
      });
    }
  }

  Future<void> _loadExerciseDuration(DateTime selectedDay) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final memberNumber = authProvider.loggedInMemberNumber?.toString() ?? '';

    if (memberNumber.isNotEmpty) {
      final record = await CalendarDatabase.instance.getRecordByDate(
          memberNumber, selectedDay.toIso8601String().split('T')[0]);
      print('Database record for $selectedDay: $record');

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

  String _formatDuration(int duration) {
    Duration dur = Duration(seconds: duration);
    return '${dur.inHours.toString().padLeft(2, '0')}:${(dur.inMinutes % 60).toString().padLeft(2, '0')}:${(dur.inSeconds % 60).toString().padLeft(2, '0')}';
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

  Future<void> _insertRecord() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final memberNumber = authProvider.loggedInMemberNumber?.toString() ?? '';
    String date = _selectedDay.toIso8601String().split('T').first;
    int duration = _elapsed.inSeconds;

    if (memberNumber.isNotEmpty) {
      await CalendarDatabase.instance
          .insertRecord(memberNumber, date, duration);
      _loadEvents(_selectedDay); // 저장 후 이벤트 다시 로드
      await _loadExerciseDuration(_selectedDay); // 운동 시간 다시 로드
      setState(() {
        _isRunning = false;
        _elapsed = Duration.zero;
        _isEditingDuration = false; // 운동 시간 변경 모드 종료
      });
    }
  }

  Future<void> _deleteRecord() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final memberNumber = authProvider.loggedInMemberNumber?.toString() ?? '';
    String date = _selectedDay.toIso8601String().split('T').first;

    if (memberNumber.isNotEmpty) {
      await CalendarDatabase.instance.deleteRecord(memberNumber, date);
      _loadEvents(_selectedDay); // 저장 후 이벤트 다시 로드
      await _loadExerciseDuration(_selectedDay); // 운동 시간 다시 로드
      setState(() {
        _isRunning = false;
        _elapsed = Duration.zero;
        _isEditingDuration = false; // 운동 시간 변경 모드 종료
        // 운동 기록이 삭제되었으므로 버튼들을 다시 표시
        _showExerciseButtons();
      });
    }
  }

  void _showExerciseButtons() {
    setState(() {
      _isRunning = false;
      _isEditingDuration = false;
    });
  }

  Widget _buildTableCell(DateTime date, List events) {
    final hasEvent = events.isNotEmpty;
    final isToday = isSameDay(date, _selectedDay);
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: isToday
            ? Colors.blueAccent
            : hasEvent
                ? Colors.blue
                : null,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
            color: isToday
                ? Colors.white
                : hasEvent
                    ? Colors.black
                    : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 운동 기록'),
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
            eventLoader: (day) {
              List<String>? events = _events[day];
              print('Events for $day: $events'); // 추가: 이벤트 로드 확인
              return events != null ? events : [];
            },
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _isEditingDuration = false; // 날짜가 변경되면 수정 중인 플래그를 초기화
                _loadEvents(selectedDay); // 선택한 날짜에 맞는 데이터 로드
                _loadExerciseDuration(selectedDay); // 선택한 날짜에 맞는 운동 시간 로드
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
              defaultDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                    color: const Color.fromARGB(0, 0, 0, 0),
                    width: 0), // 변경된 부분
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
              weekdayStyle: TextStyle(color: Colors.black),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final markers = <Widget>[];
                // 이벤트가 존재하고 비어 있지 않은 경우에만 마커 추가
                if (_events.containsKey(date.toString()) &&
                    _events[date.toString()]!.isNotEmpty) {
                  markers.add(
                    Positioned(
                      bottom: 1,
                      child: Container(
                        height: 6,
                        width: 6,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }
                return markers.isEmpty ? null : Stack(children: markers);
              },
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
            '${_formatDuration(_elapsed.inSeconds)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 12),
          if (_exerciseDuration > 0)
            Text(
              '오늘의 운동 시간: ${_formatDuration(_exerciseDuration)}',
              style: const TextStyle(fontSize: 16),
            ),
          const SizedBox(height: 12),
          _isEditingDuration
              ? Column(
                  children: [
                    Text(
                      _formatDuration(_elapsed.inSeconds),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                )
              : Row(
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
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
                        await _insertRecord(); // 시간 저장
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
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
    _timer.cancel(); // dispose 메서드에서 타이머 정리
    super.dispose();
  }
}
