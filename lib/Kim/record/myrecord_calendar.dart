import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:health/Kim/record/myrecord_page.dart';
import 'package:health/Kim/record/myrecord_statistic.dart';

// 문제: 현재 달이 아닌 다른 달의 날짜를 선택하려고 하면 선택이 되지 않고 현재의 달로 되돌아옴
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
  int _currentIndex = 2; // Default index is 2 for '홈'

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
            icon: const Icon(Icons.bar_chart), // '통계' 아이콘
            tooltip: '통계', // 아이콘 툴팁
          ),
        ],
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
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(),
              defaultTextStyle: const TextStyle(color: Colors.black),
              outsideTextStyle: const TextStyle(color: Colors.black),
              todayTextStyle:
                  const TextStyle(color: Colors.green), // 오늘 날짜의 글씨색을 초록색으로 설정
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                    color: Colors.green, width: 1.5), // 선택된 날짜의 테두리를 초록색으로 설정
              ),
              selectedTextStyle: const TextStyle(
                  color: Colors.black), // 선택된 날짜의 텍스트 색상을 검정색으로 설정
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
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 24), // 버튼 내부 padding 설정
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 버튼의 모서리를 둥글게 설정
                side: const BorderSide(
                    color: Colors.green, width: 2), // 버튼의 테두리 설정
              ),
            ),
            child: const Text(
              '나의 운동 기록 추가하기',
              style: TextStyle(
                color: Colors.green, // 텍스트 색상을 초록색으로 설정
                fontWeight: FontWeight.bold, // 텍스트 굵기를 굵게 설정
              ),
            ), // 버튼 텍스트 설정
          ),
        ],
      ),
    );
  }
}
