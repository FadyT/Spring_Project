import 'package:employees_app/view/employee_list_page.dart';
import 'package:flutter/material.dart';
import 'package:employees_app/view/employee_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Data Fetch',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const EmployeeListScreen(),
    );
  }
}
