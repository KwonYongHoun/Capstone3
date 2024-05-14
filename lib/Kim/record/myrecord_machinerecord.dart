import 'package:flutter/material.dart';

class MyRecordMachineRecord extends StatefulWidget {
  final String exercise;

  MyRecordMachineRecord({required this.exercise});

  @override
  _MyRecordMachineRecordState createState() => _MyRecordMachineRecordState();
}

class _MyRecordMachineRecordState extends State<MyRecordMachineRecord> {
  List<SetData> sets = [];
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    // 처음에 하나의 세트를 추가합니다.
    sets.add(SetData(weight: 0, reps: 0));
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
              decoration: const InputDecoration(
                hintText: '운동 시간을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '상세 기록',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sets.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        '세트 ${index + 1}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'kg',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: '횟수',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'km',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 세트 추가 버튼 클릭 시
                      setState(() {
                        sets.add(SetData(weight: 0, reps: 0));
                      });
                    },
                    child: const Text('세트 추가하기'),
                  ),
                  const SizedBox(height: 8), // 추가된 간격
                  ElevatedButton(
                    onPressed: () {
                      // 추가하기 버튼 클릭 시
                      // 여기에 추가 작업 구현

                      // '기록 저장'을 눌렀을 때 '저장 되었습니다' 문구를 보여줍니다.
                      setState(() {
                        _isSaved = true;
                      });

                      // 2초 후에 '저장 되었습니다' 문구를 숨깁니다.
                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          _isSaved = false;
                        });
                      });
                    },
                    child: const Text('기록 저장'),
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
