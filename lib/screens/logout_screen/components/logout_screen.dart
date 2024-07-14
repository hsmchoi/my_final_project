import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // 애니메이션 지속 시간
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // 애니메이션 커브 설정
      ),
    );

    // 화면이 표시된 후 애니메이션 시작
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose(); // 컨트롤러 해제
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
            animation: _rippleAnimation,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // 물결 애니메이션 위젯
                  CustomPaint(
                    painter: _RipplePainter(_rippleAnimation.value),
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                  ),

                  // 애니메이션이 완료된 후 텍스트 표시
                  if (_rippleAnimation.value > 0.7)
                    const Center(
                      child: Text(
                        '오늘 당신의 마음을 움직인 것은 무엇이었나요?',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
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

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('정말 로그아웃 하시겠습니까?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: const Text('로그아웃'),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) context.go('/login');
              },
            ),
          ],
        );
      },
    );
  }
}

// 물결 애니메이션을 그리는 CustomPainter
class _RipplePainter extends CustomPainter {
  final double animationValue;

  _RipplePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5) // 물결 색상 설정
      ..style = PaintingStyle.fill;

    // 화면 중앙에서 시작하여 애니메이션 값에 따라 반지름 증가
    final radius = size.width * animationValue;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // 애니메이션 값이 변경될 때마다 다시 그림
    return true;
  }
}
