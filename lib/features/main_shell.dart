import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dashboard/dashboard_screen.dart';
import 'routine/routine_screen.dart';
import 'study/study_screen.dart';
import 'progress/progress_screen.dart';
import 'journal/journal_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const RoutineScreen(),
    const StudyScreen(),
    const ProgressScreen(),
    const JournalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm_rounded), label: 'Routine'),
          BottomNavigationBarItem(icon: Icon(Icons.book_rounded), label: 'Study'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.edit_note_rounded), label: 'Journal'),
        ],
      ),
    );
  }
}
