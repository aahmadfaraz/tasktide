import 'package:flutter/material.dart';
import '../api/post_repo.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final PostRepo _postRepo = PostRepo();
  List<TaskModel> _tasks = [];
  List<TaskModel> _localTasks = [];
  bool _addLoading = false;
  bool _getLoading = false;
  bool _updateLoading = false;

  List<TaskModel> get tasks => _tasks;
  List<TaskModel> get localTasks => _localTasks;
  bool get addLoading => _addLoading;
  bool get getLoading => _getLoading;
  bool get updateLoading => _updateLoading;

  Future<void> addTask(TaskModel task) async {
    _addLoading = true;
    notifyListeners();
    await _postRepo.addTaskToFirestore(task);
    _localTasks.add(task);
    _addLoading = false;
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
    _updateLoading = true;
    notifyListeners();
    await _postRepo.updateTaskInFirestore(task);
    _updateLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(String taskId) async {
    await _postRepo.deleteTaskFromFirestore(taskId);
    notifyListeners();
  }
}
