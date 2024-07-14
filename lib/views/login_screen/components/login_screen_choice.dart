// //login_screen_choice.dart

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import '../../../custom_widgets/custom_background.dart'; // 커스텀 배경 위젯 import

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // 커스텀 배경 위젯 추가
//           const CustomBackground(),
//           // 로그인 버튼
//           Positioned(
//             bottom: MediaQuery.of(context).size.height * 0.1,
//             left: 0,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // 이메일 로그인 버튼
//                 _buildLoginButton(
//                   icon: Icons.email,
//                   onTap: () {
//                     context.go('/login/email'); // 이메일 로그인 화면으로 이동
//                   },
//                 ),
//                 // 구글 로그인 버튼
//                 _buildLoginButton(
//                   icon: Icons.g_mobiledata,
//                   onTap: () async {
//                     try {
//                       // TODO: Firebase 구글 로그인 로직 추가
//                       print('구글 로그인');
//                       context.go('/');
//                     } catch (e) {
//                       print('구글 로그인 실패: $e');
//                     }
//                   },
//                 ),
//                 // 애플 로그인 버튼
//                 _buildLoginButton(
//                   icon: Icons.apple,
//                   onTap: () async {
//                     try {
//                       // TODO: Firebase 애플 로그인 로직 추가
//                       print('애플 로그인');
//                       context.go('/');
//                     } catch (e) {
//                       print('애플 로그인 실패: $e');
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // 로그인 버튼 위젯
//   Widget _buildLoginButton(
//       {required IconData icon, required VoidCallback onTap}) {
//     return GestureDetector(
//       onTap: onTap,
      
//       child: Container(
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           shape: BoxShape.circle,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Icon(
//           icon,
//           size: 30,
//           color: const Color.fromARGB(255, 237, 190, 152),
//         ),
//       ),
//     );
//   }
// }
