import 'dart:math';

import 'package:flutter/material.dart';

import '../../../data/card/questions.dart';

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
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // 애니메이션 컨트롤러는 애니메이션의 시작, 정지, 반복 등을 제어합니다.
  late AnimationController _animationController;
  // 애니메이션 객체는 애니메이션의 현재 값을 나타냅니다.
  late Animation<double> _waveAnimation;

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
  }

  @override
  // dispose() 메서드는 State 객체가 제거될 때 호출됩니다.
  // 애니메이션 컨트롤러를 해제하여 리소스를 해제합니다.
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _currentQuestionIndex = 0;

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
            colors: [Colors.blue, Colors.indigo],
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
                    size: const Size(700, 900),
                  );
                },
              ),
              // 질문 카드를 추가합니다.
              Positioned(
                top: 100.0 +
                    20.0 *
                        _waveAnimation.value *
                        (1.0 +
                            sin(_animationController.value *
                                pi *
                                2)), // 카드가 움직이도록 애니메이션 값을 사용합니다.
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
