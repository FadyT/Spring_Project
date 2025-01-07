import 'package:flutter/material.dart';
import 'package:storeapp/sign_up_page.dart';

import 'shopping_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SignUPPage(),
    );
  }
}

