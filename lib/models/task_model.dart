import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String taskId;
  final String title;
  final Timestamp taskDate;
  bool isCompleted;

  TaskModel({
    required this.taskId,
    required this.title,
    required this.taskDate,
    this.isCompleted = false,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['taskId'],
      title: map['title'],
      taskDate: map['taskDate'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'title': title,
      'taskDate': taskDate,
      'isCompleted': isCompleted,
    };
  }
}
