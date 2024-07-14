import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreenChoice extends StatefulWidget {
  const LoginScreenChoice({super.key});

  @override
  State<LoginScreenChoice> createState() => _LoginScreenChoiceState();
}

class _LoginScreenChoiceState extends State<LoginScreenChoice>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sunAnimation;
  late Animation<double> _boatAnimation;
  late Animation<double> _waveAnimation;
  double _mouseX = 0;
  double _mouseY = 0;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화 (5초 동안 반복)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // 태양 애니메이션
    _sunAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // 배 애니메이션
    _boatAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // 물결 애니메이션
    _waveAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // 터치 이벤트 처리
        onPanUpdate: (details) {
          setState(() {
            _mouseX = details.localPosition.dx;
            _mouseY = details.localPosition.dy;
          });
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 237, 247, 255),
                Color.fromARGB(255, 237, 190, 152),
              ],
            ),
          ),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Stack(
                children: [
                  // 하늘 애니메이션
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      painter: _SkyPainter(_sunAnimation.value),
                      size: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height * 0.5),
                    ),
                  ),
                  // 배 애니메이션
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.1,
                    left: MediaQuery.of(context).size.width * 0.25,
                    child: Transform.translate(
                      offset: Offset(
                          _boatAnimation.value * 10, _boatAnimation.value * 10),
                      child: const Icon(
                        Icons.directions_boat_filled,
                        size: 60,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // 눈동자 애니메이션
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.2,
                    left: MediaQuery.of(context).size.width * 0.4,
                    child: Transform.rotate(
                      angle: _calculateEyeAngle(),
                      child: const Icon(
                        Icons.remove_red_eye,
                        size: 100,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // 물결 애니메이션
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: CustomPaint(
                      painter: _WavePainter(_waveAnimation.value),
                      size: Size(MediaQuery.of(context).size.width, 50),
                    ),
                  ),
                  // 로그인 버튼
                  Positioned(
                    bottom: MediaQuery.of(context).size.height * 0.1,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 이메일 로그인 버튼
                        _buildLoginButton(
                          icon: Icons.email,
                          onTap: () {
                            context.go('/login/email'); // 이메일 로그인 화면으로 이동
                          },
                        ),
                        // 구글 로그인 버튼
                        _buildLoginButton(
                          icon: Icons.g_mobiledata,
                          onTap: () async {
                            try {
                              // TODO: Firebase 구글 로그인 로직 추가
                              print('구글 로그인');
                              context.go('/');
                            } catch (e) {
                              print('구글 로그인 실패: $e');
                            }
                          },
                        ),
                        // 애플 로그인 버튼
                        _buildLoginButton(
                          icon: Icons.apple,
                          onTap: () async {
                            try {
                              // TODO: Firebase 애플 로그인 로직 추가
                              print('애플 로그인');
                              context.go('/');
                            } catch (e) {
                              print('애플 로그인 실패: $e');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // 로그인 버튼 위젯
  Widget _buildLoginButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 30,
          color: const Color.fromARGB(255, 237, 190, 152),
        ),
      ),
    );
  }

  // 눈동자 각도 계산 함수
  double _calculateEyeAngle() {
    // 화면 중앙에서 터치 위치까지의 각도 계산
    final double centerX = MediaQuery.of(context).size.width / 2;
    final double centerY = MediaQuery.of(context).size.height / 2;
    final double angle = math.atan2(_mouseY - centerY, _mouseX - centerX);
    // 각도를 degree로 변환
    return angle * 180 / math.pi;
  }
}

// 하늘 애니메이션을 그리는 CustomPainter
class _SkyPainter extends CustomPainter {
  final double animationValue;

  _SkyPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // ... 배경 그라데이션
    final Rect rect = Offset.zero & size;
    final Gradient gradient = LinearGradient(
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter,
      colors: const [
        Color.fromARGB(255, 107, 170, 255),
        Color.fromARGB(255, 255, 225, 229),
      ],
      stops: [0.0, animationValue], // 애니메이션 값에 따라 그라데이션 변경
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

// 물결 애니메이션을 그리는 CustomPainter
class _WavePainter extends CustomPainter {
  final double animationValue;

  _WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    // ... (물결 애니메이션 그리기 - 이전 답변의 _WavePainter 참고)
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5) // 물결 색상 설정
      ..style = PaintingStyle.fill;

    final path = Path();

    // 시작점 설정
    path.moveTo(0, size.height / 2);

    // sin 함수를 이용하여 물결 모양 곡선 그림
    for (double x = 0; x <= size.width; x += 10) {
      path.lineTo(
        x,
        size.height / 2 +
            20 * math.sin(x / 20 + animationValue), // 진폭과 주기를 조절하여 모양 변경
      );
    }

    // path를 닫아 도형 완성
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // canvas에 그림
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
