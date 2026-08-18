import 'package:flutter/material.dart';
import '../models/habit.dart';

class AddHabitTab extends StatefulWidget {
  final Function(Habit habit) onAdd;

  const AddHabitTab({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddHabitTab> createState() => _AddHabitTabState();
}


class _AddHabitTabState extends State<AddHabitTab> {
  static const List<String> _categories = ['Study', 'Fitness', 'Mindset'];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String? _selectedCategory = _categories.first;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newHabit = Habit(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      category: _selectedCategory!,
    );

    widget.onAdd(newHabit);

    _formKey.currentState!.reset();
    _titleController.clear();
    setState(() {
      _selectedCategory = _categories.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Habit Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Create Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
