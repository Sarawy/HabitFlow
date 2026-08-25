import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/habit.dart';

/// Simple SQLite helper for persisting habits and their daily completions.
class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'habitflow.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE habits(
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            category TEXT NOT NULL,
            isCompleted INTEGER NOT NULL,
            streak INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE habit_completions(
            habit_id TEXT NOT NULL,
            completion_date TEXT NOT NULL,
            PRIMARY KEY (habit_id, completion_date)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE habit_completions(
              habit_id TEXT NOT NULL,
              completion_date TEXT NOT NULL,
              PRIMARY KEY (habit_id, completion_date)
            )
          ''');
        }
      },
    );
  }

  /// Formats a date as YYYY-MM-DD using local time, no `intl` needed.
  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _todayString() => _formatDate(DateTime.now());

  /// Inserts a new habit into the database
  Future<void> insertHabit(Habit habit) async {
    final db = await database;
    await db.insert(
      'habits',
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Returns all habits, with isCompleted/streak computed from
  /// habit_completions rather than the stored habits columns.
  Future<List<Habit>> getHabits() async {
    final db = await database;
    final rows = await db.query('habits');

    final habits = <Habit>[];
    for (final row in rows) {
      final habit = Habit.fromMap(row);
      final completedToday = await isCompletedToday(habit.id);
      final streak = await getStreak(habit.id);
      habits.add(habit.copyWith(isCompleted: completedToday, streak: streak));
    }
    return habits;
  }

  /// Deletes a habit and its completion history
  Future<void> deleteHabit(String id) async {
    final db = await database;
    await db.delete(
      'habit_completions',
      where: 'habit_id = ?',
      whereArgs: [id],
    );
    await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Marks a habit as completed for today (no-op if already completed)
  Future<void> completeHabitToday(String habitId) async {
    final db = await database;
    await db.insert(
      'habit_completions',
      {'habit_id': habitId, 'completion_date': _todayString()},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Removes today's completion for a habit
  Future<void> uncompleteHabitToday(String habitId) async {
    final db = await database;
    await db.delete(
      'habit_completions',
      where: 'habit_id = ? AND completion_date = ?',
      whereArgs: [habitId, _todayString()],
    );
  }

  /// Whether a habit has a completion recorded for today
  Future<bool> isCompletedToday(String habitId) async {
    final db = await database;
    final rows = await db.query(
      'habit_completions',
      where: 'habit_id = ? AND completion_date = ?',
      whereArgs: [habitId, _todayString()],
    );
    return rows.isNotEmpty;
  }

  /// Calculates the current streak by counting consecutive completed days
  /// backwards from today (or from yesterday if today isn't completed yet).
  Future<int> getStreak(String habitId) async {
    final db = await database;
    final rows = await db.query(
      'habit_completions',
      columns: ['completion_date'],
      where: 'habit_id = ?',
      whereArgs: [habitId],
    );
    final completedDates = rows.map((r) => r['completion_date'] as String).toSet();

    var cursor = DateTime.now();
    if (!completedDates.contains(_formatDate(cursor))) {
      cursor = _previousDay(cursor);
    }

    var streak = 0;
    while (completedDates.contains(_formatDate(cursor))) {
      streak++;
      cursor = _previousDay(cursor);
    }
    return streak;
  }

  DateTime _previousDay(DateTime date) {
    return DateTime(date.year, date.month, date.day - 1);
  }
}
