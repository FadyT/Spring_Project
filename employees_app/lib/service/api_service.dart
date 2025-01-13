import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/ employee_model.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/users';
  final Dio _dio = Dio();

  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await _dio.get(_baseUrl);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Employee.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load employee data');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  Future<void> cacheEmployees(List<Employee> employees) async {
    final prefs = await SharedPreferences.getInstance();
    final employeeJson = jsonEncode(employees.map((e) => e.toJson()).toList());
    await prefs.setString('cached_employees', employeeJson);
  }

  Future<List<Employee>?> getCachedEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final employeeJson = prefs.getString('cached_employees');
    if (employeeJson != null) {
      final List<dynamic> data = jsonDecode(employeeJson);
      return data.map((e) => Employee.fromJson(e)).toList();
    }
    return null;
  }
}
