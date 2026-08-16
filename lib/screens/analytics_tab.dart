import 'package:flutter/material.dart';
import '../models/habit.dart';

class AnalyticsTab extends StatelessWidget {
  final List<Habit> habits;

  const AnalyticsTab({
    super.key,
    required this.habits,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('TODO: Implement UI'),
    );
  }
}


