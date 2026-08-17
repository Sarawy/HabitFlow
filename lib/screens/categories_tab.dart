import 'package:flutter/material.dart';
import '../models/habit.dart';

class CategoriesTab extends StatefulWidget {
  final List<Habit> habits;
  final Function(String id) onDelete;

  const CategoriesTab({
    super.key,
    required this.habits,
    required this.onDelete,
  });

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  String selectedCategory = 'All';

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Study':
        return Icons.menu_book;
      case 'Fitness':
        return Icons.fitness_center;
      case 'Mindset':
        return Icons.self_improvement;
      default:
        return Icons.track_changes;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Study':
        return const Color(0xFF6C63FF);
      case 'Fitness':
        return const Color(0xFF4CAF50);
      case 'Mindset':
        return const Color(0xFFE0A458);
      default:
        return const Color(0xFF6C63FF);
    }
  }


  @override
  Widget build(BuildContext context) {

    final filteredHabits = selectedCategory == 'All'
        ? widget.habits
        : widget.habits
        .where((habit) => habit.category == selectedCategory)
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                    label: Text('All'),
                    selected: selectedCategory == 'All',
                  onSelected: (selected){
                      setState(() {
                        selectedCategory = 'All';

                      });
                  },
                ),
                ChoiceChip(
                  label: Text('Study'),
                  selected: selectedCategory == 'Study',
                  onSelected: (selected){
                    setState(() {
                      selectedCategory = 'Study';
                    });
                  },
                ),
                ChoiceChip(
                  label: Text('Fitness'),
                  selected: selectedCategory == 'Fitness',
                  onSelected: (selected){
                    setState(() {
                      selectedCategory = 'Fitness';
                    });
                  },
                ),
                ChoiceChip(
                  label: Text('Mindset'),
                  selected: selectedCategory == 'Mindset',
                  onSelected: (selected){
                    setState(() {
                      selectedCategory = 'Mindset';
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: filteredHabits.isEmpty
              ? const Center(
            child: Text(
              'No habits in this category',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          )

        :ListView.builder(
            itemCount: filteredHabits.length,
            itemBuilder: (context, index) {

              final habit = filteredHabits[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getCategoryColor(habit.category),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getCategoryIcon(habit.category),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          widget.onDelete(habit.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


