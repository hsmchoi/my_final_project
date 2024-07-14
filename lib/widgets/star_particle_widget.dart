//custom_widget/star_particle_widget.dart

import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final starParticleProvider = StateNotifierProvider<StarParticleNotifier, bool>(
    (ref) => StarParticleNotifier());

class StarParticleNotifier extends StateNotifier<bool> {
  StarParticleNotifier() : super(false);

  void showAnimation() {
    state = true;
    Future.delayed(const Duration(milliseconds: 300), () {
      state = false;
    });
  }
}

class StarParticleWidget extends ConsumerWidget {
  const StarParticleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showAnimation = ref.watch(starParticleProvider);
    return Visibility(
      visible: showAnimation,
      child: CustomPaint(
        painter: StarParticlePainter(),
        size: Size.infinite,
      ),
    );
  }
}

class StarParticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = Random();
    final particles = List.generate(120, (index) {
      return StarParticle(
        position: Offset(size.width / 2, size.height / 3),
        size: random.nextDouble() * 5.0 + 1.0,
        color: Color.fromRGBO(
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
          1.0,
        ),
        speed: Offset(
          (random.nextDouble() - 0.5) * 50,
          (random.nextDouble() - 0.5) * 50,
        ),
      );
    });

    // Update and draw particles
    for (var particle in particles) {
      particle.update(size);
      final paint = Paint()
        ..color = particle.color
        ..strokeWidth = particle.size;
      canvas.drawPoints(PointMode.points, [particle.position], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class StarParticle {
  Offset position;
  double size;
  Color color;
  Offset speed;

  StarParticle({
    required this.position,
    required this.size,
    required this.color,
    required this.speed,
  });

  void update(Size screenSize) {
    position += speed;
    // Bounce off edges
    if (position.dx < 0 || position.dx > screenSize.width) {
      speed = Offset(-speed.dx, speed.dy);
    }
    if (position.dy < 0 || position.dy > screenSize.height) {
      speed = Offset(speed.dx, -speed.dy);
    }
  }
}
