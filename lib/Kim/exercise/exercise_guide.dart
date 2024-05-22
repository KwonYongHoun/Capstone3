import 'package:flutter/material.dart';
import 'package:health/Kim/exercise/exercise_explain.dart';
import 'package:url_launcher/url_launcher.dart';

class ExerciseGuidePage extends StatelessWidget {
  const ExerciseGuidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 기구 사용 방법'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '운동 부위 선택',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              children: List.generate(
                bodyParts.length,
                (index) => ExercisePartButton(bodyPart: bodyParts[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExercisePartButton extends StatelessWidget {
  final String bodyPart;

  const ExercisePartButton({Key? key, required this.bodyPart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ExerciseDetailPage(bodyPart: bodyPart)),
          );
        },
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.white), // 배경색을 하얀색으로 설정
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.green), // 테두리를 초록으로 설정
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0)),
        ),
        child: Text(
          bodyPart,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold, // 굵은체로 변경
            color: Colors.black, // 흰색으로 변경
          ),
        ),
      ),
    );
  }
}

class ExerciseDetailPage extends StatelessWidget {
  final String bodyPart;

  const ExerciseDetailPage({Key? key, required this.bodyPart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$bodyPart 운동'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(
            (exerciseEquipment[bodyPart] ?? []).length,
            (index) => ExerciseEquipmentCard(
              equipment: (exerciseEquipment[bodyPart] ?? [])[index],
            ),
          ),
        ),
      ),
    );
  }
}

class ExerciseEquipmentCard extends StatelessWidget {
  final ExerciseEquipment equipment;

  const ExerciseEquipmentCard({Key? key, required this.equipment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _openExerciseExplainPage(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExerciseExplainPage(
            exerciseName: equipment.name,
            description: equipment.description,
            imageUrl: equipment.imageUrl,
            url: equipment.url,
          ),
        ),
      );
    }

