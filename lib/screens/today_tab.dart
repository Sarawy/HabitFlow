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
    if (habits.isEmpty) {
      return const Center(
        child: Text(
          'No habits for today. Add one!',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: CheckboxListTile(
            value: habit.isCompleted,
            onChanged: (_) {
              onToggle(habit.id);
            },
            title: Text(
              habit.title,
              style: TextStyle(
                decoration: habit.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(
              '🔥 ${habit.streak} days',
            ),
          ),
        );
      },
    );
  }
}