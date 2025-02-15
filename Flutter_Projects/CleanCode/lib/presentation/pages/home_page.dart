
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_view_model.dart';
import '../../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<TaskViewModel>()..fetchTasks(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Task List")),
        body: Consumer<TaskViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: viewModel.tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(viewModel.tasks[index].title),
                );
              },
            );
          },
        ),
      ),
    );
  }
}