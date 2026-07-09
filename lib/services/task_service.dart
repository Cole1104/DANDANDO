import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TaskService extends ChangeNotifier {
  final String storageKey;

  TaskService({this.storageKey = "tasks"});

  DateTime selectedDate = DateTime.now();

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  List<Task> get tasksForSelectedDate {
    final tasks = <Task>[];

    tasks.sort((a, b) {
      if (a.startTime == null && b.startTime == null) return 0;
      if (a.startTime == null) return 1;
      if (b.startTime == null) return -1;

      return a.startTime!.compareTo(b.startTime!);
    });

    return tasks;
  }

  List<Task> get tasks {
    final list = <Task>[];

    list.sort((a, b) {
      if (a.startTime == null && b.startTime == null) return 0;
      if (a.startTime == null) return 1;
      if (b.startTime == null) return -1;

      return a.startTime!.compareTo(b.startTime!);
    });

    return list;
  }

  bool hasTaskOnDate(DateTime date) {
    return false;
  }

  Future<void> init() async {
    notifyListeners();
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

    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    notifyListeners();
  }

  Future<void> toggleTask(Task task) async {
    final wasCompleted = task.isCompleted;

    task.isCompleted = !task.isCompleted;

    if (storageKey == "recurring_tasks") {
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
          // difference == 0 이면 같은 날 다시 체크한 것이므로 streak 유지
        }

        task.lastCompletedDate = today;
      }
    }

    notifyListeners();
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

    notifyListeners();
  }

  Future<void> resetDailyRoutineIfNeeded() async {
    if (storageKey != "recurring_tasks") return;

    notifyListeners();
  }

  double get completionRate {
    return 0;
  }
}
