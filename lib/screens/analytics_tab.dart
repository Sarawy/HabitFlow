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
    final int totalHabits = habits.length;
    final int completedCount = habits.where((h) => h.isCompleted).length;
    final double completionRate=
        totalHabits > 0 ? completedCount / totalHabits:0.0;
    final int percentage = (completedCount * 100).toInt();

    Habit? bestStreakHabits;
    if (habits.isNotEmpty){
      bestStreakHabits = habits.reduce(
            (curr, next) => curr.streak > next.streak? curr : next,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2,
            child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Completion Rate',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: completionRate,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                        ],
                    ),
                ),
            ),
          const SizedBox(height: 12),

          Card(
              elevation: 2,
              child: ListTile(
                  leading: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 36,
                  ),
                title: const Text('Total Completed'),
                subtitle: Text('$completedCount of $totalHabits habits done'),
              ),
          ),
          const SizedBox(height: 12),

        Card(
          elevation: 2,
          child: ListTile(
            leading: const Icon(
              Icons.local_fire_department,
              color: Colors.orange,
              size: 36,
            ),
            title: const Text('Best Streak'),
            subtitle: Text(
              bestStreakHabits != null && bestStreakHabits.streak > 0
                  ? '${bestStreakHabits.title} (🔥 ${bestStreakHabits.streak} days)'
                  : 'No streaks yet!',
            ),
          ),
        ),
        ],
      ),
    );
  }
}


