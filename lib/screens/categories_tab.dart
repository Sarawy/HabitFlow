import 'package:flutter/material.dart';
import '../models/habit.dart';

class CategoriesTab extends StatelessWidget {
  final List<Habit> habits;
  final Function(String id) onDelete;

  const CategoriesTab({
    super.key,
    required this.habits,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('TODO: Implement Categories UI'),
    );
  }
}


