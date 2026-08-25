import 'package:flutter/material.dart';
import '../database/database_helper.dart';
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

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  /// Master list of habits, loaded from SQLite
  List<Habit> habits = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadHabits();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Reload when the app resumes so a new day's checkbox state refreshes.
    if (state == AppLifecycleState.resumed) {
      _loadHabits();
    }
  }

  /// Loads all habits from the database into the local list
  Future<void> _loadHabits() async {
    final loadedHabits = await DatabaseHelper.instance.getHabits();

    if (!mounted) return;

    setState(() {
      habits = loadedHabits;
    });
  }

  /// Toggles today's completion for a habit, then reloads habits/streaks
  void _toggleHabit(String id) async {
    final index = habits.indexWhere((h) => h.id == id);
    if (index == -1) return;

    if (habits[index].isCompleted) {
      await DatabaseHelper.instance.uncompleteHabitToday(id);
    } else {
      await DatabaseHelper.instance.completeHabitToday(id);
    }

    await _loadHabits();
  }

  /// Adds a new habit to the database and switches back to Today tab
  void _addHabit(Habit habit) async {
    await DatabaseHelper.instance.insertHabit(habit);
    await _loadHabits();

    if (!mounted) return;

    setState(() {
      _selectedIndex = 0; // Switch back to Today tab
    });
  }

  /// Removes a habit by ID
  void _deleteHabit(String id) async {
    await DatabaseHelper.instance.deleteHabit(id);
    await _loadHabits();
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

