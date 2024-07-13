import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// 이미지 표시 위젯 (Firebase Storage에서 이미지 로드)
class ImageWidget extends StatelessWidget {
  final String imageUrl;

  const ImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

// 로딩 표시 위젯
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

// 에러 표시 위젯
class ErrorWidget extends StatelessWidget {
  final String message;

  const ErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
}

// 별똥별 입자를 나타내는 클래스
class StarParticle {
  // 위치, 크기, 색상, 속도, 애니메이션 진행 상태를 저장하는 변수
  Offset position;
  double size;
  Color color;
  Offset speed;
  double animationProgress;

  // 생성자
  StarParticle({
    required this.position,
    required this.size,
    required this.color,
    required this.speed,
    this.animationProgress = 0.0, // 초기 애니메이션 진행 상태는 0.0
  });

  // 별똥별 입자를 업데이트하는 메서드
  void update(Size screenSize, double animationValue) {
    // 애니메이션 진행 상태 업데이트
    animationProgress = animationValue;

    // 화면 경계를 넘어가면 반대쪽에서 나타나도록 위치 조정
    if (position.dx < 0 || position.dx > screenSize.width) {
      speed = Offset(-speed.dx, speed.dy); // x축 방향 반전
    }
    if (position.dy < 0 || position.dy > screenSize.height) {
      speed = Offset(speed.dx, -speed.dy); // y축 방향 반전
    }

    // 위치 업데이트
    position += speed * animationValue;

    // 크기 업데이트 (애니메이션 진행에 따라 크기 감소)
    size = (1 - animationValue) * 5.0 + 1.0; // 애니메이션 진행에 따라 5.0에서 1.0으로 크기 감소
  }
}
