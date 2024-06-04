import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  late Database _database;

  Future openDB() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'exercise_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE exercises(id INTEGER PRIMARY KEY, exercise TEXT, reps INTEGER, weight INTEGER, distance REAL)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertExercise(
      String exercise, int reps, int weight, double distance) async {
    await _database.insert(
      'exercises',
      {
        'exercise': exercise,
        'reps': reps,
        'weight': weight,
        'distance': distance
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class MyRecordMachineRecord extends StatefulWidget {
  final String exercise;

  MyRecordMachineRecord({required this.exercise});

  @override
  _MyRecordMachineRecordState createState() => _MyRecordMachineRecordState();
}

class _MyRecordMachineRecordState extends State<MyRecordMachineRecord> {
  final DatabaseManager _databaseManager =
      DatabaseManager(); // DatabaseManager 인스턴스 생성
  List<SetData> sets = [];
  bool _isSaved = false;
  String _selectedIntensity = ''; // 운동 강도를 저장할 변수
  final _exerciseTimeController =
      TextEditingController(); // 운동 시간을 입력 받을 컨트롤러 생성

  List<Map<String, dynamic>> _detailedRecords = []; // 상세 기록을 저장할 리스트

  @override
  void initState() {
    super.initState();
    // 처음에 하나의 세트를 추가합니다.
    sets.add(SetData(weight: 0, reps: 0));
  }

  void _addDetailedRecords(List<Map<String, dynamic>> records) {
    setState(() {
      _detailedRecords.addAll(records);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.exercise} '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '운동 시간',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _exerciseTimeController, // controller 할당
              decoration: const InputDecoration(
                hintText: '운동 시간을 입력하세요',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green), // 기본 상태의 테두리 색
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green), // 선택된 상태
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '운동 강도',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ExerciseIntensitySelector(
              onIntensitySelected: (intensity) {
                setState(() {
                  _selectedIntensity = intensity;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              '상세 기록', // '상세 기록' 제목 추가
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8), // '상세 기록' 제목과 버튼 사이에 간격 추가
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedRecordScreen(
                      onRecordSaved: _addDetailedRecords,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                side: const BorderSide(color: Colors.green), // 테두리 색상을 파란색으로 설정
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 버튼 모양을 동그란 형태로 설정
                ),
                elevation: 0, // 그림자를 없애기 위해 elevation을 0으로 설정
                padding: EdgeInsets.zero, // 내부 패딩을 없애기 위해 padding을 0으로 설정
              ).copyWith(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.white), // 버튼의 배경색을 하얀색으로 설정
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.black), // 텍스트 색상을 검정색으로 설정
              ),
              child: Container(
                alignment: Alignment.center, // 텍스트를 버튼 가운데 정렬
                padding: const EdgeInsets.all(12.0), // 버튼 내부 패딩 추가
                child: const Text(
                  '상세 기록',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 8), // 추가된 간격
                  if (_detailedRecords.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < _detailedRecords.length; i++) ...[
                          Text(
                            '세트${i + 1} ${_detailedRecords[i]['weight'] != null ? '${_detailedRecords[i]['weight']}kg ' : ''}${_detailedRecords[i]['type']}: ${_detailedRecords[i]['reps'] ?? ''} ${_detailedRecords[i]['weight'] != null && _detailedRecords[i]['reps'] != null ? ' ' : ''} ${_detailedRecords[i]['distance'] != null ? '${_detailedRecords[i]['distance']} km' : ''}',
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ElevatedButton(
                    onPressed: () {
                      // 기록 저장 버튼 클릭 시 처리할 내용
                      // 여기에 추가 작업 구현
                      // DatabaseManager().insertRecord(_exerciseTimeController.text); // 입력된 운동 시간을 데이터베이스에 저장

                      // '기록 저장'을 눌렀을 때 '저장 되었습니다' 문구를 보여줍니다.
                      setState(() {
                        _isSaved = true;
                      });

                      // 2초 후에 '저장 되었습니다' 문구를 숨깁니다.
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          _isSaved = false;
                        });
                      });
                    },
                    child: const Text('기록 저장'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // 배경색을 하얀색으로 설정
                      side: const BorderSide(
                          color: Colors.green), // 테두리 색상을 초록색으로 설정
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // 버튼의 모서리를 둥글게 설정
                      ),
                    ).copyWith(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.black), // 텍스트 색상을 검정색으로 설정
                    ),
                  ),
                  // '저장 되었습니다' 문구 표시
                  if (_isSaved)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '저장 되었습니다',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SetData {
  int weight;
  int reps;

  SetData({required this.weight, required this.reps});
}

class ExerciseIntensitySelector extends StatefulWidget {
  final Function(String) onIntensitySelected;

  ExerciseIntensitySelector({required this.onIntensitySelected});

  @override
  _ExerciseIntensitySelectorState createState() =>
      _ExerciseIntensitySelectorState();
}

class _ExerciseIntensitySelectorState extends State<ExerciseIntensitySelector> {
  String _selectedIntensity = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildIntensityButton('가볍게')),
        const SizedBox(width: 8),
        Expanded(child: _buildIntensityButton('적당히')),
        const SizedBox(width: 8),
        Expanded(child: _buildIntensityButton('격하게')),
      ],
    );
  }

  Widget _buildIntensityButton(String intensity) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIntensity = intensity;
        });
        widget.onIntensitySelected(intensity);
      },
      child: Text(intensity),
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedIntensity == intensity
            ? Colors.green
            : Colors.white, // 선택된 버튼의 배경색을 파란색으로 변경
        foregroundColor: _selectedIntensity == intensity
            ? Colors.white
            : Colors.black, // 선택된 버튼의 텍스트 색상을 흰색으로 변경
        side: const BorderSide(color: Colors.green), // 테두리를 파란색으로 설정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // 버튼 모양을 동그란 형태로 설정
        ),
      ),
    );
  }
}

