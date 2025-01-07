import 'package:flutter/material.dart';

import 'shopping_page.dart';

class SignUPPage extends StatefulWidget {
  const SignUPPage({super.key});

  @override
  State<SignUPPage> createState() => _SignUPPage();
}

class _SignUPPage extends State<SignUPPage> {

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Account created successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ShoppingPage()),
              );
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  void _validateAndSubmit() {
    if (_formKey.currentState!.validate()) {
      _showDialog();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  if (value[0] != value[0].toUpperCase()) {
                    _showSnackBar('The first letter must be capitalized');
                    return 'The first letter must be capitalized';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _showSnackBar('Please enter your email');
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    _showSnackBar('Email must contain @');
                    return 'Email must contain @';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _showSnackBar('Please enter a password');
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    _showSnackBar('Password must be at least 6 characters');
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration:
                const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    _showSnackBar('Please confirm your password');
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    _showSnackBar('Passwords do not match');
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _validateAndSubmit,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
