import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MyRecordStatisticPage extends StatefulWidget {
  const MyRecordStatisticPage({Key? key}) : super(key: key);

  @override
  _MyRecordStatisticPageState createState() => _MyRecordStatisticPageState();
}

class _MyRecordStatisticPageState extends State<MyRecordStatisticPage> {
  String _selectedPeriod = '일간'; // 기본 선택: 일간

  // 가상의 운동 기록 데이터 (단위: 분)
  final Map<String, List<double>> _exerciseData = {
    '일간': [60, 65, 70, 75, 80, 85, 90],
    '주간': [420, 455, 490, 525, 560, 595, 630],
    '월간': [1800, 1950, 2100, 2250, 2400, 2550, 2700],
  };

  // 날짜 데이터
  final List<String> _dates = ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('통계'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPeriodButton('일간'),
              _buildPeriodButton('주간'),
              _buildPeriodButton('월간'),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildStatisticContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      child: Text(period),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.blue.shade200;
            }
            return _selectedPeriod == period ? Colors.blue : Colors.grey;
          },
        ),
      ),
    );
  }

  Widget _buildStatisticContent() {
    // 선택된 기간에 해당하는 운동 데이터
    final List<double>? exerciseData = _exerciseData[_selectedPeriod];

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff7589a2),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            getTitles: (value) {
              // 실제 날짜 수에 따라 동적으로 반환
              if (exerciseData != null && value.toInt() < exerciseData.length) {
                return _dates[value.toInt()]; // 날짜 표시
              }
              return '';
            },
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: false, // 세로축 숫자 표시 비활성화
          ),
          topTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            getTextStyles: (value) => const TextStyle(
              color: Color(0xff7589a2),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            getTitles: (value) {
              if (value == 0) {
                return '(시간)';
              } else {
                return '';
              }
            },
            margin: 8,
          ),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        // 선택된 기간에 따라 최대 X값을 설정
        maxX: exerciseData != null ? exerciseData.length.toDouble() - 1 : 6,
        minY: 0,
        maxY: 5, // 5시간
        lineBarsData: [
          LineChartBarData(
            spots: exerciseData != null
                ? exerciseData
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value))
                    .toList()
                : [],
            isCurved: true,
            colors: [Colors.blue],
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
