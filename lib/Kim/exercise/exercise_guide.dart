import 'package:flutter/material.dart';

class ExerciseGuidePage extends StatefulWidget {
  const ExerciseGuidePage({Key? key}) : super(key: key);

  @override
  _ExerciseGuidePageState createState() => _ExerciseGuidePageState();
}

class _ExerciseGuidePageState extends State<ExerciseGuidePage> {
  late PageController _pageController;
  final List<String> _bodyParts = [
    '가슴',
    '어깨',
    '하체',
    '엉덩이',
    '등',
    '복근',
    '전신',
    '유산소'
  ];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 기구 사용 방법'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBodyPartSelector(),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              itemCount: _bodyParts.length,
              itemBuilder: (context, index) {
                return _buildExerciseGuides(_bodyParts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyPartSelector() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _bodyParts.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              onPressed: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.blue;
                  }
                  return _selectedIndex == index ? Colors.blue : null;
                }),
              ),
              child: Text(_bodyParts[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExerciseGuides(String bodyPart) {
    final List<ExerciseGuide> allGuides = [
      const ExerciseGuide(
        name: '덤벨 컬',
        description: '이 운동은 팔의 이두박근을 강화하는 데 도움이 됩니다.',
        imagePath: 'assets/images/dumbbell_curl.png',
        bodyPart: '상체',
      ),
      const ExerciseGuide(
        name: '스쿼트',
        description: '스쿼트는 다리와 엉덩이의 근육을 강화합니다.',
        imagePath: 'assets/images/squat.png',
        bodyPart: '하체',
      ),
      // 추가 운동 기구 사용 방법
    ];

    return ListView(
      children: allGuides
          .where((guide) => bodyPart == '전체' || guide.bodyPart == bodyPart)
          .map((guide) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: guide,
              ))
          .toList(),
    );
  }
}

class ExerciseGuide extends StatelessWidget {
  final String name;
  final String description;
  final String imagePath;
  final String bodyPart;

  const ExerciseGuide({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.bodyPart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(
          imagePath,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(name),
        subtitle: Text(description),
      ),
    );
  }
}