    return Container(
      // 컨테이너 추가
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        // 테두리 스타일 지정
        color: Colors.white, // 배경색을 하얀색으로 설정
        border: Border.all(color: Colors.green), // 테두리를 회색으로 설정
        borderRadius: BorderRadius.circular(10.0), // 테두리를 둥글게 만듦
      ),
      child: ListTile(
        leading: Image.asset(equipment.imageUrl),
        title: Text(equipment.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _openExerciseExplainPage(context),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseEquipment {
  final String name;
  final String description;
  final String imageUrl;
  final String url;

  ExerciseEquipment({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.url,
  });
}

final List<String> bodyParts = [
  '가슴',
  '어깨',
  '하체',
  '팔',
  '등',
  '복근',
  '유산소',
  '기타',
];

final Map<String, List<ExerciseEquipment>> exerciseEquipment = {
  '가슴': [
    ExerciseEquipment(
      name: '벤치프레스',
      description: '1. 벤치에 가슴을 펴고 누운 상태에서, 바벨을 어깨너비보다 조금 넓게 잡고 위로 들어올립니다.\n\n'
          '2. 가슴 근육의 이완을 느끼며 팔을 굽혀 바벨을 가슴 방향으로 내립니다.\n\n'
          '3. 가슴 근육의 수축을 느끼며 몸의 수직방향으로 바벨을 밀어올립니다.\n\n',
      imageUrl: 'assets/benchpress.png',
      url:
          'https://www.youtube.com/results?search_query=%EB%B2%A4%EC%B9%98%ED%94%84%EB%A0%88%EC%8A%A4',
    ),
    ExerciseEquipment(
      name: '딥스',
      description: '1. 딥스바의 폭을 어깨보다 살짝 넓게 셋팅한 상태에서, 손몰이 꺾이지 않게 딥스바에 올라갑니다.\n\n'
          '2. 상체는 살짝 앞으로 기울인상채로 팔꿈치가 90도가 될때까지 팔을 굽혀 몸을 내립니다.\n\n'
          '3. 상체의 균형을 유지한채로 팔을 피면서 올라옵니다.\n\n',
      imageUrl: 'assets/dips.jpg',
      url: 'https://www.youtube.com/results?search_query=%EB%94%A5%EC%8A%A4',
    ),
    ExerciseEquipment(
      name: '인클라인 벤치프레스',
      description:
          '1. 기울어진 벤치에 가슴을 펴고 누운 상태에서, 바벨을 어깬비보다 조금 넓게 잡고 위로 들어올립니다.\n\n'
          '2. 가슴 근육의 이완을 느끼며 팔을 굽혀 바벨을 가슴 방향으로 내립니다.\n\n'
          '3. 가슴 근육의 수축을 느끼며 바닥의 수직방향으로 바벨을 밀어올립니다.\n\n',
      imageUrl: 'assets/dips.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%9D%B8%ED%81%B4%EB%9D%BC%EC%9D%B8+%EB%B2%A4%EC%B9%98%ED%94%84%EB%A0%88%EC%8A%A4',
    ),
    ExerciseEquipment(
      name: '디클라인 벤치프레스',
      description:
          '1. 기울어진 벤치에 가슴을 펴고 누운 상태에서, 바벨을 어깨 너비보다 조금 넓게 잡아 지면의 수직방향으로 들어올립니다.\n\n'
          '2. 가슴 근육의 이완을 느끼며 팔을 굽혀 바벨을 아랫 가슴 방향으로 내립니다.\n\n'
          '3. 가슴 근육의 수축을 느끼며 바닥의 수직방향으로 바벨을 밀어올립니다.\n\n',
      imageUrl: 'assets/dips.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%94%94%ED%81%B4%EB%9D%BC%EC%9D%B8+%EB%B2%A4%EC%B9%98%ED%94%84%EB%A0%88%EC%8A%A4',
    ),
    ExerciseEquipment(
      name: '어시스트 딥스 머신',
      description: '1. 보조 받고 시싶은 중량을 설정합니다. 중량이 클수록 더 많이 보조를 받게됩니다.\n\n'
          '2. 손목이 꺾이지 않게 딥스 바에 올라가면서, 받침대에 양무릎을 올려 체중을 실어줍니다.\n\n'
          '3. 상체를 살짝 앞으로 기운 상태로 팔꿈치가 90도가 될때까지 팔을 굽혀 몸을 내립니다.\n\n'
          '4. 상체의 균형을 유지한채로 팔을 피면서 올라옵니다.\n\n',
      imageUrl: 'assets/dips.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%96%B4%EC%8B%9C%EC%8A%A4%ED%8A%B8+%EB%94%A5%EC%8A%A4+%EB%A8%B8%EC%8B%A0',
    ),
    ExerciseEquipment(
      name: '시티드 체스트 프레스',
      description: '1. 가슴을 활짝 편 상태로, 의자에 윗 등을 붙이고 앉습니다.\n\n'
          '2. 양손으로 손잡이를 잡고, 가슴에 힘을 주면서 앞으로 밀어줍니다.(이때, 손잡이가 가슴 중앙에 위치할 수 있도록 벤치 높이를 조절합니다.)\n\n'
          '3. 가슴 근육의 이완을 느끼면서 팔꿈치를 뒤로 천천히 이동합니다.(이때, 손목과 팔꿈치가 일직선이 되도록 합니다.)\n\n',
      imageUrl: 'assets/dips.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%8B%9C%ED%8B%B0%EB%93%9C+%EC%B2%B4%EC%8A%A4%ED%8A%B8+%ED%94%84%EB%A0%88%EC%8A%A4',
    ),
    ExerciseEquipment(
        name: '푸시업',
        description: '1. 양팔을 가슴 옆에 두고 바닥에 엎드립니다.\n\n'
            '2. 복근과 둔근에 힘을 준 상태로 팔꿈치를 피며 올라옵니다.\n\n'
            '3. 천천히 팔꿈치를 굽히며 시작 자세로 돌아갑니다.\n\n',
        imageUrl: 'assets/dips.jpg',
        url:
            'https://www.youtube.com/results?search_query=%ED%91%B8%EC%8B%9C%EC%97%85'),
    ExerciseEquipment(
        name: '힌두 푸시업',
        description: '1. 일반적인 푸시업 자세에서, 양발은 살짝 넓게 벌리고 엉덩이를 위로 올려줍니다.\n\n'
            '2. 팔을 굽히면서 상체를 앞방향으로 밀어줍니다. 턱, 가슴, 복부 순으로 지면과 가까워지도록 움직입니다.\n\n'
            '3. 복근과 둔근의 긴장상태를 유지하며 상체를 일으켜 세웁니다.\n\n'
            '4. 팔을 뒤로 밀며 1번의 자세로 돌아갑니다.\n\n',
        imageUrl: 'assets/dips.jpg',
        url:
            'https://www.youtube.com/results?search_query=%ED%9E%8C%EB%91%90+%ED%91%B8%EC%8B%9C%EC%97%85'),
    ExerciseEquipment(
        name: '클랩 푸시업',
        description: '1. 양팔을 가슴 옆에 두고 바닥에 엎드립니다.\n\n'
            '2. 복근과 둔근에 힘을 준 상태로 팔꿈치를 힘차게 피며 올라옵니다.\n\n'
            '3. 양손이 바닥에서 떨어질만큼 상체를 밀어올린 상태에서 박수를 칩니다.\n\n'
            '4. 양팔로 중량을 유지하면서 시작 자세로 돌아갑니다.\n\n',
        imageUrl: 'assets/dips.jpg',
        url:
            'https://www.youtube.com/results?search_query=%ED%81%B4%EB%9E%A9+%ED%91%B8%EC%8B%9C%EC%97%85'),
    ExerciseEquipment(
        name: '덤벨 스퀴즈 프레스',
        description: '1. 벤치에 누운 상태에서 양손등이 바깥쪽을 향하도록 덤벨을 세로로 잡습니다.\n\n'
            '2. 가슴의 자극을 느끼면서 수직방향으로 덤벨을 밀어올립니다.\n\n'
            '3. 코로 호흡하면서 덤벨을 천천히내려 시작자세로 돌아갑니다.\n\n',
        imageUrl: 'assets/dips.jpg',
        url:
            'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EC%8A%A4%ED%80%B4%EC%A6%88+%ED%94%84%EB%A0%88%EC%8A%A4'),
  ],
  '어깨': [
    ExerciseEquipment(
      name: '체스트 프레스 머신',
      description: '1. 가슴을 활짝 편 상태로, 의자에 윗 등을 붙이고 앉습니다.\n\n'
          '2. 양손으로 손잡이를 잡고, 가슴에 힘을 주면서 앞으로 밀어줍니다. (이때, 손잡이가 가슴 중앙에 위치할 수 있도록 베니 높이를 조절합니다.)\n\n'
          '3. 가슴 근육의 이완을 느끼면서 팔꿈치를 뒤로 천천히 이동합니다. (이때, 손목과 팔꿈치가 일직선이 되도록 합니다.).\n\n',
      imageUrl: 'assets/chest_press.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%B2%B4%EC%8A%A4%ED%8A%B8+%ED%94%84%EB%A0%88%EC%8A%A4+%EB%A8%B8%EC%8B%A0',
    ),
    ExerciseEquipment(
      name: '숄더 프레스 머신',
      description: '1. 머신에 앉아 팔꿈치 각도가 90도가 되도록 팔의 넓이를 조절하여 손잡이를 잡습니다.\n\n'
          '2. 어깨에 자극을 느끼면서 수직방향으로 팔을 밀어 올립니다.\n\n'
          '3. 어깨의 자극을 느끼며 손을 귀 옆까지 천천히 내립니다.\n\n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%88%84%EB%8D%94+%ED%94%84%EB%A0%88%EC%8A%A4+%EB%A8%B8%EC%8B%A0',
    ),
    ExerciseEquipment(
      name: '오버헤드 프레스',
      description: '1. 바벨을 어깨너비로 잡고 쇄골 위에 올려둡니다.\n\n'
          '2. 등에 힘을 주고 가슴을 피면서 바벨을 위로 밀어올립니다.\n\n'
          '3. 바벨이 올라간 동선을 따라 천천히내려 시작 자세로 돌아옵니다.\n\n',
      imageUrl: 'assets/chest_press.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%98%A4%EB%B2%84%ED%97%A4%EB%93%9C+%ED%94%84%EB%A0%88%EC%8A%A4',
    ),
    ExerciseEquipment(
      name: '덤벨 숄더 프레스',
      description: '1. 양손에 덤벨을 잡고 팔을 옆으로 벌려서, 덤벨을 머리와 나란히 위치시킵니다.\n\n'
          '2. 어깨를 아래방향으로 지그시 누르면서 덤벨을 수직 방향으로 밀어올립니다.\n\n'
          '3. 어깨의 자극을 느끼면서, 덤벨을 내려 시작 자세로 돌아롭니다.(이때 팔꿈치가 너무 아래로 내려가지 않도록 유의합니다.)\n\n',
      imageUrl: 'assets/chest_press.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EC%88%84%EB%8D%94+%ED%94%84%EB%A0%88%EC%8A%A4',
    ),
    ExerciseEquipment(
      name: '덤벨 프론트 프레스',
      description: '1. 양발을 어깨너비로 적당히 벌리고, 양손에 덤벨을 쥐고 섭니다.\n\n'
          '2. 상체의 균형을 유지하며서 한쪽 팔을 앞으로 들어올립니다.\n\n'
          '3. 들어올린 팔을 내리고 난 뒤 2번의 상태로 돌아옵니다. 이후 반대편 팔로 운동을 수행합니다.\n\n',
      imageUrl: 'assets/chest_press.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%ED%94%84%EB%A1%A0%ED%8A%B8+%EB%A0%88%EC%9D%B4%EC%A6%88',
    ),
    ExerciseEquipment(
      name: '덤벨 레터럴 프레스',
      description: '1. 양발을 어깨너비로 적당히 벌리고, 양손에 덤벨을 쥐고 섭니다.\n\n'
          '2. 측면 어깨(삼각근)에 자극을 느끼면서 팔꿈치를 올린다는 생각으로 덤벨을 들어 올립니다.\n\n'
          '3. 측면 삼각근의 자극을 느끼면서 천천히 팔을 내립니다.\n\n',
      imageUrl: 'assets/chest_press.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EB%A0%88%ED%84%B0%EB%9F%B4+%EB%A0%88%EC%9D%B4%EC%A6%88',
    ),
    ExerciseEquipment(
      name: '핸드스탠드',
      description: '1. 양 팔을 쭉펴고 물구나무를 섭니다.\n\n'
          '2. 자세를 유지하기 어렵다면, 벽이나 구조물에 몸을 기대 균형감각을 익히는데 집중합니다.\n\n',
      imageUrl: 'assets/chest_press.jpg',
      url:
          'https://www.youtube.com/results?search_query=%ED%95%B8%EB%93%9C%EC%8A%A4%ED%83%A0%EB%93%9C',
    ),
    ExerciseEquipment(
      name: '숄더 탭',
      description: '1. 양팔을 어깨 너비만큼 벌리고 팔꿈치를 쭉펴서 바닥에 엎드립니다.\n\n'
          '2. 한쪽 손으로 반대쪽 어깨를 가볍게 터치합니다.(이때, 몸통이 크게 움직이지 않도록 최대한 자세를 유지할 수 있도록 합니다.)\n\n'
          '3. 터치한 손을 원위치 시킨 뒤 반대쪽 손으로 동일하게 운동을 수행합니다.\n\n',
      imageUrl: 'assets/chest_press.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%88%84%EB%8D%94+%ED%83%AD',
    ),
    ExerciseEquipment(
      name: '플레이트 숄더 프레스',
      description: '1. 플레이트를 양손으로 잡고 가슴 앞에 위치시킵니다.\n\n'
          '2. 어깨가 굽지 않도록 가슴ㅇ르 핀 상태로 플레이트를 머리 위 수직방향으로 밀어올립니다.\n\n'
          '3. 플레이트가 올라간 동선을 따라 천천히 내려옵니다.\n\n',
      imageUrl: 'assets/chest_press.jpg',
      url:
          'https://www.youtube.com/results?search_query=%ED%94%8C%EB%A0%88%EC%9D%B4%ED%8A%B8+%EC%88%84%EB%8D%94+%ED%94%84%EB%A0%88%EC%8A%A4',
    ),
    ExerciseEquipment(
      name: 'Y 레이즈',
      description:
          '1. 타겟 부위의 효과적인 자극을 위해 가슴을 지지할 수 있도록, 바닥에 엎드리거나 벤치에 가슴을 기댑니다.\n\n'
          '2. 양팔을 Y자 모양으로 만든 상태에서, 양팔을 최대한 위로 올립니다.\n\n'
          '3. 등의 긴장이 완전히 풀리기 전까지 천천히 양팔을 내려줍니다.\n\n',
      imageUrl: 'assets/chest_press.jpg',
      url:
          'https://www.youtube.com/results?search_query=Y+%EB%A0%88%EC%9D%B4%EC%A6%88',
    ),
  ],
  '하체': [
    ExerciseEquipment(
      name: '레그 익스텐션',
      description:
          '1. 의자는 무릎 바로 아래에 올 수 있게, 패드는 발목 살짝 위에 위치할 수 있도록 머신을 조정합니다.\n\n'
          '2. 엉덩이가 떨어지지 않게 유지하면서, 허벅지의 힘으로 고정부위를 지그시 밀어올립니다.\n\n'
          '3. 근육의 긴장을 유지하면서 천천히 무릎을 굽혀줍니다.\n\n',
      imageUrl: 'assets/leg_extension.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%A0%88%EA%B7%B8+%EC%9D%B5%EC%8A%A4%ED%85%90%EC%85%98',
    ),
    ExerciseEquipment(
      name: '레그 컬',
      description:
          '1. 머신에 엎드린 상태에서, 종아리 쪽의 패드가 아킬레스건 바로 위쪽에 위치하도록 머신을 조정합니다.\n\n'
          '2. 발목을 세운 상태에서, 무릎을 굽혀 기구를 올려줍니다.\n\n'
          '3. 허리, 엉덩이, 햄스트링에 긴장감을 유지하면서 기구를 천천히 내립니다.\n\n',
      imageUrl: 'assets/leg_curl.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%A0%88%EA%B7%B8+%EC%BB%AC',
    ),
    ExerciseEquipment(
      name: '레그 프레스',
      description: '1. 엉덩이와 허리가 의자에 완전히 붙도록 밀착하여 앉고, 두 발을 어깨 너비만큼 벌려줍니다.\n\n'
          '2. 이때, 좁게 벌리면 허벅지 바깥쪽, 널베 벌리면 안쪽으로 더 큰 자극을 줄 수 있습니다.\n\n'
          '3. 안전핀을 제거하고, 중량의 자극을 느끼며 무릎을 굽혀줍니다. 엉덩이와 허리가 뜨지 않을 깊이까지 중량판을 내립니다.\n\n'
          '4. 복부에 힘을 유지한채로, 중량판을 지그시 밀어 올립니다.\n\n',
      imageUrl: 'assets/leg_curl.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%A0%88%EA%B7%B8+%ED%94%84%EB%A0%88%EC%8A%A4',
    ),
    ExerciseEquipment(
      name: '힙 어브덕션 머신',
      description: '1. 의자에 앉아 무릎 바깥쪽에 패드를 밀착한 상태로 상체를 머신쪽으로 살짝 숙여줍니다.\n\n'
          '2. 상,하체가 움직이지 않게 고정된 상태에서 엉덩이 바깥쪽 근육의 힘을 사용하여 양쪽 허벅지를 천천히 옆으로 벌려줍니다.\n\n'
          '3. 바깥쪽 엉덩이에 자극을 느끼며 천천히 처음의 자세로 돌아옵니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%ED%9E%99+%EC%96%B4%EB%B8%8C%EB%8D%95%EC%85%98+%EB%A8%B8%EC%8B%A0',
    ),
    ExerciseEquipment(
      name: '브이 스쿼트',
      description: '1. 머신에 허리를 붙인 상태에서 기본 스쿼트 보폭으로 곧게 섭니다.\n\n'
          '2. 허리가 굽지 않도록 배에 힘을 준 상태로 다리가 기역(ㄱ)자 모양이 될때까지 내려갑니다.\n\n'
          '3. 대퇴사두(허벅지)와 힙의 자극을 느끼면서, 양발바닥을 지그시 누르며 올라옵니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%B8%8C%EC%9D%B4+%EC%8A%A4%EC%BF%BC%ED%8A%B8',
    ),
    ExerciseEquipment(
      name: '런지 트위스트',
      description: '1. 양발을 골반 넓이만큼 벌리고 상체를 곧게 펴고 섭니다.\n\n'
          '2. 한쪽 다리를 뻗어 앞으로 나가면서 두 무릎에 90도 각도를 이룰 때까지 엉덩이를 낮춰줍니다.\n\n'
          '3. 엉덩이를 낮춤과 동시에 상체를 무릎이 나온 방향으로 트위스트 해줍니다.\n\n'
          '4. 앞발의 뒤꿈치에 무게 중심을 실어서 몸을 위쪽으로 밀어주며 워낼 시작 자세로 돌아옵니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%9F%B0%EC%A7%80+%ED%8A%B8%EC%9C%84%EC%8A%A4%ED%8A%B8',
    ),
    ExerciseEquipment(
      name: '덩키 킥',
      description: '1. 바닥에 손바닥과 무릎을 대고 엎드립니다.\n\n'
          '2. 신체가 흔들리지 않도록 몸을 고정시킨 상태에서, 한쪽 다리의 무릎을 90도로 유지하면서 위로 힘차게 킥합니다.\n\n'
          '3. 둔근의 자극을 느끼면서 천천히 시작 자세로 돌아옵니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A9%ED%82%A4+%ED%82%A5',
    ),
    ExerciseEquipment(
      name: '힙 쓰러스트',
      description: '1. 등 상부를 벤치에 기댄 상태에서 발바닥을 지면에 단단히 고정합니다.\n\n'
          '2. 엉덩이 힘으로 몸을 윗 방향으로 밀어 올립니다.(이때, 허리가 과하게 꺾이지 않도록 주의합니다.)\n\n'
          '3. 천천히 엉덩이르 내려 수축된 엉덩이 근육을 이완시킵니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%ED%9E%99+%EC%93%B0%EB%9F%AC%EC%8A%A4%ED%8A%B8',
    ),
    ExerciseEquipment(
      name: '글루트 브릿지',
      description: '1. 바닥에 누워 무릎을 구부린 상태에서, 양 발바닥면 전체가 바닥에 닿게합니다.\n\n'
          '2. 무릎, 엉덩이, 어깨가 일직선이 될때까지 바닥에서 엉덩이를 들어 올립니다. 이때, 등이 과도하게 밀려 올라가는 것을 방지하기 위해 둔근과 복근을 활성화합니다.\n\n'
          '3. 최고점에서 약 2초간 자세를 유지하고 시작자세로 돌아옵니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EA%B8%80%EB%A3%A8%ED%8A%B8+%EB%B8%8C%EB%A6%BF%EC%A7%80',
    ),
    ExerciseEquipment(
      name: '라잉 힙 어브덕션',
      description: '1. 옆으로 곧게 누워 한팔은 머리를 다른 한팔은 상체를 지지합니다.\n\n'
          '2. 몸의 중심을 잡은 상태에서 위쪽 다리를 상체와 일직선이 되도록 몸을 정렬합니다.\n\n'
          '3. 아래쪽 다리는 바닥을 지지한 상태로 위쪽 다리를 천천히 들어올립니다.\n\n'
          '4. 올린 다리를 천천히내려 2번의 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%9D%BC%EC%9E%89+%ED%9E%99+%EC%96%B4%EB%B8%8C%EB%8D%95%EC%85%98',
    ),
  ],
  '팔': [
    ExerciseEquipment(
      name: '덤벨 컬',
      description:
          '1. 양발을 어깨너비로 적당히 벌리고 양손에 덤벨을 잡습니다.(이때, 어깨는 내리고 팔꿈치를 옆구리에 밀착하듯 붙여줍니다.)\n\n'
          '2. 이두근으로만 덤벨을 들어올린다는 생각으로 팔을 구부립니다.(이때, 팔꿈치가 움직이지 않도록 고정된 상태를 유지합니다.)\n\n'
          '3. 구부린 팔을 펴면서 시작 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/Hip_Thrust.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EC%BB%AC',
    ),
    ExerciseEquipment(
      name: '바벨 컬',
      description: '1. 양발을 어깨너비로 적당히 벌려 서고, 바벨을 어깨보다 살짝 넓게 잡고 섭니다.\n\n'
          '2. 팔꿈치를 고정한 상태에서, 이두의 힘으로 바벨을 들어올립니다.\n\n'
          '3. 이두의 긴장감을 유지하면서 바벨을 천천히 내립니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%B0%94%EB%B2%A8+%EC%BB%AC',
    ),
    ExerciseEquipment(
      name: '이지바 컬',
      description: '1. 양발을 어깨너비로 적당히 벌려 서고, 이지바를 어깨너비만큼 잡고 섭니다.\n\n'
          '2. 팔꿈치를 고정한 상태에서, 이두의 힘으로 바를 들어올립니다.\n\n'
          '3. 이두의 긴장감을 유지하면서 바를 천천히 내립니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%9D%B4%EC%A7%80%EB%B0%94+%EC%BB%AC',
    ),
    ExerciseEquipment(
      name: '덤벨 해머 컬',
      description: '1. 양 손바닥이 마주보게 덤벨을 잡고, 몸을 곧게 펴고 섭니다.\n\n'
          '2. 팔꿈치를 고정한 상태로, 덤벨을 최대한 들어 올립니다.\n\n'
          '3. 천천히 덤벨을 내려 시작 자세로 돌아옵니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%ED%95%B4%EB%A8%B8+%EC%BB%AC',
    ),
    ExerciseEquipment(
      name: '벤치 딥스',
      description:
          '1. 양손을 어깨너비만큼 벌려 벤치 모서리를 잡아줍니다.(어깨의 유연성이 부족하다고 생각된다면 어깨너비 보다 넓게 벌려 잡습니다.).\n\n'
          '2. 발의 위치에 따라 강도가 조절되므로 적당한 위치를 설정합니다.(몸에서 멀어질수록 강도가 올라가고 가까워질수록 강도가 약해집니다.)\n\n'
          '3. 팔을 굽혀서 몸을 수직방향으로 내립니다. 이때, 양 팔꿈치를 뒤쪽 직각방향으로 움직일수 있도록 합니다.\n\n'
          '4. 삼두근의 자극을 느끼며 몸을 밀어올려 시작자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%B2%A4%EC%B9%98+%EB%94%A5%EC%8A%A4',
    ),
    ExerciseEquipment(
      name: '덤벨 리스트 컬',
      description: '1. 벤치에 팔을 댄 상태로, 덤벨을 언더 그립(손바닥을 위로 향하게 잡는 방법)으로 잡습니다.\n\n'
          '2. 손목을 아래쪽으로 젖혀주면서 손가락을 살짝 풀어줍니다.\n\n'
          '3. 손가락과 손목을 최대한 높이 말아올리면서 전완근을 수축시켜줍니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EB%A6%AC%EC%8A%A4%ED%8A%B8+%EC%BB%AC',
    ),
    ExerciseEquipment(
      name: '이지바 리스트 컬',
      description: '1. 벤치에 양손을 올린 뒤, 이지바를 언더 그립(손바닥을 위로 향하게 잡는 방법)으로 잡습니다.\n\n'
          '2. 손목을 아래쪽으로 젖혀주면서 손가락을 살짝 풀어줍니다.\n\n'
          '3. 손가락과 손목을 최대한 높이 말아올리면서 전완근을 수축시켜줍니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%9D%B4%EC%A7%80%EB%B0%94+%EB%A6%AC%EC%8A%A4%ED%8A%B8+%EC%BB%AC',
    ),
    ExerciseEquipment(
      name: '바벨 리스트 컬',
      description: '1. 벤치에 양손을 올린 뒤, 바벨를 언더 그립(손바닥을 위로 향하게 잡는 방법)으로 잡습니다.\n\n'
          '2. 손목을 아래쪽으로 젖혀주면서 손가락을 살짝 풀어줍니다.\n\n'
          '3. 손가락과 손목을 최대한 높이 말아올리면서 전완근을 수축시켜줍니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%B0%94%EB%B2%A8+%EB%A6%AC%EC%8A%A4%ED%8A%B8+%EC%BB%AC',
    ),
    ExerciseEquipment(
      name: '덤벨 킥백',
      description: '1. 덤벨을 쥔 팔의 상완근 부위(삼두)가 바닥과 평행하도록 자세를 잡습니다.\n\n'
          '2. 팔꿈치를 고정한 상태로 덤벨을 다리쪽으로 멀리 보낸다는 생각으로 들어올립니다.\n\n'
          '3. 삼두근을 일정기간 수축한뒤, 덤벨을 내리며 시작 자세로 돌아옵니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%ED%82%A5%EB%B0%B1',
    ),
    ExerciseEquipment(
      name: '덤벨 트라이셉 익스텐션',
      description: '1. 양발을 골반너비로 적당히 벌리고, 덤벨을 양손으로 잡고 섭니다. \n\n'
          '2. 덤벨을 잡은 양팔의 팔꿈치를 직각으로 만들면서 머리 뒤로 넘깁니다.\n\n'
          '3. 팔꿈치를 고정한 상태로 덤벨을 위로 들어올립니다.\n\n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%ED%8A%B8%EB%9D%BC%EC%9D%B4%EC%85%89+%EC%9D%B5%EC%8A%A4%ED%85%90%EC%85%98',
    ),
  ],
  '등': [
    ExerciseEquipment(
      name: '랫풀다운',
      description: '1. 허벅지 지지대의 높낮이를 알맞게 조절하고, 바를 어깨너비보다 넓게 잡고 의자에 앉습니다./n/n'
          '2. 허벅지를 지지대에 고정하고 가슴을 편상태로, 바가 쇄골에 닿을정도로 바를 당겨줍니다. (이때, 팔이 아닌 등(광배근)의 힘으로 바를 당겨줍니다.)/n/n'
          '3. 광배근이 이완하는 것을 느끼면서 천천히 팔을 폅니다./n/n',
      imageUrl: 'assets/Pulldown.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%9E%AB%ED%92%80%EB%8B%A4%EC%9A%B4',
    ),
    ExerciseEquipment(
      name: '시티드 케이블 로우',
      description: '1. 케이블을 마주보고 앉아 발판에 발을 올린후 무릎을 살짝 굽혀줍니다./n/n'
          '2. 허리를 펴고 가슴을 내민 상태에서 케이블을 잡아 당깁니다. 이때 등 중앙부를 접는다는 느낌으로 팔꿈치를 척추쪽으로 모아줍니다./n/n'
          '3. 중량을 등으로 버티면서 천천히 팔을 펴서 시작 자세로 돌아갑니다./n/n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%8B%9C%ED%8B%B0%EB%93%9C+%EC%BC%80%EC%9D%B4%EB%B8%94+%EB%A1%9C%EC%9A%B0',
    ),
    ExerciseEquipment(
      name: '풀업',
      description: '1. 팔을 어깨 너비만큼 벌리고, 손바닥이 앞을 바라본 상태로 바를 잡고 매달립니다.\n\n'
          '2. 가슴을 편 상태로 바를 구부려 준다는 느낌으로 팔을 당겨 올라갑니다.\n\n'
          '3. 상체가 흔들리지 않도록 자세를 유지하면서 내려옵니다.\n\n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url: 'https://www.youtube.com/results?search_query=%ED%92%80%EC%97%85',
    ),
    ExerciseEquipment(
      name: '중량 풀업',
      description: '1. 중량 도구를 장착하고, 팔을 어깨 너비만큼 살짝 넓게 벌린 상태로 바를 잡고 매달립니다.\n\n'
          '2. 가슴을 편 상태로 바를 구부려 준다는 느낌으로 팔을 당겨 올라갑니다.\n\n'
          '3. 등에 자극을 느끼면서 내려와 시작 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%A4%91%EB%9F%89+%ED%92%80%EC%97%85',
    ),
    ExerciseEquipment(
      name: '덤벨 로우',
      description: '1. 다리를 골반너비로 벌리고, 상체를 숙여 손등이 위로 향하게끔 덤벨을 잡습니다.\n\n'
          '2. 허리가 구부러지지 않게 중립 상태를 유지한 채로, 무릎 높이로 덤벨을 들어올린다.\n\n'
          '3. 팔꿈치를 몸쪽으로 붙인다는 생각으로 팔을 굽혀 덤벨을 복부까지 끌어당겨 줍니다.\n\n'
          '4. 등의 자극을 느끼며 덤벨을 내려 2번의 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EB%A1%9C%EC%9A%B0',
    ),
    ExerciseEquipment(
      name: '라잉 바벨 로우',
      description: '1. 다리를 골반너비로 벌리고, 상체를 숙여 손등이 위로 향하게끔 덤벨을 잡습니다.\n\n'
          '2. 허리가 구부러지지 않게 중립 상태를 유지한 채로, 무릎 높이로 덤벨을 들어올린다.\n\n'
          '3. 팔꿈치를 몸쪽으로 붙인다는 생각으로 팔을 굽혀 덤벨을 복부까지 끌어당겨 줍니다.\n\n'
          '4. 등의 자극을 느끼며 덤벨을 내려 2번의 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EB%A1%9C%EC%9A%B0',
    ),
    ExerciseEquipment(
      name: '언더그립 바벨 로우',
      description: '1. 다리를 골반너비로 벌리고, 상체를 숙여 손등이 위로 향하게끔 덤벨을 잡습니다.\n\n'
          '2. 허리가 구부러지지 않게 중립 상태를 유지한 채로, 무릎 높이로 덤벨을 들어올린다.\n\n'
          '3. 팔꿈치를 몸쪽으로 붙인다는 생각으로 팔을 굽혀 덤벨을 복부까지 끌어당겨 줍니다.\n\n'
          '4. 등의 자극을 느끼며 덤벨을 내려 2번의 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EB%A1%9C%EC%9A%B0',
    ),
    ExerciseEquipment(
      name: '정지 바벨 로우',
      description: '1. 다리를 골반너비로 벌리고, 상체를 숙여 손등이 위로 향하게끔 덤벨을 잡습니다.\n\n'
          '2. 허리가 구부러지지 않게 중립 상태를 유지한 채로, 무릎 높이로 덤벨을 들어올린다.\n\n'
          '3. 팔꿈치를 몸쪽으로 붙인다는 생각으로 팔을 굽혀 덤벨을 복부까지 끌어당겨 줍니다.\n\n'
          '4. 등의 자극을 느끼며 덤벨을 내려 2번의 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EB%A1%9C%EC%9A%B0',
    ),
    ExerciseEquipment(
      name: '바벨 풀오버',
      description: '1. 다리를 골반너비로 벌리고, 상체를 숙여 손등이 위로 향하게끔 덤벨을 잡습니다.\n\n'
          '2. 허리가 구부러지지 않게 중립 상태를 유지한 채로, 무릎 높이로 덤벨을 들어올린다.\n\n'
          '3. 팔꿈치를 몸쪽으로 붙인다는 생각으로 팔을 굽혀 덤벨을 복부까지 끌어당겨 줍니다.\n\n'
          '4. 등의 자극을 느끼며 덤벨을 내려 2번의 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EB%A1%9C%EC%9A%B0',
    ),
    ExerciseEquipment(
      name: '백 익스텐션',
      description: '1. 다리를 골반너비로 벌리고, 상체를 숙여 손등이 위로 향하게끔 덤벨을 잡습니다.\n\n'
          '2. 허리가 구부러지지 않게 중립 상태를 유지한 채로, 무릎 높이로 덤벨을 들어올린다.\n\n'
          '3. 팔꿈치를 몸쪽으로 붙인다는 생각으로 팔을 굽혀 덤벨을 복부까지 끌어당겨 줍니다.\n\n'
          '4. 등의 자극을 느끼며 덤벨을 내려 2번의 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EB%A1%9C%EC%9A%B0',
    ),
  ],
  '복근': [
    ExerciseEquipment(
      name: '복근 크런치 머신',
      description: '1. 운동중 하체가 움직이지 않도록 발판에 양발을 올리고 기구에 앉습니다./n/n'
          '2. 손잡이를 양손으로 잡은 상태에서 복근에 자극을 느끼며 상체를 앞으로 숙여줍니다./n/n'
          '3. 굽었던 상체를 천천히 피면서 처음의 자세로 돌아갑니다./n/n',
      imageUrl: 'assets/Seated_Crunch.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%B3%B5%EA%B7%BC+%ED%81%AC%EB%9F%B0%EC%B9%98+%EB%A8%B8%EC%8B%A0',
    ),
    ExerciseEquipment(
      name: '디클라인 크런치',
      description: '1. 기울어진 벤치에 누워 발목을 고정한 상태에서, 양손은 가슴 앞이나 머리 뒤로 올려 고정합니다./n/n'
          '2. 등 전체가 아닌 상체 윗부분만 서서히 들어올려, 복근의 윗 부분의 수축감을 느낍니다. (이때 가슴을 펴서 척추의 자극 최소화합니다.)/n/n'
          '3. 윗 복근의 긴장감을 느끼면서 천천히 내려옵니다./n/n',
      imageUrl: 'assets/Decline_Crunch.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%94%94%ED%81%B4%EB%9D%BC%EC%9D%B8+%ED%81%AC%EB%9F%B0%EC%B9%98',
    ),
    ExerciseEquipment(
      name: '러시안 트위스트',
      description: '1. 바닥에 엉덩이를 붙이고 앉아 케틀벨(혹은 덤벨)을 양손으로 움켜 잡습니다./n/n'
          '2. 복근에 힘을 준 상태로, 몸통과 허벅지가 V자 형태가 되도록 등을 기울입니다./n/n'
          '3. 자세를 유지하면서 케틀벨(혹은 덤벨)을 좌우로 번갈아 이동합니다./n/n',
      imageUrl: 'assets/Seated_Crunch.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%9F%AC%EC%8B%9C%EC%95%88+%ED%8A%B8%EC%9C%84%EC%8A%A4%ED%8A%B8',
    ),
    ExerciseEquipment(
      name: '싯업',
      description: '1. 무릎을 구부리고 바닥에 누워서, 발이 바닥과 떨어지지 않게 합니다.\n\n'
          '2. 배의 근육을 이용해 상체를 들어올립니다.\n\n'
          '3. 복근에 힘을 유지하면서 시작 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/Seated_Crunch.jpg',
      url: 'https://www.youtube.com/results?search_query=%EC%8B%AF%EC%97%85',
    ),
    ExerciseEquipment(
      name: '브이업',
      description: '1. 바닥에 누워서 팔과 다리를 일자로 쭉 펴줍니다.\n\n'
          '2.  상체와 하체가 V 모양이 되도록 상,하체를 동시에 들어올립니다.\n\n'
          '3. 복근의 자극을 느끼며 천천히 시작 자세로 돌아옵니다.\n\n',
      imageUrl: 'assets/Seated_Crunch.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%B8%8C%EC%9D%B4%EC%97%85',
    ),
    ExerciseEquipment(
      name: '크런치',
      description: '1. 무릎을 굽히고 바닥에 누워, 양손은 가슴 앞이나 머리 뒤로 올려 고정합니다.\n\n'
          '2. 등 전체가 아닌 상체 윗부분만 서서히 들어올려, 복근의 윗 부분의 수축감을 느낀다.(이때, 가슴을 펴서 척추의 자극 최소화합니다.).\n\n'
          '3. 윗 복근의 긴장감을 느끼면서 천처히 내려옵니다.\n\n',
      imageUrl: 'assets/Seated_Crunch.jpg',
      url:
          'https://www.youtube.com/results?search_query=%ED%81%AC%EB%9F%B0%EC%B9%98',
    ),
    ExerciseEquipment(
      name: '레그 레이즈',
      description: '1. 바닥에 똑바로 누운 상태에서, 팔을 골반옆에 위치시켜 바닥을 지지할 수 있도록 합니다.\n\n'
          '2. 등을 바닥에 밀착시킨 상태로, 무릎을 최대한 피면서 다리를 들어올립니다.\n\n'
          '3. 허리가 뜨지 않도록 복근에 힘을 주면서 천천히 다리를 내려줍니다.\n\n',
      imageUrl: 'assets/Seated_Crunch.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%A0%88%EA%B7%B8+%EB%A0%88%EC%9D%B4%EC%A6%88',
    ),
    ExerciseEquipment(
      name: '플랭크',
      description: '1. 손목과 팔꿈치를 바닥에 댄 상태로 바닥에 엎드립니다.\n\n'
          '2. 팔꿈치와 어깨를 동일선상에 높은 상태에서, 복부와 엉덩이에 힘을 주며 몸을 밀어 올립니다.\n\n'
          '3. 등을 평평하게 만든다는 생각으로 팔꿈치로 바닥을 밀며 자세를 유지합니다.\n\n',
      imageUrl: 'assets/Seated_Crunch.jpg',
      url:
          'https://www.youtube.com/results?search_query=%ED%94%8C%EB%9E%AD%ED%81%AC',
    ),
    ExerciseEquipment(
      name: '디클라인 크런치',
      description: '1. 기울어진 벤치에 누워 발목을 고정한 상태에서, 양손은 가슴 앞이나 머리 뒤로 올려 고정합니다.\n\n'
          '2. 등 전체가 아닌 상체 윗부분만 서서히 들어올려, 복근의 위 부분의 수축감을 느낍니다.(이때, 가슴을 펴서 척추의 자극을 최소화합니다.)\n\n'
          '3. 윗 복근의 긴장감을 느끼면서 천천히 내려옵니다.\n\n',
      imageUrl: 'assets/Seated_Crunch.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%94%94%ED%81%B4%EB%9D%BC%EC%9D%B8+%EC%8B%AF%EC%97%85',
    ),
    ExerciseEquipment(
      name: '사이드 플랭크',
      description: '1. 팔꿈치를 바닥에 대고 몸을 곧게 편상태로 옆으로 눕습니다. 이때, 양발은 모아줍니다.\n\n'
          '2. 바닥에 대고 있는 팔로 바닥을 지그시 밀면서 엉덩이를 들어올려 몸통 전체를 일직선으로 만듭니다.\n\n'
          '3. 정해진 시간만큼 버티고 엉덩이를 천천히내려 시작자세로 돌아옵니다.\n\n',
      imageUrl: 'assets/Seated_Crunch.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%82%AC%EC%9D%B4%EB%93%9C+%ED%94%8C%EB%9E%AD%ED%81%AC',
    ),
  ],
  '유산소': [
    ExerciseEquipment(
      name: '싸이클',
      description: '1.인장을 체형에 맞게 조절하고 알맞은 강도로 운동합니다.',
      imageUrl: 'assets/Bicycle.png',
      url:
          'https://www.youtube.com/results?search_query=%EC%82%AC%EC%9D%B4%ED%81%B4+%EC%9D%B8%ED%84%B0%EB%B2%8C',
    ),
    ExerciseEquipment(
      name: '스텝밀',
      description: '1.속도, 강도를 알맞게 조절하고 운동합니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url:
          'https://www.youtube.com/results?search_query=%EC%8A%A4%ED%85%9D%EB%B0%80',
    ),
    ExerciseEquipment(
      name: '계단 오르기',
      description: '1.넘어지지 않게 유의하면서 계단을 한칸씩 올라갑니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url:
          'https://www.youtube.com/results?search_query=%EA%B3%84%EB%8B%A8+%EC%98%A4%EB%A5%B4%EA%B8%B0',
    ),
    ExerciseEquipment(
      name: '달리기',
      description: '1.올바른 자세로 달립니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url:
          'https://www.youtube.com/results?search_query=%EB%8B%AC%EB%A6%AC%EA%B8%B0+%EB%B0%A9%EB%B2%95',
    ),
    ExerciseEquipment(
      name: '하이니 스킵',
      description: '1. 무릎을 높게 들어 제자리에서 뜁니다.\n\n'
          '2. 빠르게 달릴 때처럼 팔꿈치도 90도가 되도록 크게 스윙합니다.\n\n'
          '3. 지면과의 접촉시간을 최소로 합니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url:
          'https://www.youtube.com/results?search_query=%ED%95%98%EC%9D%B4%EB%8B%88+%EC%8A%A4%ED%82%B5',
    ),
    ExerciseEquipment(
      name: '트레드밀',
      description: '1. 속도, 경사를 알맞게 조절하고 운동합니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url:
          'https://www.youtube.com/results?search_query=%ED%8A%B8%EB%A0%88%EB%93%9C%EB%B0%80',
    ),
    ExerciseEquipment(
      name: '이단 뛰기',
      description: '1. 몸에 힘을 빼고 시선은 정면을 향한 상태로 곧게 섭니다.\n\n'
          '2. 줄넘기의 손잡이를 허리 높이에 위치시키고 손목의 힘으로 2번 연속으로 돌려줍니다.\n\n'
          '3. 무릎의 탄력을 이용하여 수직으로 점프하여 줄을 넘습니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url:
          'https://www.youtube.com/results?search_query=%EC%9D%B4%EB%8B%A8+%EB%9B%B0%EA%B8%B0',
    ),
    ExerciseEquipment(
      name: '줄넘기',
      description: '1. 몸에 힘을 빼고 시선은 정면을 향한 상태로 곧게 섭니다.\n\n'
          '2. 줄넘기의 손잡이를 허리 높이에 위치시키고 손목의 힘으로 가볍게 돌려줍니다.\n\n'
          '3. 무릎의 탄력을 이용하여 수직으로 점프하여 줄을 넘습니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url:
          'https://www.youtube.com/results?search_query=%EC%A4%84%EB%84%98%EA%B8%B0',
    ),
    ExerciseEquipment(
      name: '걷기',
      description: '1. 올바른 자세로 걷습니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url: 'https://www.youtube.com/results?search_query=%EA%B1%B7%EA%B8%B0',
    ),
  ],
  '기타': [
    ExerciseEquipment(
      name: '버피',
      description: '1. 다리를 어깨너비로 벌리고 편하게 섭니다.\n\n'
          '2. 스쿼트 자세를 취한 이후 상체를 내리면서 팔굽혀펴기 1회를 수행합니다.\n\n'
          '3. 엎드려뻗쳐 자세에서 다리를 가슴 쪽으로 당겨 스쿼트 동작으로 돌아옵니다.\n\n'
          '4. 일어나면서 양손을 하늘 위로 뻗으면서 점프합니다.\n\n',
      imageUrl: 'assets/Burpee.jpg',
      url: 'https://www.youtube.com/results?search_query=%EB%B2%84%ED%94%BC',
    ),
    ExerciseEquipment(
      name: '점핑 잭',
      description: '1.가슴과 허리를 곧게 펴고 섭니다.\n\n'
          '2. 무릎을 살짝 굽혀 점프하면서 양 발을 어깨너비 정도로 벌립니다. 이때, 양 팔은 어깨 높이까지 올려줍니다.\n\n'
          '3. 다시 점프하며 발을 모으고 동시에 양팔을 처음 자세로 내려줍니다.\n\n'
          '4. 무릎을 살짝 굽혀 점프하며 발을 어깨너비 정도로 벌리면서, 양팔을 머리위까지 올려줍니다.\n\n'
          '5. 다시 점프하며 발을 모으고 동시에 양팔을 처음 자세로 내려줍니다.\n\n',
      imageUrl: 'assets/Jumpinf_Jack.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%A0%90%ED%95%91+%EC%9E%AD',
    ),
    ExerciseEquipment(
      name: '마운틴 클라이머',
      description: '1. 양팔을 어깨너비로 벌리고 엎드립니다.\n\n'
          '2. 한쪽 무릎이 가슴에 닿을정도로 힘차게 올립니다.\n\n'
          '3. 올렸던 무릎을 내리며, 반대쪽 무릎을 가슴방향으로 올립니다.\n\n',
      imageUrl: 'assets/Jumpinf_Jack.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%A7%88%EC%9A%B4%ED%8B%B4+%ED%81%B4%EB%9D%BC%EC%9D%B4%EB%A8%B8',
    ),
    ExerciseEquipment(
      name: '쓰리스터',
      description: '1. 바벨을 어깨너비로 잡고 쇄골 위에 올려둡니다.\n\n'
          '2. 시선은 정면을 유지하면서 엉덩이를 뒤로 빼면서 앉습니다.\n\n'
          '3. 복근과 엉덩이에 힘을 주면서 힘차게 일어납니다.\n\n'
          '4. 일어나는 힘을 이용하여 바벨을 머리 위로 힘껏 밀어올립니다.\n\n',
      imageUrl: 'assets/Jumpinf_Jack.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%93%B0%EB%A6%AC%EC%8A%A4%ED%84%B0',
    ),
    ExerciseEquipment(
      name: '인치웜',
      description: '1. 양발을 곧게 편 상태에서 허리를 굽혀 양손을 양발 앞에 위치 시킵니다.\n\n'
          '2. 무릎이 굽지 않게 유지하면서 양손을 한걸음씩 앞으로 뻗어줍니다. 양손은 허리 라인이 일직선이 될때까지 앞으로 이동합니다.\n\n'
          '3. 푸시업을 한번 수행합니다.\n\n'
          '4. 양손을 역순서대로 움직여 시작 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/Jumpinf_Jack.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%9D%B8%EC%B9%98%EC%9B%9C',
    ),
    ExerciseEquipment(
      name: '케틀벨 스윙',
      description: '1. 이 운동은 복잡한 동작으로, 적절한 지도가 가능한 트레이너와 상담하는 것을 추천합니다.\n\n'
          '2. 양발을 어깨너비보다 살짝 넓게 벌린 상태에서, 양손으로 케틀벨을 잡습니다.\n\n'
          '3. 허리가 굽지 않도록 복부와 코어에 긴장을 유지한 상태로, 케틀벨을 다리 사이로 보냅니다.\n\n'
          '4. 둔근을 수축하는 힘으로 케틀벨을 밀어 올립니다.\n\n'
          '5. 케틀벨 스윙을 통해 둔근의 수축 이완을 반복합니다.\n\n',
      imageUrl: 'assets/Jumpinf_Jack.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EC%BC%80%ED%8B%80%EB%B2%A8+%EC%8A%A4%EC%9C%99',
    ),
    ExerciseEquipment(
      name: '터키쉬 겟업',
      description: '1. 이 운동은 복잡한 동작으로, 적절한 지도가 가능한 트레이너와 상담하는 것을 추천합니다.\n\n'
          '2. 바닥에 곧게 누운 상태에서 케틀벨을 잡은 손ㅇ르 바닥과 수직방향으로 곧게 뻗습니다. 이때, 같은쪽의 무릎은 90도로 굽혀 발바닥으로 바닥을 지지합니다.\n\n'
          '3. 케틀벨을 지속적으로 밀어올리면서 반대쪽 손과 다리를 활용하여 몸을 천천히 일으킵니다.\n\n'
          '4. 케틀벨 바닥면과 수직하게 유지하면서 곧게 일어섭니다.\n\n'
          '5. 일어설때의 역순서로 동작을 취하면서 시작 자세로 돌아갑니다.\n\n',
      imageUrl: 'assets/Jumpinf_Jack.jpg',
      url:
          'https://www.youtube.com/results?search_query=%ED%84%B0%ED%82%A4%EC%89%AC+%EA%B2%9F%EC%97%85+',
    ),
    ExerciseEquipment(
      name: '파머스 워크',
      description: '1. 양손에 케틀벨(혹은 덤벨)을 들고 양발을 엉덩이 너비만큼 벌리고 섭니다.\n\n'
          '2. 가슴을 활짝 펴고 등에 힘을 준 상태로 복부를 단단하게 조입니다.\n\n'
          '3. 어깨를 뒤로 당긴 상태로 복압을 유지하면서 천천히 앞으로 걷습니다.\n\n',
      imageUrl: 'assets/Jumpinf_Jack.jpg',
      url:
          'https://www.youtube.com/results?search_query=%ED%8C%8C%EB%A8%B8%EC%8A%A4+%EC%9B%8C%ED%81%AC',
    ),
    ExerciseEquipment(
      name: '덤벨 버피',
      description: '1. 양손에 덤벨을 들고, 다리는 어깨 너비만큼 벌리고 편하게 섭니다.\n\n'
          '2. 다리를 어깨너비로 벌리고 편하게 섭니다.\n\n'
          '3. 스쿼트 자세를 취한 이후 상체를 내리면서 팔굽혀펴기 1회를 수행합니다.\n\n'
          '4. 엎드려뻗쳐 자세에서 다리를 가슴 쪽으로 당겨 스쿼트 동작으로 돌아옵니다.\n\n'
          '5. 무릎과 골반을 펴주면서 수직방향으로 점프합니다.\n\n',
      imageUrl: 'assets/Jumpinf_Jack.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EB%B2%84%ED%94%BC',
    ),
    ExerciseEquipment(
      name: '덤벨 쓰러스터',
      description: '1. 덤벨을 양손에 하나씩 잡고 양 어깨 위에 올려둡니다.\n\n'
          '2. 시선은 정면을 유지하면서 엉덩이를 뒤로 빼면서 앉습니다.\n\n'
          '3. 복근과 엉덩이에 힘을 주면서 힘차게 일어납니다.\n\n'
          '4. 일어나는 힘을 이용하여 덤벨을 머리 위로 힘껏 밀어올립니다.\n\n',
      imageUrl: 'assets/Jumpinf_Jack.jpg',
      url:
          'https://www.youtube.com/results?search_query=%EB%8D%A4%EB%B2%A8+%EC%93%B0%EB%9F%AC%EC%8A%A4%ED%84%B0',
    ),
  ],
  // 다른 운동 부위 및 운동 기구들에 대한 데이터 추가
};
