
import 'package:flutter/material.dart';

import '../model/ employee_model.dart';
import '../service/api_service.dart';
import 'employee_details_page.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final ApiService _apiService = ApiService();
  List<Employee> _employees = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cachedEmployees = await _apiService.getCachedEmployees();
      if (cachedEmployees != null) {
        setState(() {
          _employees = cachedEmployees;
        });
      } else {
        final employees = await _apiService.fetchEmployees();
        setState(() {
          _employees = employees;
        });
        await _apiService.cacheEmployees(employees);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : ListView.builder(
        itemCount: _employees.length,
        itemBuilder: (context, index) {
          final employee = _employees[index];
          return ListTile(
            title: Text(employee.username),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EmployeeDetailScreen(employee: employee),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