class DetailedRecordScreen extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onRecordSaved;

  DetailedRecordScreen({required this.onRecordSaved});

  @override
  _DetailedRecordScreenState createState() => _DetailedRecordScreenState();
}

class _DetailedRecordScreenState extends State<DetailedRecordScreen> {
  String _selectedType = '횟수';
  final List<TextEditingController> _repControllers = [];
  final List<TextEditingController> _weightControllers = [];
  final List<TextEditingController> _distanceControllers = [];

  @override
  void initState() {
    super.initState();
    _addSet(); // 초기에 하나의 세트를 추가합니다.
  }

  // 새로운 세트를 추가하는 메서드
  void _addSet() {
    _repControllers.add(TextEditingController());
    _weightControllers.add(TextEditingController());
    _distanceControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    _repControllers.forEach((controller) => controller.dispose());
    _weightControllers.forEach((controller) => controller.dispose());
    _distanceControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상세 기록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: ToggleButtons(
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('횟수'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('무게'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('거리'),
                  ),
                ],
                isSelected: [
                  _selectedType == '횟수',
                  _selectedType == '무게',
                  _selectedType == '거리',
                ],
                onPressed: (int index) {
                  setState(() {
                    _selectedType = index == 0
                        ? '횟수'
                        : index == 1
                            ? '무게'
                            : '거리';
                    // 토글 버튼을 누를 때마다 해당하는 입력 필드들을 초기화합니다.
                    _resetInputFields();
                  });
                },
                color: Colors.green,
                selectedColor: Colors.green, // 선택된 버튼의 색상
                selectedBorderColor: Colors.green,
                borderColor: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            _buildInputForm(),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _addSet(); // '세트 추가하기' 버튼을 누를 때마다 새로운 세트를 추가합니다.
                  });
                },
                child: const Text('세트 추가하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    // 여기에 저장 작업 구현
                    // 상세 기록을 저장합니다.
                    widget.onRecordSaved(_collectRecords());
                    // 이전 화면으로 돌아갑니다.
                    Navigator.pop(context);
                  },
                  child: const Text('입력 하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 입력 필드 초기화 메서드
  void _resetInputFields() {
    for (var controller in _repControllers) {
      controller.clear();
    }
    for (var controller in _weightControllers) {
      controller.clear();
    }
    for (var controller in _distanceControllers) {
      controller.clear();
    }
  }

  // 입력된 기록을 수집하는 메서드
  List<Map<String, dynamic>> _collectRecords() {
    List<Map<String, dynamic>> records = [];
    for (int i = 0; i < _repControllers.length; i++) {
      Map<String, dynamic> record = {};
      if (_selectedType == '횟수') {
        record['type'] = '횟수';
        record['reps'] = int.tryParse(_repControllers[i].text) ?? 0;
      } else if (_selectedType == '무게') {
        record['type'] = '무게';
        record['weight'] = int.tryParse(_weightControllers[i].text) ?? 0;
        record['reps'] = int.tryParse(_repControllers[i].text) ?? 0;
      } else if (_selectedType == '거리') {
        record['type'] = '거리';
        record['distance'] =
            double.tryParse(_distanceControllers[i].text) ?? 0.0;
      }
      records.add(record);
    }
    return records;
  }

  // 입력 폼을 구성하는 메서드
  Widget _buildInputForm() {
    List<Widget> formFields = [];
    for (int i = 0; i < _repControllers.length; i++) {
      formFields.add(Row(
        children: [
          Text('세트 ${i + 1}'),
          const SizedBox(width: 16),
          if (_selectedType == '횟수')
            Expanded(
              child: TextFormField(
                controller: _repControllers[i],
                decoration: const InputDecoration(
                  labelText: '횟수',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          if (_selectedType == '무게') ...[
            Expanded(
              child: TextFormField(
                controller: _weightControllers[i],
                decoration: const InputDecoration(
                  labelText: 'kg',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _repControllers[i],
                decoration: const InputDecoration(
                  labelText: '횟수',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
          if (_selectedType == '거리')
            Expanded(
              child: TextFormField(
                controller: _distanceControllers[i],
                decoration: const InputDecoration(
                  labelText: 'km',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
        ],
      ));
      formFields.add(const SizedBox(height: 16));
    }
    return Column(children: formFields);
  }
}
