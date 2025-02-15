
import '../repositories/task_repository.dart';

import '../entities/task.dart';

class TaskRepositoryImpl implements TaskRepository {
  @override
  Future<List<Task>> getTasks() async {
    await Future.delayed(const Duration(seconds: 1));
    return [Task("Task 1"), Task("Task 2"), Task("Task 3")];
  }
}