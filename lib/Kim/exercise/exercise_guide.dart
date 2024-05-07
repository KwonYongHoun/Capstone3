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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
          backgroundColor: const Color.fromARGB(255, 95, 231, 100),
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

    Future<void> _launchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
          ),
        );
      }
    }

    return Card(
      margin: const EdgeInsets.all(8),
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
            //IconButton(
            //icon: const Icon(Icons.open_in_browser),
            //onPressed: () {
            //if (equipment.url.isNotEmpty) {
            //_launchURL(equipment.url);
            //} else {
            //ScaffoldMessenger.of(context).showSnackBar(
            //SnackBar(
            //content: Text('No URL provided for ${equipment.name}'),
            //),
            //);
            //}
            //},
            //),
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
      url: 'https://www.lyfta.app/exercise/bench-press-7',
    ),
    ExerciseEquipment(
      name: '딥스',
      description: '1. 딥스바의 폭을 어깨보다 살짝 넓게 셋팅한 상태에서, 손몰이 꺾이지 않게 딥스바에 올라갑니다.\n\n'
          '2. 상체는 살짝 앞으로 기울인상채로 팔꿈치가 90도가 될때까지 팔을 굽혀 몸을 내립니다.\n\n'
          '3. 상체의 균형을 유지한채로 팔을 피면서 올라옵니다.\n\n',
      imageUrl: 'assets/dips.jpg',
      url: 'https://www.lyfta.app/exercise/weighted-tricep-dips-7hr',
    ),
    ExerciseEquipment(
      name: '인클라인 벤치프레스',
      description:
          '1. 기울어진 벤치에 가슴을 펴고 누운 상태에서, 바벨을 어깬비보다 조금 넓게 잡고 위로 들어올립니다.\n\n'
          '2. 가슴 근육의 이완을 느끼며 팔을 굽혀 바벨을 가슴 방향으로 내립니다.\n\n'
          '3. 가슴 근육의 수축을 느끼며 바닥의 수직방향으로 바벨을 밀어올립니다.\n\n',
      imageUrl: 'assets/dips.jpg',
      url: 'https://www.lyfta.app/exercise/weighted-tricep-dips-7hr',
    ),
    ExerciseEquipment(
      name: '디클라인 벤치프레스',
      description:
          '1. 기울어진 벤치에 가슴을 펴고 누운 상태에서, 바벨을 어깨 너비보다 조금 넓게 잡아 지면의 수직방향으로 들어올립니다.\n\n'
          '2. 가슴 근육의 이완을 느끼며 팔을 굽혀 바벨을 아랫 가슴 방향으로 내립니다.\n\n'
          '3. 가슴 근육의 수축을 느끼며 바닥의 수직방향으로 바벨을 밀어올립니다.\n\n',
      imageUrl: 'assets/dips.jpg',
      url: 'https://www.lyfta.app/exercise/weighted-tricep-dips-7hr',
    ),
    ExerciseEquipment(
      name: '어시스트 딥스 머신',
      description: '1. 보조 받고 시싶은 중량을 설정합니다. 중량이 클수록 더 많이 보조를 받게됩니다.\n\n'
          '2. 손목이 꺾이지 않게 딥스 바에 올라가면서, 받침대에 양무릎을 올려 체중을 실어줍니다.\n\n'
          '3. 상체를 살짝 앞으로 기운 상태로 팔꿈치가 90도가 될때까지 팔을 굽혀 몸을 내립니다.\n\n'
          '4. 상체의 균형을 유지한채로 팔을 피면서 올라옵니다.\n\n',
      imageUrl: 'assets/dips.jpg',
      url: 'https://www.lyfta.app/exercise/weighted-tricep-dips-7hr',
    ),
    ExerciseEquipment(
      name: '시티드 체스트 프레스',
      description: '1. 가슴을 활짝 편 상태로, 의자에 윗 등을 붙이고 앉습니다.\n\n'
          '2. 양손으로 손잡이를 잡고, 가슴에 힘을 주면서 앞으로 밀어줍니다.(이때, 손잡이가 가슴 중앙에 위치할 수 있도록 벤치 높이를 조절합니다.)\n\n'
          '3. 가슴 근육의 이완을 느끼면서 팔꿈치를 뒤로 천천히 이동합니다.(이때, 손목과 팔꿈치가 일직선이 되도록 합니다.)\n\n',
      imageUrl: 'assets/dips.jpg',
      url: 'https://www.lyfta.app/exercise/weighted-tricep-dips-7hr',
    ),
    ExerciseEquipment(
        name: '푸시업',
        description: '1. 양팔을 가슴 옆에 두고 바닥에 엎드립니다.\n\n'
            '2. 복근과 둔근에 힘을 준 상태로 팔꿈치를 피며 올라옵니다.\n\n'
            '3. 천천히 팔꿈치를 굽히며 시작 자세로 돌아갑니다.\n\n',
        imageUrl: 'assets/dips.jpg',
        url: 'https://www.lyfta.app/exercise/push-up-1j'),
  ],
  '어깨': [
    ExerciseEquipment(
      name: '체스트 프레스 머신',
      description: '1. 가슴을 활짝 편 상태로, 의자에 윗 등을 붙이고 앉습니다.\n\n'
          '2. 양손으로 손잡이를 잡고, 가슴에 힘을 주면서 앞으로 밀어줍니다. (이때, 손잡이가 가슴 중앙에 위치할 수 있도록 베니 높이를 조절합니다.)\n\n'
          '3. 가슴 근육의 이완을 느끼면서 팔꿈치를 뒤로 천천히 이동합니다. (이때, 손목과 팔꿈치가 일직선이 되도록 합니다.).\n\n',
      imageUrl: 'assets/chest_press.jpg',
      url: 'https://www.lyfta.app/exercise/lever-chest-press-0u',
    ),
    ExerciseEquipment(
      name: '숄더 프레스 머신',
      description: '1. 머신에 앉아 팔꿈치 각도가 90도가 되도록 팔의 넓이를 조절하여 손잡이를 잡습니다.\n\n'
          '2. 어깨에 자극을 느끼면서 수직방향으로 팔을 밀어 올립니다.\n\n'
          '3. 어깨의 자극을 느끼며 손을 귀 옆까지 천천히 내립니다.\n\n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url: 'https://www.lyfta.app/exercise/lever-shoulder-press--7vy',
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
      url: 'https://www.lyfta.app/exercise/lever-leg-extension-0b',
    ),
    ExerciseEquipment(
      name: '레그 컬',
      description:
          '1. 머신에 엎드린 상태에서, 종아리 쪽의 패드가 아킬레스건 바로 위쪽에 위치하도록 머신을 조정합니다.\n\n'
          '2. 발목을 세운 상태에서, 무릎을 굽혀 기구를 올려줍니다.\n\n'
          '3. 허리, 엉덩이, 햄스트링에 긴장감을 유지하면서 기구를 천천히 내립니다.\n\n',
      imageUrl: 'assets/leg_curl.jpg',
      url: 'https://www.lyfta.app/exercise/lever-lying-leg-curl-0c',
    ),
    ExerciseEquipment(
      name: '레그 프레스',
      description: '1. 엉덩이와 허리가 의자에 완전히 붙도록 밀착하여 앉고, 두 발을 어깨 너비만큼 벌려줍니다.\n\n'
          '2. 이때, 좁게 벌리면 허벅지 바깥쪽, 널베 벌리면 안쪽으로 더 큰 자극을 줄 수 있습니다.\n\n'
          '3. 안전핀을 제거하고, 중량의 자극을 느끼며 무릎을 굽혀줍니다. 엉덩이와 허리가 뜨지 않을 깊이까지 중량판을 내립니다.\n\n'
          '4. 복부에 힘을 유지한채로, 중량판을 지그시 밀어 올립니다.\n\n',
      imageUrl: 'assets/leg_curl.jpg',
      url: 'https://www.lyfta.app/exercise/lever-lying-leg-curl-0c',
    ),
    ExerciseEquipment(
      name: '힙 어브덕션 머신',
      description: '1. 의자에 앉아 무릎 바깥쪽에 패드를 밀착한 상태로 상체를 머신쪽으로 살짝 숙여줍니다./n/n'
          '2. 상,하체가 움직이지 않게 고정된 상태에서 엉덩이 바깥쪽 근육의 힘을 사용하여 양쪽 허벅지를 천천히 옆으로 벌려줍니다./n/n'
          '3. 바깥쪽 엉덩이에 자극을 느끼며 천천히 처음의 자세로 돌아옵니다./n/n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url: 'https://www.lyfta.app/exercise/lever-seated-hip-abduction-19',
    ),
    ExerciseEquipment(
      name: '브이 스쿼트',
      description: '1. 머신에 허리를 붙인 상태에서 기본 스쿼트 보폭으로 곧게 섭니다./n/n'
          '2. 허리가 굽지 않도록 배에 힘을 준 상태로 다리가 기역(ㄱ)자 모양이 될때까지 내려갑니다./n/n'
          '3. 대퇴사두(허벅지)와 힙의 자극을 느끼면서, 양발바닥을 지그시 누르며 올라옵니다 ./n/n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url: 'https://www.lyfta.app/exercise/lever-seated-hip-abduction-19',
    ),
  ],
  '팔': [
    ExerciseEquipment(
      name: '힙 쓰러스트',
      description: '1. 등 상부를 벤티에 기댄 상태에서 발바닥을 지면에 단단히 고정합니다./n/n'
          '2. 엉덩이 힘으로 몸을 윗 방향으로 밀어 올립니다./n/n'
          '3. 천천히 엉덩이를 내려 수축된 엉덩이 근육을 이완시킵니다./n/n',
      imageUrl: 'assets/Hip_Thrust.jpg',
      url: 'https://www.lyfta.app/exercise/hip-thrust-39',
    ),
    ExerciseEquipment(
      name: '힙 어브덕션 머신',
      description: '1. 의자에 앉아 무릎 바깥쪽에 패드를 밀착한 상태로 상체를 머신쪽으로 살짝 숙여줍니다./n/n'
          '2. 상,하체가 움직이지 않게 고정된 상태에서 엉덩이 바깥쪽 근육의 힘을 사용하여 양쪽 허벅지를 천천히 옆으로 벌려줍니다./n/n'
          '3. 바깥쪽 엉덩이에 자극을 느끼며 천천히 처음의 자세로 돌아옵니다./n/n',
      imageUrl: 'assets/Hip_Abduction.jpg',
      url: 'https://www.lyfta.app/exercise/lever-seated-hip-abduction-19',
    ),
  ],
  '등': [
    ExerciseEquipment(
      name: '랫풀다운',
      description: '1. 허벅지 지지대의 높낮이를 알맞게 조절하고, 바를 어깨너비보다 넓게 잡고 의자에 앉습니다./n/n'
          '2. 허벅지를 지지대에 고정하고 가슴을 편상태로, 바가 쇄골에 닿을정도로 바를 당겨줍니다. (이때, 팔이 아닌 등(광배근)의 힘으로 바를 당겨줍니다.)/n/n'
          '3. 광배근이 이완하는 것을 느끼면서 천천히 팔을 폅니다./n/n',
      imageUrl: 'assets/Pulldown.jpg',
      url: 'https://www.lyfta.app/exercise/pulldown-7j',
    ),
    ExerciseEquipment(
      name: '시티드 케이블 로우',
      description: '1. 케이블을 마주보고 앉아 발판에 발을 올린후 무릎을 살짝 굽혀줍니다./n/n'
          '2. 허리를 펴고 가슴을 내민 상태에서 케이블을 잡아 당깁니다. 이때 등 중앙부를 접는다는 느낌으로 팔꿈치를 척추쪽으로 모아줍니다./n/n'
          '3. 중량을 등으로 버티면서 천천히 팔을 펴서 시작 자세로 돌아갑니다./n/n',
      imageUrl: 'assets/side_lateral_raise.jpg',
      url: 'https://www.lyfta.app/exercise/straight-back-seated-row-7c',
    ),
  ],
  '복근': [
    ExerciseEquipment(
      name: '복근 크런치 머신',
      description: '1. 운동중 하체가 움직이지 않도록 발판에 양발을 올리고 기구에 앉습니다./n/n'
          '2. 손잡이를 양손으로 잡은 상태에서 복근에 자극을 느끼며 상체를 앞으로 숙여줍니다./n/n'
          '3. 굽었던 상체를 천천히 피면서 처음의 자세로 돌아갑니다./n/n',
      imageUrl: 'assets/Seated_Crunch.jpg',
      url: 'https://www.lyfta.app/exercise/lever-seated-crunch-70a',
    ),
    ExerciseEquipment(
      name: '디클라인 크런치',
      description: '1. 기울어진 벤치에 누워 발목을 고정한 상태에서, 양손은 가슴 앞이나 머리 뒤로 올려 고정합니다./n/n'
          '2. 등 전체가 아닌 상체 윗부분만 서서히 들어올려, 복근의 윗 부분의 수축감을 느낍니다. (이때 가슴을 펴서 척추의 자극 최소화합니다.)/n/n'
          '3. 윗 복근의 긴장감을 느끼면서 천천히 내려옵니다./n/n',
      imageUrl: 'assets/Decline_Crunch.jpg',
      url: 'https://www.lyfta.app/exercise/decline-crunch-6h5',
    ),
    ExerciseEquipment(
      name: '러시안 트위스트',
      description: '1. 바닥에 엉덩이를 붙이고 앉아 케틀벨(혹은 덤벨)을 양손으로 움켜 잡습니다./n/n'
          '2. 복근에 힘을 준 상태로, 몸통과 허벅지가 V자 형태가 되도록 등을 기울입니다./n/n'
          '3. 자세를 유지하면서 케틀벨(혹은 덤벨)을 좌우로 번갈아 이동합니다./n/n',
      imageUrl: 'assets/Seated_Crunch.jpg',
      url: 'https://www.lyfta.app/exercise/russian-twist-6sj',
    ),
  ],
  '유산소': [
    ExerciseEquipment(
      name: '싸이클',
      description: '1.인장을 체형에 맞게 조절하고 알맞은 강도로 운동합니다.',
      imageUrl: 'assets/Bicycle.png',
      url: 'https://www.lyfta.app/exercise/bicycle-recline-walk-7sm',
    ),
    ExerciseEquipment(
      name: '스텝밀',
      description: '1.속도, 강도를 알맞게 조절하고 운동합니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url: 'https://www.lyfta.app/exercise/bench-press-7',
    ),
    ExerciseEquipment(
      name: '계단 오르기',
      description: '1.넘어지지 않게 유의하면서 계단을 한칸씩 올라갑니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url: 'https://www.lyfta.app/exercise/stair-up-84e',
    ),
    ExerciseEquipment(
      name: '달리기',
      description: '1.올바른 자세로 달립니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url: 'https://www.lyfta.app/exercise/run-6sh',
    ),
    ExerciseEquipment(
      name: '하이니 스킵',
      description: '1. 무릎을 높게 들어 제자리에서 뜁니다.\n\n'
          '2. 빠르게 달릴 때처럼 팔꿈치도 90도가 되도록 크게 스윙합니다.\n\n'
          '3. 지면과의 접촉시간을 최소로 합니다.\n\n',
      imageUrl: 'assets/stepmill.png',
      url: 'https://www.lyfta.app/en/exercise/high-knee-skips-8h4',
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
      url: 'https://www.lyfta.app/exercise/burpee-30',
    ),
    ExerciseEquipment(
      name: '점핑 잭',
      description: '1.가슴과 허리를 곧게 펴고 섭니다.\n\n'
          '2. 무릎을 살짝 굽혀 점프하면서 양 발을 어깨너비 정도로 벌립니다. 이때, 양 팔은 어깨 높이까지 올려줍니다.\n\n'
          '3. 다시 점프하며 발을 모으고 동시에 양팔을 처음 자세로 내려줍니다.\n\n'
          '4. 무릎을 살짝 굽혀 점프하며 발을 어깨너비 정도로 벌리면서, 양팔을 머리위까지 올려줍니다.\n\n'
          '5. 다시 점프하며 발을 모으고 동시에 양팔을 처음 자세로 내려줍니다.\n\n',
      imageUrl: 'assets/Jumpinf_Jack.jpg',
      url: 'https://www.lyfta.app/exercise/jumping-jack--8hh',
    ),
    ExerciseEquipment(
      name: '마운틴 클라이머',
      description: '1.양팔을 어깨너비로 벌리고 엎드립니다.\n\n'
          '2. 한쪽 무릎이 가슴에 닿을정도로 힘차게 올립니다.\n\n'
          '3. 올렸던 무릎을 내리며, 반대쪽 무릎을 가슴방향으로 올립니다.\n\n',
      imageUrl: 'assets/Jumpinf_Jack.jpg',
      url: 'https://www.lyfta.app/en/exercise/mountain-climber-6qy',
    ),
  ],
  // 다른 운동 부위 및 운동 기구들에 대한 데이터 추가
};
