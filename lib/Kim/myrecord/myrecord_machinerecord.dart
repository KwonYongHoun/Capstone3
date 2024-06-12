import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveExerciseRecord({
    required String memberNumber,
    required String exerciseName,
    required String exerciseDate,
    required String exerciseTime,
    required String exerciseIntensity,
    required List<Map<String, dynamic>> detailedRecord,
  }) async {
    try {
      await _db.collection('exercises').add({
        'memberNumber': memberNumber,
        'exerciseName': exerciseName,
        'exerciseDate': exerciseDate,
        'exerciseTime': exerciseTime,
        'exerciseIntensity': exerciseIntensity,
        'detailedRecord': detailedRecord,
      });
    } catch (e) {
      print('Error saving exercise record: $e');
    }
  }
}

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
      // 각 세트의 타입을 추가
      Map<String, dynamic> record = {
        'type': _detailedRecordType,
        'value': '',
        'unit': '', // 단위를 추가
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
            Text(
              '운동 시간',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                _buildIntensityButton('가볍게'),
                _buildIntensityButton('적당히'),
                _buildIntensityButton('격하게'),
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
                      // 입력된 값을 저장합니다.
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
              ],
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _setsCount++;
                    // 새로운 세트를 위한 빈 기록을 추가합니다.
                    _detailedRecords.add({
                      'type': _detailedRecordType,
                      'value': '', // 입력된 값이 저장될 공간을 미리 확보합니다.
                      'unit': getUnit(),
                    });
                  });
                },
                child: Text('세트 추가하기'),
              ),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _saveExerciseRecord();
              },
              child: Text('운동 기록 저장'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntensityButton(String intensity) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIntensity = intensity;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
          return _selectedIntensity == intensity ? Colors.blue : Colors.white;
        }),
      ),
      child: Text(intensity),
    );
  }

  void _saveExerciseRecord() {
    final exerciseDate = widget.selectedDate;
    final exerciseTime = _exerciseTimeController.text;
    final exerciseIntensity = _selectedIntensity;

    final db = FirebaseFirestore.instance;

    db.collection('exercises').add({
      'memberNumber': widget.memberNumber,
      'exerciseName': widget.exercise,
      'exerciseDate': exerciseDate,
      'exerciseTime': exerciseTime,
      'exerciseIntensity': exerciseIntensity,
      'detailedRecord': _detailedRecords,
    }).then((value) {
      setState(() {
        _exerciseTimeController.clear();
        _selectedIntensity = '';
        _detailedRecordType = '';
        _setsCount = 0;

        _detailedRecords =
            _buildRecordList(); // 초기화된 _detailedRecords를 사용하여 새로운 세트를 생성합니다.
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('운동 기록이 저장되었습니다.'),
      ));
    }).catchError((error) {
      print('Error saving exercise record: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('운동 기록 저장 중 오류가 발생했습니다.'),
      ));
    });
  }
}
