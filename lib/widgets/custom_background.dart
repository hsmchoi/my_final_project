//custom_widget/custom_background.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomBackground extends StatefulWidget {
  const CustomBackground({super.key});

  @override
  State<CustomBackground> createState() => _CustomBackgroundState();
}

class _CustomBackgroundState extends State<CustomBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sunAnimation;
  late Animation<double> _boatAnimation;
  double _mouseX = 0;
  double _mouseY = 0;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    // Sun animation
    _sunAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Boat animation
    _boatAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Release the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                // Sky Animation
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

                // Boat Animation
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

                // Eye Animation
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
              ],
            );
          },
        ),
      ),
    );
  }

  // Calculate eye angle based on touch position
  double _calculateEyeAngle() {
    final double centerX = MediaQuery.of(context).size.width / 2;
    final double centerY = MediaQuery.of(context).size.height / 2;
    final double angle = math.atan2(_mouseY - centerY, _mouseX - centerX);
    return angle * 180 / math.pi;
  }
}

// Sky Painter
class _SkyPainter extends CustomPainter {
  final double animationValue;

  _SkyPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Gradient gradient = LinearGradient(
      begin: FractionalOffset.topCenter,
      end: FractionalOffset.bottomCenter,
      colors: const [
        Color.fromARGB(255, 107, 170, 255),
        Color.fromARGB(255, 255, 225, 229),
      ],
      stops: [0.0, animationValue], // Gradient changes based on animation value
    );
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
