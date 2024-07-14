//views/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_final_project/repositories/authentication_repository.dart';
import 'package:my_final_project/view_models/home_view_model.dart';
import 'package:my_final_project/widgets/custom_background.dart';
import 'package:my_final_project/widgets/star_particle_widget.dart';
import 'package:my_final_project/widgets/wave_widget.dart';
import 'package:go_router/go_router.dart'; // Import go_router

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _answerController = TextEditingController();
  int _selectedIndex = 0; // Add this line

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
        // title: const Text('Heraclitus\' Flow'),
        flexibleSpace: Container(
          // flexibleSpace를 사용하여 그라데이션 적용
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color.fromARGB(255, 239, 248, 255),
                Color.fromARGB(255, 239, 248, 255)
              ], // 원하는 색상으로 변경
            ),
          ),
        ),
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
          // Question and Answer Card
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: GestureDetector(
              onTap: () {
                homeViewModel.nextQuestion();
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: const Color.fromARGB(255, 255, 241, 241),
                child: Padding(
                  padding: const EdgeInsets.all(20.0), // Increase padding
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Question Text
                      Text(
                        homeViewModel.currentQuestion,
                        style: const TextStyle(
                          fontSize: 18.0, // Increase font size
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // Answer Input Field
                      TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your reflection...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(), // Add a border
                        ),
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.black),
                        maxLines: null, // Allow multiple lines
                      ),
                      const SizedBox(height: 10),
                      // Save Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_answerController.text.isNotEmpty) {
                            await homeViewModel.saveAnswer(
                                _answerController.text,
                                homeViewModel
                                    .currentQuestion); // Pass the question content
                            _answerController.clear();
                            // Option 1: Show success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Reflection saved!')),
                            );
                            // Option 2: Load next question
                            // homeViewModel.nextQuestion();
                            // Show star particle animation
                            ref
                                .read(starParticleProvider.notifier)
                                .showAnimation();
                          }
                        },
                        child: const Text('Save🫠'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Star Particle Widget
          const StarParticleWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            const Color.fromARGB(255, 255, 241, 241), // 배경색을 투명하게 설정
        elevation: 0, // 그림자 제거
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0), // 흰색에 50% 투명도 적용
              ),
              child: const Icon(Icons.home, color: Colors.black),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0), // 흰색에 50% 투명도 적용
              ),
              child: const Icon(Icons.article, color: Colors.black),
            ),
            label: 'Posts',
          ),
        ],
        currentIndex: _selectedIndex, // Use _selectedIndex here
        onTap: (index) {
          // Update the state when an item is tapped
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            context.go('/');
          } else if (index == 1) {
            context.go('/posts');
          }
        },
      ),
    );
  }
}
