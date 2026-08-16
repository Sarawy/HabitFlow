import 'package:flutter/material.dart';
import '../models/habit.dart';

class AddHabitTab extends StatelessWidget {
  final Function(Habit habit) onAdd;

  const AddHabitTab({
    super.key,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('TODO: Implement UI'),
    );
  }
}


