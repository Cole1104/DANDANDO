import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive.dart';
import '../models/task.dart';

class TaskService extends ChangeNotifier {
  final String storageKey;

  TaskService({this.storageKey = "tasks"});

  late Box<Task> _box;

  DateTime selectedDate = DateTime.now();

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  List<Task> get tasksForSelectedDate {
    final tasks = _box.values.where((task) {
      return task.date.year == selectedDate.year &&
          task.date.month == selectedDate.month &&
          task.date.day == selectedDate.day;
    }).toList();

    tasks.sort((a, b) {
      if (a.startTime == null && b.startTime == null) return 0;
      if (a.startTime == null) return 1;
      if (b.startTime == null) return -1;

      return a.startTime!.compareTo(b.startTime!);
    });

    return tasks;
  }

  List<Task> get tasks {
    final list = _box.values.toList();

    list.sort((a, b) {
      if (a.startTime == null && b.startTime == null) return 0;
      if (a.startTime == null) return 1;
      if (b.startTime == null) return -1;

      return a.startTime!.compareTo(b.startTime!);
    });

    return list;
  }

  bool hasTaskOnDate(DateTime date) {
    return _box.values.any((task) {
      return task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day;
    });
  }

  Future<void> init() async {
    debugPrint("Opening box : $storageKey");

    _box = await Hive.openBox<Task>(storageKey);

    debugPrint("Opened : ${_box.name}");

    await loadTasks();
  }

  Future<void> loadTasks() async {
    debugPrint("[$storageKey] loaded ${_box.length} tasks");

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

    await _box.add(task);
    debugPrint("[$storageKey] box length = ${_box.length}");

    debugPrint("box path: ${_box.path}");
    debugPrint("box length: ${_box.length}");

    notifyListeners();
  }

  Future<void> deleteTask(Task task) async {
    await task.delete();

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

    await task.save();

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

    await task.save();

    notifyListeners();
  }

  Future<void> resetDailyRoutineIfNeeded() async {
    if (storageKey != "recurring_tasks") return;

    final today = DateTime.now();

    for (final task in _box.values) {
      final last = task.lastCompletedDate;

      if (last == null) {
        task.isCompleted = false;

        await task.save();

        continue;
      }

      final isToday =
          last.year == today.year &&
          last.month == today.month &&
          last.day == today.day;

      if (!isToday) {
        task.isCompleted = false;

        await task.save();
      }
    }

    notifyListeners();
  }

  double get completionRate {
    final list = _box.values.toList();

    if (list.isEmpty) return 0;

    final completed = list.where((e) => e.isCompleted).length;

    return completed / list.length;
  }
}
