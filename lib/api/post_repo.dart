import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/task_model.dart';

class PostRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<TaskModel>> getAllTasks() async {
    try {
      final QuerySnapshot taskSnapshot =
          await _firestore.collection('tasks').get();

      final List<TaskModel> tasks = taskSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return TaskModel(
          taskId: doc.id,
          title: data['title'] as String,
          taskDate: data['taskDate'],
          isCompleted: data['isCompleted'] as bool,
        );
      }).toList();

      return tasks;
    } catch (e) {
      if (kDebugMode) print('Error fetching tasks: $e');
      return [];
    }
  }

  Future<void> addTaskToFirestore(TaskModel task) async {
    try {
      final DocumentReference documentRef =
          await _firestore.collection("tasks").add({});
      await _firestore.collection('tasks').doc(documentRef.id).set({
        'taskId': documentRef.id,
        'title': task.title,
        'taskDate': task.taskDate,
        'isCompleted': task.isCompleted,
      });
    } catch (e) {
      if (kDebugMode) print('Error adding task to Firestore: $e');
    }
  }

  Future<void> updateTaskInFirestore(TaskModel task) async {
    try {
      await _firestore.collection('tasks').doc(task.taskId).update({
        'title': task.title,
        'taskDate': task.taskDate,
        'isCompleted': task.isCompleted,
      });
    } catch (e) {
      if (kDebugMode) print('Error updating task in Firestore: $e');
    }
  }

  Future<void> toggleTaskStatus(String taskId, bool isCompleted) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        'isCompleted': isCompleted,
      });
    } catch (e) {
      if (kDebugMode) print('Error updating task in Firestore: $e');
    }
  }

  Future<void> deleteTaskFromFirestore(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      if (kDebugMode) print('Error deleting task from Firestore: $e');
    }
  }
}
