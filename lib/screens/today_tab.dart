import 'package:flutter/material.dart';
import '../models/habit.dart';

class TodayTab extends StatelessWidget {
  final List<Habit> habits;
  final Function(String id) onToggle;

  const TodayTab({
    super.key,
    required this.habits,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('TODO: Implement UI'),
    );
  }
}


