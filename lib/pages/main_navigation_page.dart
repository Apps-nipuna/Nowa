import 'package:flutter/material.dart';
import 'package:orsa_3/pages/home_page.dart';
import 'package:orsa_3/pages/projects.dart';
import 'package:orsa_3/pages/events.dart';
import 'package:orsa_3/pages/members.dart';
import 'package:orsa_3/pages/memories_home.dart';
import 'package:nowa_runtime/nowa_runtime.dart';

@NowaGenerated()
class MainNavigationPage extends StatefulWidget {
  @NowaGenerated({'loader': 'auto-constructor'})
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() {
    return _MainNavigationPageState();
  }
}

@NowaGenerated()
class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const Projects(),
    const Events(),
    const Members(),
    const MemoriesHome(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
          items: [
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 0 ? Icons.home : Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(_currentIndex == 1 ? Icons.work : Icons.work_outline),
              label: 'Projects',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 2 ? Icons.event : Icons.event_outlined,
              ),
              label: 'Events',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 3 ? Icons.people : Icons.people_outlined,
              ),
              label: 'Members',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 4
                    ? Icons.photo_library
                    : Icons.photo_library_outlined,
              ),
              label: 'Memories',
            ),
          ],
        ),
      ),
    );
  }
}
