import 'package:flutter/material.dart';
import 'EventsScreen.dart';
import 'home_screen.dart';
import 'challenges_screen.dart';
import 'map_screen.dart';
import 'chat_screen.dart';

class NavigationRoot extends StatefulWidget {
  const NavigationRoot({super.key});

  @override
  State<NavigationRoot> createState() => _NavigationRootState();
}

class _NavigationRootState extends State<NavigationRoot> {
  int index = 3;

  final List<Widget> pages = const [
    ChatScreen(),
    MapScreen(),
    ChallengesScreen(),
    EventsScreen(),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: pages[index],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (i) => setState(() => index = i),
          selectedItemColor: const Color(0xFFC8E677),
          unselectedItemColor: Colors.white,
          backgroundColor: const Color(0xFF1A4D3E),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: "التواصل",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: "الخريطة",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              label: "التحديات",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "الفعاليات",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "الرئيسية",
            ),
          ],
        ),
      ),
    );
  }
}
