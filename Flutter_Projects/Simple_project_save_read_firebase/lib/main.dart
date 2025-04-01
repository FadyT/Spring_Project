import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';  // Import this for Firebase initialization

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase before running the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: InputFormPage(),
    );
  }
}

class InputFormPage extends StatefulWidget {
  @override
  _InputFormPageState createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _hobbyController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _saveData() async {
    if (_nameController.text.isNotEmpty && _ageController.text.isNotEmpty && _hobbyController.text.isNotEmpty) {
      await _firestore.collection('users').add({
        'name': _nameController.text,
        'age': _ageController.text,
        'hobby': _hobbyController.text,
      });
      _nameController.clear();
      _ageController.clear();
      _hobbyController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data saved successfully')));
    }
  }

  void _navigateToDisplayPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DisplayDataPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Info Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name")),
            TextField(controller: _ageController, decoration: InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
            TextField(controller: _hobbyController, decoration: InputDecoration(labelText: "Favorite Hobby")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveData, child: Text("Save Data")),
            ElevatedButton(onPressed: _navigateToDisplayPage, child: Text("View Saved Data")),
          ],
        ),
      ),
    );
  }
}

class DisplayDataPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Data")),
      body: StreamBuilder(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!.docs;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return ListTile(
                title: Text(user['name']),
                subtitle: Text("Age: ${user['age']} | Hobby: ${user['hobby']}"),
              );
            },
          );
        },
      ),
    );
  }
}
