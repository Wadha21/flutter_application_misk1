import 'package:flutter/material.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07856),
        title: const Text("التحديات", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "هذه صفحة التحديات",
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ),
    );
  }
}
