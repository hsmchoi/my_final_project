//views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/repositories/authentication_repository.dart';
import 'package:my_final_project/view_models/home_view_model.dart';
import 'package:my_final_project/widgets/custom_background.dart';
import 'package:my_final_project/widgets/star_particle_widget.dart';
import 'package:my_final_project/widgets/wave_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Heraclitus\' Flow'),
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              // 로그아웃 후 로그인 화면으로 이동
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Custom Background
          const CustomBackground(),
          // Wave Animation
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: WaveWidget(),
          ),

          // Question Card
          Positioned(
            top: 100,
            child: GestureDetector(
              onTap: () {
                homeViewModel.nextQuestion();
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    homeViewModel.currentQuestion,
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

          // Answer Input Field
          Positioned(
            top: 250,
            left: MediaQuery.of(context).size.width * 0.1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  TextField(
                    controller: _answerController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your reflection...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 16.0, color: Colors.black),
                    maxLines: null,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_answerController.text.isNotEmpty) {
                        await homeViewModel.saveAnswer(_answerController.text);
                        _answerController.clear();
                        homeViewModel.nextQuestion();
                        // Show star particle animation
                        ref.read(starParticleProvider.notifier).showAnimation();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
          // Star Particle Widget
          const StarParticleWidget(),
        ],
      ),
    );
  }
}
