import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A4D3E),
        title: const Text("الخريطة", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: const Center(
        child: Text("هذه صفحة الخريطة",
            style: TextStyle(fontSize: 20, color: Colors.black54)),
      ),
    );
  }
}
