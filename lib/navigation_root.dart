import 'package:flutter/material.dart';
import 'package:flutter_application_1/EventsScreen.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'map_screen.dart';
import 'challenges_screen.dart';

class NavigationRoot extends StatefulWidget {
  const NavigationRoot({super.key});

  @override
  State<NavigationRoot> createState() => _NavigationRootState();
}

class _NavigationRootState extends State<NavigationRoot> {
  int index = 4; 

  final List<Widget> pages = const [
    ChatScreen(),
    MapScreen(),
    ChallengesScreen(),
    EventsScreen(),
    HomePage(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages[index],
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: index,
                onTap: (i) => setState(() => index = i),
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                selectedItemColor: const Color(0xFFA07856),
                unselectedItemColor: Colors.grey.shade400,
                elevation: 0,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_bubble_outline, size: 28),
                    activeIcon: Icon(Icons.chat_bubble, size: 28),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.location_on_outlined, size: 28),
                    activeIcon: Icon(Icons.location_on, size: 28),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.emoji_events_outlined, size: 28),
                    activeIcon: Icon(Icons.emoji_events, size: 28),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month_outlined, size: 28),
                    activeIcon: Icon(Icons.calendar_month, size: 28),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined, size: 28),
                    activeIcon: Icon(Icons.home, size: 28),
                    label: '',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
