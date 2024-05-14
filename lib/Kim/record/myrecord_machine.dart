import 'package:flutter/material.dart';
import 'package:health/Kim/record/myrecord_machinerecord.dart';

class MyRecordMachinePage extends StatelessWidget {
  final String exercise;

  MyRecordMachinePage({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$exercise 운동'), // 페이지 상단에 선택한 운동 이름을 표시
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3, // 버튼의 너비 대 높이 비율 조정
          crossAxisSpacing: 8, // 버튼 사이의 수평 간격
          mainAxisSpacing: 8, // 버튼 사이의 수직 간격
          padding: const EdgeInsets.all(16),
          children: _buildMachineButtons(
              context, exercise), // 선택한 운동에 따라 기구 버튼들을 생성하여 반환
        ),
      ),
    );
  }

  // 선택한 운동에 따라 해당하는 기구 버튼들을 생성하여 반환하는 함수
  List<Widget> _buildMachineButtons(BuildContext context, String exercise) {
    List<String> machines = [];

    // 선택한 운동에 따라 해당하는 기구들의 목록을 설정
    switch (exercise) {
      case '가슴':
        machines = [
          '벤치 프레스',
          '딥스',
          '인클라인 벤치프레스',
          '디클라인 벤치프레스',
          '어시스트 딥스 머신',
          '시티드 체스트 프레스',
          '푸시업',
          '체스트 프레스 머신',
          '숄더 프레스 머신'
        ];
        break;
      case '어깨':
        machines = ['숄더 프레스', '레터럴 레이즈', '페이스 풀', '숄더 쉬러그'];
        break;
      case '하체':
        machines = [
          '레그 익스텐션',
          '레그 컬',
          '힙 어브덕션 머신',
          '브이 스쿼트',
          '덩키 킥',
          '힙 쓰러스트',
          '글루트 브릿지',
          '라잉 힙 어브덕션'
        ];
        break;
      case '팔':
        machines = ['덤벨 컬', '바벨 컬', '이지바 컬', '덤벨 해머 컬', '벤치 딥스'];
        break;
      case '등':
        machines = ['랫풀다운', '시티드 케이블 로우', '씨티드 로우', '랫풀다운', '랫풀다운(머신)'];
        break;
      case '복근':
        machines = [
          '복근 크런치 머신',
          '디클라인 크런치',
          '러시안 트위스트',
          '싯업',
          '브이업',
          '크런치',
          '레그 레이즈',
          '플랭크',
          '디클라인 크런치',
          '사이드 플랭크'
        ];
        break;
      case '유산소':
        machines = [
          '싸이클',
          '스텝밀',
          '계단 오르기',
          '달리기',
          '하이니 스킵',
          '트레드밀',
          '이단 뛰기',
          '줄넘기',
          '걷기',
        ];
        break;
      case '기타':
        machines = [
          '버피',
          '점핑 잭',
          '마운틴 클라이머',
          '쓰리스터',
          '인치웜',
          '케틀벨 스윙',
          '터키쉬 겟업',
          '파머스 워크',
          '덤벨 버피',
          '덤벨 쓰러스터'
        ];
      default:
        break;
    }

    // 각 기구에 대한 버튼 위젯들을 생성하여 리스트로 반환
    return machines
        .map((machine) => _buildMachineButton(context, machine))
        .toList();
  }

  // 각 운동 기구 버튼을 생성하는 함수
  Widget _buildMachineButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {
        // 운동 기구 버튼을 눌렀을 때 처리할 작업 작성
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MyRecordMachineRecord(
                  exercise: text)), // 해당 기구에 대한 기록 페이지로 이동
        );
      },
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(Colors.white), // 버튼의 배경색을 하얀색으로 설정
        elevation: MaterialStateProperty.all<double>(0), // 그림자 효과 제거
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 버튼의 모서리를 둥글게 설정
            side: const BorderSide(color: Colors.grey), // 버튼의 테두리를 회색으로 설정
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black), // 버튼에 표시될 기구 이름
      ),
    );
  }
}
