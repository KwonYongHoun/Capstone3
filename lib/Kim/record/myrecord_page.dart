// 운동 기록 추가하기 버튼과 달력의 날짜를 눌렀을 때 나오는 창
import 'package:flutter/material.dart';

class MyRecodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 운동 기록'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '오늘의 운동 시간',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          const Text(
            '00:00', // 여기에 실제 운동 시간 데이터를 표시하도록 변경해야 합니다.
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          const Text(
            '운동 부위',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                8,
                (index) => GestureDetector(
                  onTap: () {
                    // 운동 부위 카테고리를 눌렀을 때의 동작 작성
                    // 해당 카테고리에 해당하는 운동 종류를 표시하거나, 다음 단계로 넘어가는 등의 동작을 수행합니다.
                  },
                  child: Card(
                    elevation: 3,
                    child: Center(
                      child: Text(
                        '운동 부위 ${index + 1}',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: '운동 시간 입력', // 입력 필드 위에 표시될 라벨
                border: OutlineInputBorder(), // 입력 필드 주변의 경계선 스타일
              ),
              keyboardType: TextInputType.number, // 숫자만 입력 가능하도록 키보드를 설정
              textAlign: TextAlign.center, // 입력된 텍스트를 가운데 정렬
            ),
          ),
        ],
      ),
    );
  }
}

// 운동 시간 받아서 저장하는 데이터 필요함

