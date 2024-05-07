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
  final List<String> _dates = ['1일', '2일', '3일', '4일', '5일', '6일', '7일'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 통계'),
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
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '운동 시간 (시간)',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                if (_selectedPeriod == '일간') // '일간' 버튼이 선택되었을 때만 그래프를 표시합니다.
                  Expanded(
                    child: _buildStatisticContent(),
                  ),
              ],
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            bottomTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTextStyles: (value) => const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              getTitles: (value) {
                return _dates[value.toInt()];
              },
              margin: 8,
            ),
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTextStyles: (value) => const TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              getTitles: (value) {
                // 60분 단위로 표시
                return '${(value.toInt() * 60 / 60).toStringAsFixed(1)}'; // 분을 시간으로 변경
              },
              margin: 12,
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
                return '(시간)';
              },
              margin: 8,
            ),
          ),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: 5, // 5시간
          lineBarsData: [
            LineChartBarData(
              spots: _exerciseData[_selectedPeriod]!
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              colors: [Colors.blue],
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
