import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/task.dart';
import 'firestore_service.dart';

class TaskService extends ChangeNotifier {
  TaskService({required this.collectionName}) {
    startListening();
  }
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

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
