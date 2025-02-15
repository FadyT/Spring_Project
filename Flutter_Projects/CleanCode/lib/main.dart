// main.dart
import 'package:cleancode/presentation/viewmodels/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'domain/repositories/task_repository_impl.dart';
import 'domain/usecases/get_tasks_usecase.dart';
import 'presentation/pages/home_page.dart';
import 'domain/repositories/task_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl());
  getIt.registerLazySingleton(() => GetTasksUseCase(getIt<TaskRepository>()));
  getIt.registerFactory(() => TaskViewModel(getIt<GetTasksUseCase>()));
}

void main() {
  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}