import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'EmployeeProfilePage.dart';
import 'LoginPage.dart'; // Assuming you have a LoginPage in your project

class AdminPanelPage extends StatefulWidget {
  @override
  _AdminPanelPageState createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  final latController = TextEditingController();
  final longController = TextEditingController();

  // Logout function
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void updateOfficeLocation() async {
    await FirebaseFirestore.instance.collection('settings').doc('office_location').set({
      'latitude': double.parse(latController.text),
      'longitude': double.parse(longController.text),
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Location Updated")));
  }

  Stream<QuerySnapshot> get employeeStream =>
      FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'employee').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: logout, // Call logout on button press
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: latController, decoration: InputDecoration(labelText: 'Latitude')),
            TextField(controller: longController, decoration: InputDecoration(labelText: 'Longitude')),
            ElevatedButton(onPressed: updateOfficeLocation, child: Text('Update Location')),
            SizedBox(height: 20),
            Text('Employees', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: employeeStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final employees = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final employee = employees[index];
                      return ListTile(
                        title: Text(employee['email']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EmployeeProfilePage(userId: employee.id),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
