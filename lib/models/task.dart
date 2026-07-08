import 'package:hive_ce/hive.dart';

class Task extends HiveObject {
  String id;

  String title;

  bool isCompleted;

  DateTime date;

  DateTime? startTime;

  DateTime? endTime;

  DateTime createdAt;

  DateTime? completedAt;

  @HiveField(8)
  int streak;

  @HiveField(9)
  DateTime? lastCompletedDate;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.createdAt,
    this.startTime,
    this.endTime,
    this.completedAt,
    this.isCompleted = false,

    this.streak = 0,
    this.lastCompletedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'date': date.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,

      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),

      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'])
          : null,

      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,

      createdAt: DateTime.parse(json['createdAt']),

      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
    );
  }
}
