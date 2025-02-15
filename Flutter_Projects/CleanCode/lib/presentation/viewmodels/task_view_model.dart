
import 'package:flutter/material.dart';
import '../../domain/usecases/get_tasks_usecase.dart';
import '../../domain/entities/task.dart';

class TaskViewModel extends ChangeNotifier {
  final GetTasksUseCase getTasksUseCase;

  TaskViewModel(this.getTasksUseCase);

  List<Task> tasks = [];
  bool isLoading = false;

  Future<void> fetchTasks() async {
    isLoading = true;
    notifyListeners();
    tasks = await getTasksUseCase();
    isLoading = false;
    notifyListeners();
  }
}