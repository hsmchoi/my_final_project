import 'dart:math';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    // 애니메이션 컨트롤러 초기화
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // 애니메이션 지속 시간 설정
    );

    // Opacity 애니메이션 정의
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // 애니메이션 커브 설정
      ),
    );

    // 물결 애니메이션 정의 (0부터 2*pi까지 반복)
    _waveAnimation = Tween<double>(begin: 0.0, end: 2 * 3.141592).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear, // 선형 애니메이션 커브 설정
      ),
    );

    // 화면이 표시된 후 애니메이션 시작
    _animationController.forward();
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.indigo],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Opacity 애니메이션을 적용한 입력 필드
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0), // 아이콘 아래쪽 여백
                    child: Image.network(
                      'https://github.com/hsmchoi/my_final_project/blob/main/assets/images/app_icon.png', // 실제 아이콘 파일 경로로 수정
                      width: 100, // 아이콘 크기 조정
                      height: 100,
                    ),
                  ),
                  Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: '이메일',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: _opacityAnimation.value,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: '비밀번호',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  // TODO: 로그인 버튼 추가
                  const SizedBox(height: 50.0), // 간격 조정

                  // 물결 애니메이션 위젯
                  CustomPaint(
                    painter: _WavePainter(_waveAnimation.value),
                    size: Size(MediaQuery.of(context).size.width, 100),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// 물결 애니메이션을 그리는 CustomPainter
class _WavePainter extends CustomPainter {
  final double animationValue;

  _WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
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
            20 * sin(x / 20 + animationValue), // 진폭과 주기를 조절하여 모양 변경
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
    // 애니메이션 값이 변경될 때마다 다시 그림
    return true;
  }
}
