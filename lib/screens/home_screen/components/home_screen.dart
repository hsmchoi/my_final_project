// home_screen.dart
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../data/card/questions.dart';
import '../../../widgets/custom_widget.dart';

// 홈 화면을 나타내는 Stateful 위젯입니다.
// Stateful 위젯은 상태를 가지며, 상태 변화에 따라 UI를 업데이트할 수 있습니다.
class HomeScreen extends StatefulWidget {
  // 라우트 이름과 URL을 상수로 정의합니다.
  // 라우트 이름은 앱 내에서 특정 화면을 식별하는 데 사용됩니다.
  // 라우트 URL은 브라우저 주소 표시줄에 표시되는 URL입니다.
  static const routeName = 'home';
  static const routeURL = '/';

  const HomeScreen({super.key});

  @override
  // State 객체를 생성하여 반환합니다.
  // State 객체는 Stateful 위젯의 상태를 관리합니다.
  State<HomeScreen> createState() => _HomeScreenState();
}

// HomeScreen의 상태를 관리하는 State 클래스입니다.
// SingleTickerProviderStateMixin을 사용하여 애니메이션을 제어합니다.
class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // 애니메이션 컨트롤러는 애니메이션의 시작, 정지, 반복 등을 제어합니다.
  late AnimationController _animationController;
  // 애니메이션 객체는 애니메이션의 현재 값을 나타냅니다.
  late Animation<double> _waveAnimation;
  // 별똥별 입자들을 저장할 리스트
  final List<StarParticle> _particles = [];

  // 별똥별 애니메이션을 제어할 애니메이션 컨트롤러
  late AnimationController _starAnimationController;
  @override
  // initState() 메서드는 State 객체가 생성될 때 호출됩니다.
  // 애니메이션 컨트롤러를 초기화하고 애니메이션을 반복 재생합니다.
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러를 초기화합니다.
    _animationController = AnimationController(
      // vsync는 애니메이션의 동기화를 담당합니다.
      vsync: this,
      // duration은 애니메이션의 지속 시간을 설정합니다.
      duration: const Duration(seconds: 5), // 애니메이션 지속 시간을 필요에 따라 조정합니다.
    )..repeat(); // 애니메이션을 반복 재생합니다.

    // 곡선 애니메이션을 생성합니다.
    // 곡선 애니메이션은 애니메이션의 시작과 끝 부분을 부드럽게 만들어줍니다.
    _waveAnimation = CurvedAnimation(
      // parent는 부모 애니메이션 컨트롤러를 설정합니다.
      parent: _animationController,
      // curve는 애니메이션 곡선을 설정합니다.
      curve: Curves.easeInOut,
    );
    // 별똥별 애니메이션 컨트롤러 초기화
    _starAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // 별똥별 애니메이션 지속 시간 설정
    );
  }

  @override
  // dispose() 메서드는 State 객체가 제거될 때 호출됩니다.
  // 애니메이션 컨트롤러를 해제하여 리소스를 해제합니다.
  void dispose() {
    _animationController.dispose();
    super.dispose();
    // 별똥별 애니메이션 컨트롤러 해제
    _starAnimationController.dispose();
  }

  // 버튼 클릭 시 실행될 함수를 수정합니다.
  void _saveAnswer() {
    // 텍스트 필드에서 답변을 가져옵니다.

    // TODO: 답변을 Firestore에 저장하는 로직을 여기에 추가합니다.

    // 텍스트 필드를 초기화합니다.
    _answerController.clear();

    // 다음 질문으로 넘어갑니다.
    setState(() {
      _currentQuestionIndex =
          (_currentQuestionIndex + 1) % socratesQuestions.length;
    });

    // 애니메이션을 실행합니다.
    _animationController.forward(from: 0.0);
    // 별똥별 입자 생성
    _spawnParticles();

    // 별똥별 애니메이션 실행
    _starAnimationController.forward(from: 0.0);
  }

  // 별똥별 입자를 생성하는 함수
  void _spawnParticles() {
    // 랜덤 객체 생성
    final random = Random();

    // 10개의 별똥별 입자 생성
    for (int i = 0; i < 120; i++) {
      // 랜덤한 위치, 크기, 색상, 속도 설정
      _particles.add(
        StarParticle(
          position: Offset(
            MediaQuery.of(context).size.width / 2, // 화면 가운데에서 시작
            MediaQuery.of(context).size.height / 3, // 화면 가운데에서 시작
          ),
          size: random.nextDouble() * 5.0 + 1.0, // 랜덤한 크기
          color: Color.fromRGBO(
            random.nextInt(256),
            random.nextInt(256),
            random.nextInt(256),
            1.0,
          ), // 랜덤한 색상
          speed: Offset(
            (random.nextDouble() - 0.5) * 50.0, // 랜덤한 x축 속도
            (random.nextDouble() - 0.5) * 50.0, // 랜덤한 y축 속도
          ),
        ),
      );
    }
  }

  int _currentQuestionIndex = 0;
  // 입력 필드에 입력된 텍스트를 저장하는 변수를 선언합니다.
  final TextEditingController _answerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('헤라클리토스의 흐름'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            // rgb(237,247,255)
            colors: [
              Color.fromARGB(255, 237, 247, 255),
              Color.fromARGB(255, 237, 190, 152),
            ],
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 물결 애니메이션을 유지합니다.
              AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WavePainter(_waveAnimation.value),
                    size: const Size(350, 450),
                  );
                },
              ),

              AnimatedBuilder(
                animation: _starAnimationController,
                builder: (context, child) {
                  // 별똥별 입자들을 업데이트하고 그립니다.
                  for (var particle in _particles) {
                    particle.update(MediaQuery.of(context).size,
                        _starAnimationController.value);
                  }

                  // 애니메이션이 완료되면 입자 리스트를 초기화합니다.
                  if (_starAnimationController.status ==
                      AnimationStatus.completed) {
                    _particles.clear();
                  }

                  // 별똥별 입자들을 그립니다.
                  return CustomPaint(
                    painter: StarParticlePainter(_particles),
                    size: Size.infinite,
                  );
                },
              ),

              // 질문 카드를 추가합니다.
              Positioned(
                top: 100.0 +
                    20.0 *
                        _waveAnimation.value *
                        (1.0 +
                            sin(_animationController.value * pi * 2)), // 수정된 코드
                child: Transform.translate(
                  offset: Offset(
                      0, -25.0 * _waveAnimation.value), // 좌우로 움직이도록 오프셋을 조정합니다.
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentQuestionIndex = (_currentQuestionIndex + 1) %
                            socratesQuestions.length;
                      });
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          socratesQuestions[_currentQuestionIndex],
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 입력 필드를 추가합니다.
              Positioned(
                // 입력 필드 위치를 질문 카드 아래로 조정합니다.
                top: 250.0 +
                    20.0 *
                        _waveAnimation.value *
                        (1.0 + sin(_animationController.value * pi * 2)),
                // 화면 가운데 정렬을 위해 약간의 오프셋을 추가합니다.
                left: MediaQuery.of(context).size.width * 0.1,

                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      TextField(
                        // 텍스트 입력을 제어하는 컨트롤러를 설정합니다.
                        controller: _answerController,
                        // 입력 필드의 배경색을 투명하게 설정합니다.
                        decoration: const InputDecoration(
                          hintText: "Click",
                          // 힌트 텍스트의 스타일을 지정합니다.
                          hintStyle: TextStyle(color: Colors.grey),
                          // 입력 필드 테두리를 제거합니다.
                          border: InputBorder.none,
                        ),
                        // 텍스트 스타일을 지정합니다.
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.black),

                        // 여러 줄 입력을 허용합니다.
                        maxLines: null,
                      ),
                      ElevatedButton(
                        onPressed:
                            _saveAnswer, // 버튼 클릭 시 _saveAnswer 함수를 실행합니다.
                        child: const Text("저장"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CustomPainter 클래스를 확장하여 사용자 정의 페인터를 만듭니다.
// WavePainter는 물결 애니메이션을 그리는 데 사용됩니다.
class WavePainter extends CustomPainter {
  // animationValue는 애니메이션의 현재 값을 나타냅니다.
  final double animationValue;

  // 생성자는 animationValue를 초기화합니다.
  WavePainter(this.animationValue);

  @override
  // paint() 메서드는 캔버스에 그래픽을 그리는 데 사용됩니다.
  void paint(Canvas canvas, Size size) {
    // Paint 객체는 그래픽을 그리는 데 사용되는 스타일 정보를 저장합니다.
    final paint = Paint()
      ..color = Colors.white // 파도 색상을 사용자 정의합니다.
      ..style = PaintingStyle.fill;

    // Path 객체는 일련의 점과 선으로 구성된 도형을 나타냅니다.
    final path = Path();
    // moveTo() 메서드는 Path 객체의 현재 위치를 이동합니다.
    path.moveTo(0, size.height / 2);

    // for 루프는 파도 모양을 그리기 위해 여러 점을 연결합니다.
    for (double i = 0; i < size.width; i++) {
      // lineTo() 메서드는 Path 객체에 선을 추가합니다.
      path.lineTo(
        i,
        size.height / 2 +
            sin((i / size.width * 2 * 3.14159265359 +
                    animationValue * 2 * 3.14159265359)) *
                10, // 필요에 따라 파도 진폭을 조정합니다.
      );
    }

    // 나머지 점을 연결하여 파도 모양을 완성합니다.
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // drawPath() 메서드는 캔버스에 Path 객체를 그립니다.
    canvas.drawPath(path, paint);
  }

  @override
  // shouldRepaint() 메서드는 캔버스를 다시 그릴지 여부를 결정합니다.
  // 이 경우에는 항상 true를 반환하여 애니메이션이 부드럽게 재생되도록 합니다.
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// 별똥별 입자들을 그리는 CustomPainter 클래스
class StarParticlePainter extends CustomPainter {
  final List<StarParticle> particles;

  StarParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    // 각 입자를 그립니다.
    for (var particle in particles) {
      // Paint 객체를 생성하여 입자의 색상과 크기를 설정합니다.
      final paint = Paint()
        ..color = particle.color
        ..strokeWidth = particle.size;

      // 입자를 점으로 그립니다.
      canvas.drawPoints(
        // 점의 모양을 설정합니다. (여기서는 원 모양)
        PointMode.points,
        // 점의 위치를 설정합니다.
        [particle.position],
        // Paint 객체를 설정합니다.
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // 다시 그릴 필요가 있는지 여부를 반환합니다.
    // 여기서는 항상 true를 반환하여 애니메이션이 부드럽게 재생되도록 합니다.
    return true;
  }
}
