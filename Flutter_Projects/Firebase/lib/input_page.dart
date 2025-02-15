import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'display_page.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();

  void saveUserData() {
    String name = _nameController.text.trim();
    String age = _ageController.text.trim();
    String hobby = _hobbyController.text.trim();

    if (name.isNotEmpty && age.isNotEmpty && hobby.isNotEmpty) {
      FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'age': age,
        'hobby': hobby,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear input fields
      _nameController.clear();
      _ageController.clear();
      _hobbyController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data saved successfully!"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter User Info")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: _ageController, decoration: InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
            TextField(controller: _hobbyController, decoration: InputDecoration(labelText: "Favorite Hobby")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveUserData, child: Text("Save Data")),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DisplayPage()));
              },
              child: Text("View Data"),
            ),
          ],
        ),
      ),
    );
  }
}
