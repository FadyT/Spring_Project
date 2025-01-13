import 'package:flutter/material.dart';
import 'package:employees_app/service/api_service.dart';

import '../model/ employee_model.dart';

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
      home: const EmployeeScreen(),
    );
  }
}

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  final ApiService _apiService = ApiService();
  List<Employee> _employees = [];
  bool _isLoading = false;

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final employees = await _apiService.fetchEmployees();
      setState(() {
        _employees = employees;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee List')),
      body:Center(child: Column(
        children: [
          InkWell(
            onTap: _fetchData,
            child: const Text('  Fetch Employee Data  .' ,
              style: TextStyle(backgroundColor: Colors.blue ,height: 5 , wordSpacing: 4),
            ),
          ),
          if (_isLoading)
            const CircularProgressIndicator()
          else if (_employees.isEmpty)
            const Text('No data available')
          else
            Expanded(
              child: ListView.builder(
                itemCount: _employees.length,
                itemBuilder: (context, index) {
                  final employee = _employees[index];
                  return ListTile(
                    title: Text(employee.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${employee.email}'),
                        Text('Phone: ${employee.phone}'),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      )
    );
  }
}
