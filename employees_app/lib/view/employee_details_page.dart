
import 'package:flutter/material.dart';

import '../model/ employee_model.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Employee employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${employee.name}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Username: ${employee.username}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Email: ${employee.email}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}