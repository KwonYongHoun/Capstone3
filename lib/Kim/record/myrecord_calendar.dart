import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:health/Kim/record/myrecord_page.dart';

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
  _MyrecordCalendarPageState createState() =>
      _MyrecordCalendarPageState(); // 변경된 부분
}

class _MyrecordCalendarPageState extends State<MyrecordCalendarPage> {
  // 변경된 부분
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = DateTime(now.year, now.month, now.day);
    _focusedDay = _selectedDay;
    _calendarFormat = CalendarFormat.month;
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
            focusedDay: DateTime.now(),
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
          ),
          ElevatedButton(
            onPressed: () {
              // '나의 운동 기록 추가하기' 버튼을 눌렀을 때 처리할 작업 작성
              // 예를 들어, 다른 페이지로 이동하는 코드를 작성할 수 있습니다.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyRecodePage()),
              );
            },
            child: const Text('나의 운동 기록 추가하기'),
          ),
        ],
      ),
    );
  }
}

class AddExerciseRecordPage extends StatelessWidget {
  const AddExerciseRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 기록 추가'),
      ),
      body: const Center(
        child: Text('운동 기록 추가 화면'),
      ),
    );
  }
}
