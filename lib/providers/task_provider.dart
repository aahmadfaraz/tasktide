import 'package:flutter/material.dart';
import '../api/post_repo.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final PostRepo _postRepo = PostRepo();
  List<TaskModel> _tasks = [];
  List<TaskModel> _localTasks = [];
  bool _getLoading = false;

  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get localTasks => _localTasks;
  bool get getLoading => _getLoading;

  Future<void> addTask(TaskModel task) async {
    final addedTask = await _postRepo.addTaskToFirestore(task);
    if (addedTask != null) {
      _localTasks.add(addedTask);
    }
    notifyListeners();
  }

  Future<void> getTasks() async {
    _getLoading = true;
    notifyListeners();
    final myTasks = await _postRepo.getAllTasks();
    _tasks = myTasks;
    _getLoading = false;
    notifyListeners();
  }

  Future<void> toggleTaskStatus(String taskId, bool isCompleted) async {
    await _postRepo.toggleTaskStatus(taskId, isCompleted);
    notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    await _postRepo.updateTaskInFirestore(task);
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    await _postRepo.deleteTaskFromFirestore(taskId);
    notifyListeners();
  }
}
