import 'package:flutter/material.dart';
import '../models/habit.dart';
import 'today_tab.dart';
import 'add_habit_tab.dart';
import 'analytics_tab.dart';
import 'categories_tab.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  /// Master list of habits
  late List<Habit> habits;

  @override
  void initState() {
    super.initState();
    // Initialize with 3 dummy items
    habits = [
      Habit(
        id: '1',
        title: 'Morning Meditation',
        category: 'Mindset',
        isCompleted: false,
        streak: 5,
      ),
      Habit(
        id: '2',
        title: 'Read 30 Minutes',
        category: 'Study',
        isCompleted: true,
        streak: 12,
      ),
      Habit(
        id: '3',
        title: 'Gym Workout',
        category: 'Fitness',
        isCompleted: false,
        streak: 3,
      ),
    ];
  }

  /// Toggles the completion status of a habit and updates streak
  void _toggleHabit(String id) {
    setState(() {
      final index = habits.indexWhere((h) => h.id == id);
      if (index != -1) {
        habits[index] = habits[index].copyWith(
          isCompleted: !habits[index].isCompleted,
          streak: habits[index].isCompleted
              ? habits[index].streak - 1
              : habits[index].streak + 1,
        );
      }
    });
  }

  /// Adds a new habit to the list and switches back to Today tab
  void _addHabit(Habit habit) {
    setState(() {
      habits.add(habit);
      _selectedIndex = 0; // Switch back to Today tab
    });
  }

  /// Removes a habit by ID
  void _deleteHabit(String id) {
    setState(() {
      habits.removeWhere((h) => h.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitFlow'),
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Today Tab
          TodayTab(
            habits: habits,
            onToggle: _toggleHabit,
          ),
          // Add Habit Tab
          AddHabitTab(
            onAdd: _addHabit,
          ),
          // Analytics Tab
          AnalyticsTab(
            habits: habits,
          ),
          // Categories Filter Tab
          CategoriesTab(
            habits: habits,
            onDelete: _deleteHabit,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list),
            label: 'Filter',
          ),
        ],
      ),
    );
  }
}

