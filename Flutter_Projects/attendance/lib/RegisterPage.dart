import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'HomePage.dart';
import 'AdminPanelPage.dart'; // Make sure you have this imported

class RegisterPage extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String role = "employee"; // default role

  RegisterPage({super.key});

  // Registration Function
  Future<void> register(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = userCredential.user;

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'email': emailController.text.trim(),
        'name': nameController.text.trim(),
        'role': role, // use role directly
      });

      _navigateBasedOnRole(user.uid, context); // Navigate based on role
    } catch (e) {
      _showError(context, e.toString()); // Show error dialog
    }
  }

  // Check the role and navigate accordingly
  Future<void> _navigateBasedOnRole(String uid, BuildContext context) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final role = doc['role'];

    if (role == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPanelPage()), // Admin Panel
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()), // HomePage for employee
      );
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Registration Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
            DropdownButtonFormField<String>(
              value: role,
              decoration: const InputDecoration(labelText: 'Role'),
              items: ['admin', 'employee']
                  .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                  .toList(),
              onChanged: (value) => role = value ?? 'employee',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => register(context), // Pass context
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
