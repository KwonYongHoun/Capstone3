import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/calendar_database.dart';
import '/Sin/AuthProvider.dart';

class ExerciseRecordPage extends StatefulWidget {
  final String exercise;
  final String memberNumber;
  final String selectedDate;

  ExerciseRecordPage({
    required this.exercise,
    required this.memberNumber,
    required this.selectedDate,
  });

  @override
  _ExerciseRecordPageState createState() => _ExerciseRecordPageState();
}

class _ExerciseRecordPageState extends State<ExerciseRecordPage> {
  final TextEditingController _exerciseTimeController = TextEditingController();
  String _selectedIntensity = '';
  String _detailedRecordType = '';
  int _setsCount = 0;
  late List<Map<String, dynamic>> _detailedRecords;

  @override
  void initState() {
    super.initState();
    _detailedRecords = _buildRecordList();
  }

  List<Map<String, dynamic>> _buildRecordList() {
    List<Map<String, dynamic>> records = [];
    for (int i = 0; i < _setsCount; i++) {
      Map<String, dynamic> record = {
        'type': _detailedRecordType,
        'value': '',
        'unit': '',
      };
      records.add(record);
    }
    return records;
  }

  String getUnit() {
    switch (_detailedRecordType) {
      case '횟수':
        return '회';
      case '무게':
        return 'kg';
      case '거리':
        return 'km';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 기록'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '운동 시간',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: ' (ex. 10분 / 10m)',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _exerciseTimeController,
              decoration: InputDecoration(
                hintText: '운동 시간을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '운동 강도',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIntensityButton('가볍게', Colors.black),
                _buildIntensityButton('적당히', Colors.black),
                _buildIntensityButton('격하게', Colors.black),
              ],
            ),
            SizedBox(height: 16),
            Text(
              '상세 기록',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ToggleButtons(
              children: [
                Text('횟수'),
                Text('무게'),
                Text('거리'),
              ],
              isSelected: [
                _detailedRecordType == '횟수',
                _detailedRecordType == '무게',
                _detailedRecordType == '거리',
              ],
              onPressed: (int index) {
                setState(() {
                  _detailedRecordType = index == 0
                      ? '횟수'
                      : index == 1
                          ? '무게'
                          : '거리';
                  _detailedRecords = _buildRecordList();
                });
              },
              color: const Color.fromARGB(255, 255, 174, 174), // 기본 텍스트 색상
              selectedColor: Color.fromARGB(255, 255, 255, 255), // 선택된 텍스트 색상
              fillColor: Color.fromARGB(255, 255, 174, 174), // 선택된 버튼 배경 색상
            ),
            SizedBox(height: 16),
            if (_detailedRecordType.isNotEmpty) ...[
              for (int i = 0; i < _setsCount; i++) ...[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '세트 ${i + 1} $_detailedRecordType',
                    border: OutlineInputBorder(),
                    suffixText: getUnit(),
                  ),
                  keyboardType: _detailedRecordType == '거리'
                      ? TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      if (_detailedRecords.length > i) {
                        _detailedRecords[i]['value'] = value;
                        _detailedRecords[i]['unit'] = getUnit();
                      } else {
                        _detailedRecords.add({
                          'type': _detailedRecordType,
                          'value': value,
                          'unit': getUnit()
                        });
                      }
                    });
                  },
                ),
                SizedBox(height: 8), // Add space between each set
              ],
              SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 150, // 버튼의 너비 조정
                  height: 30, // 버튼의 높이 조정
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _setsCount++;
                        _detailedRecords.add({
                          'type': _detailedRecordType,
                          'value': '',
                          'unit': getUnit(),
                        });
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color.fromARGB(255, 255, 174, 174), // 버튼 색상 지정
                    ),
                    child: Text(
                      '세트 추가하기',
                      style: TextStyle(color: Colors.white), // 버튼 텍스트 색상 지정
                    ),
                  ),
                ),
              ),
            ],
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 200, // 버튼의 너비 조정
                height: 50, // 버튼의 높이 조정
                child: ElevatedButton(
                  onPressed: () {
                    _saveExerciseRecord().then((saved) {
                      if (saved) {
                        Navigator.pop(context, true); // 데이터 저장 후 페이지 닫기
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 255, 193, 59), // 버튼 색상 지정
                  ),
                  child: Text(
                    '운동 기록 저장',
                    style: TextStyle(
                      color: Colors.white, // 버튼 텍스트 색상 지정
                      fontSize: 15, // 텍스트 크기 조정
                      fontWeight: FontWeight.bold, // 볼드체 설정
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntensityButton(String intensity, Color textColor) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIntensity = intensity;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
          return _selectedIntensity == intensity
              ? Color.fromARGB(255, 255, 174, 174)
              : Colors.white;
        }),
      ),
      child: Text(
        intensity,
        style: TextStyle(color: textColor), // 버튼 텍스트 색상 지정
      ),
    );
  }

  Future<bool> _saveExerciseRecord() async {
    final exerciseDate = widget.selectedDate;
    final exerciseTime = _exerciseTimeController.text;
    final exerciseIntensity = _selectedIntensity;

    try {
      await CalendarDatabase.instance.saveExerciseRecord(
        memberNumber: widget.memberNumber,
        exerciseName: widget.exercise,
        exerciseDate: exerciseDate,
        exerciseTime: exerciseTime,
        exerciseIntensity: exerciseIntensity,
        detailedRecord: _detailedRecords,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('운동 기록이 저장되었습니다.'),
      ));
      return true;
    } catch (error) {
      print('Error saving exercise record: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('운동 기록 저장 중 오류가 발생했습니다.'),
      ));
      return false;
    }
  }
}
