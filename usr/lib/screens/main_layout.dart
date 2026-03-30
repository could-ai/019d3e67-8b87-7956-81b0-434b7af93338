import 'package:flutter/material.dart';
import 'package:couldai_user_app/screens/dashboard_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // Placeholder screens for other tabs
  final List<Widget> _screens = [
    const DashboardScreen(),
    const Center(child: Text('Team Directory', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))),
    const Center(child: Text('Performance Reviews', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))),
    const Center(child: Text('Settings', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 16,
        shadowColor: Colors.black12,
        indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: Color(0xFF4F46E5)),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people, color: Color(0xFF4F46E5)),
            label: 'Team',
          ),
          NavigationDestination(
            icon: Icon(Icons.assessment_outlined),
            selectedIcon: Icon(Icons.assessment, color: Color(0xFF4F46E5)),
            label: 'Reviews',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Color(0xFF4F46E5)),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
