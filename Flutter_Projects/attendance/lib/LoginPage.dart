import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AdminPanelPage.dart';
import 'EmployeeProfilePage.dart';
import 'HomePage.dart';
import 'RegisterPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> logIn(BuildContext context) async {
    final navContext = context; // capture context safely

    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final uid = userCredential.user!.uid;

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final role = doc['role'];

      // Safely use captured context for navigation
      if (role == 'admin') {
        Navigator.pushReplacement(
          navContext,
          MaterialPageRoute(builder: (BuildContext context) => AdminPanelPage()),
        );
      } else {
        Navigator.pushReplacement(
          navContext,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        );
      }
    } catch (e) {
      _showError(navContext, e.toString());
    }
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => logIn(context),
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
              },
              child: Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}

