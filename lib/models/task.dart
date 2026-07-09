import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;

  String title;

  bool isCompleted;

  DateTime date;

  DateTime? startTime;

  DateTime? endTime;

  DateTime createdAt;

  DateTime? completedAt;

  int streak;

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

      'date': Timestamp.fromDate(date),

      'startTime': startTime == null ? null : Timestamp.fromDate(startTime!),

      'endTime': endTime == null ? null : Timestamp.fromDate(endTime!),

      'createdAt': Timestamp.fromDate(createdAt),

      'completedAt': completedAt == null
          ? null
          : Timestamp.fromDate(completedAt!),

      'streak': streak,

      'lastCompletedDate': lastCompletedDate == null
          ? null
          : Timestamp.fromDate(lastCompletedDate!),
    };
  }

  factory Task.fromFirestore(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,

      date: (json['date'] as Timestamp).toDate(),

      startTime: json['startTime'] != null
          ? (json['startTime'] as Timestamp).toDate()
          : null,
      endTime: json['endTime'] != null
          ? (json['endTime'] as Timestamp).toDate()
          : null,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      completedAt: json['completedAt'] != null
          ? (json['completedAt'] as Timestamp).toDate()
          : null,
      streak: json['streak'] ?? 0,

      lastCompletedDate: json['lastCompletedDate'] != null
          ? (json['lastCompletedDate'] as Timestamp).toDate()
          : null,
    );
  }
}
