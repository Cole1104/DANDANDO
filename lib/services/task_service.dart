import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/task.dart';
import 'firestore_service.dart';

class TaskService extends ChangeNotifier {
  TaskService({required this.collectionName});

  final String collectionName;
  final FirestoreService _firestore = FirestoreService();
  StreamSubscription<List<Task>>? _subscription;
  List<Task> _tasks = [];
  List<Task> get tasks => List.unmodifiable(_tasks);
  DateTime selectedDate = DateTime.now();

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  void startListening() {
    _subscription?.cancel();

    _subscription = _firestore.getTasks(collectionName).listen((tasks) {
      print("Firestore에서 ${tasks.length}개 받음");
      _tasks = tasks;

      _tasks.sort((a, b) {
        if (a.startTime == null && b.startTime == null) return 0;
        if (a.startTime == null) return 1;
        if (b.startTime == null) return -1;

        return a.startTime!.compareTo(b.startTime!);
      });

      notifyListeners();
    });
  }

  List<Task> get tasksForSelectedDate {
    return _tasks.where((task) {
      return task.date.year == selectedDate.year &&
          task.date.month == selectedDate.month &&
          task.date.day == selectedDate.day;
    }).toList();
  }

  bool hasTaskOnDate(DateTime date) {
    return _tasks.any((task) {
      return task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day;
    });
  }

  double get completionRate {
    if (_tasks.isEmpty) return 0;

    final completed = _tasks.where((e) => e.isCompleted).length;
    return completed / _tasks.length;
  }

  Future<void> addTask(
    String title,
    DateTime date,
    DateTime? startTime,
    DateTime? endTime,
  ) async {
    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      date: date,
      createdAt: DateTime.now(),
      startTime: startTime,
      endTime: endTime,
    );

    await _firestore.addTask(collectionName, task);
  }

  Future<void> updateTask(
    Task task,
    String title,
    DateTime date,
    DateTime? startTime,
    DateTime? endTime,
  ) async {
    task.title = title;
    task.date = date;
    task.startTime = startTime;
    task.endTime = endTime;

    await _firestore.updateTask(collectionName, task);
  }

  Future<void> deleteTask(Task task) async {
    await _firestore.deleteTask(collectionName, task.id);
  }

  Future<void> toggleTask(Task task) async {
    final wasCompleted = task.isCompleted;

    task.isCompleted = !task.isCompleted;

    if (collectionName == "recurring_tasks") {
      if (!wasCompleted && task.isCompleted) {
        final today = DateTime.now();

        if (task.lastCompletedDate == null) {
          task.streak = 1;
        } else {
          final last = task.lastCompletedDate!;

          final difference = DateTime(
            today.year,
            today.month,
            today.day,
          ).difference(DateTime(last.year, last.month, last.day)).inDays;

          if (difference == 1) {
            task.streak++;
          } else if (difference > 1) {
            task.streak = 1;
          }
        }

        task.lastCompletedDate = today;
      }
    }

    await _firestore.updateTask(collectionName, task);
  }

  Future<void> resetDailyRoutineIfNeeded() async {
    if (collectionName != "recurring_tasks") return;

    final today = DateTime.now();

    for (final task in _tasks) {
      final last = task.lastCompletedDate;

      if (last == null) {
        task.isCompleted = false;
        await _firestore.updateTask(collectionName, task);
        continue;
      }

      final isToday =
          last.year == today.year &&
          last.month == today.month &&
          last.day == today.day;

      if (!isToday) {
        task.isCompleted = false;
        await _firestore.updateTask(collectionName, task);
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
