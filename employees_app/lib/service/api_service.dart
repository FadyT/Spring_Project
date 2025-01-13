import 'package:dio/dio.dart';

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
}
