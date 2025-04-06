import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'AbsenceCalculator.dart';  // For date formatting

class EmployeeProfilePage extends StatefulWidget {
  @override
  _EmployeeProfilePageState createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  late Stream<QuerySnapshot> _checkInsStream;
  late Stream<QuerySnapshot> _checkOutsStream;
  int? absenceDays;

  @override
  void initState() {
    super.initState();
    _checkInsStream = FirebaseFirestore.instance
        .collection('attendance')
        .where('user_id', isEqualTo: userId)
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now())) // Ensure only past or present records
        .orderBy('timestamp', descending: true) // Order by most recent
        .snapshots();

    _checkOutsStream = FirebaseFirestore.instance
        .collection('check_out')  // Assuming you have a collection for check-outs
        .where('user_id', isEqualTo: userId)
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .orderBy('timestamp', descending: true)
        .snapshots();

    // Calculate employee absence days on page load
    _calculateEmployeeAbsence(userId);
  }

  // Function to calculate employee absence
  void _calculateEmployeeAbsence(String userId) async {
    // Get the current year
    int currentYear = DateTime.now().year;

    // Starting from January 1st of the current year
    DateTime startDate = DateTime(currentYear, 1, 1);

    // Ending at the current date (not future)
    DateTime endDate = DateTime.now();

    AbsenceCalculator calculator = AbsenceCalculator();
    int absenceCount = await calculator.calculateAbsence(userId, startDate, endDate);

    // Check if the widget is still mounted before calling setState
    if (mounted) {
      setState(() {
        absenceDays = absenceCount;
      });
    }

    print('Employee absence days for $currentYear: $absenceCount');
  }

  // Function to format timestamp
  String _formatTimestamp(Timestamp timestamp) {
    // Format the timestamp to a readable date format
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    final format = DateFormat("MMMM d, yyyy 'at' h:mm:ss a 'UTC+2'");  // Customize the format
    return format.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Profile'),
      ),
      body: SingleChildScrollView(  // Make the entire body scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Absence Days at the top
              absenceDays == null
                  ? CircularProgressIndicator()
                  : Text(
                'Absence Days: $absenceDays',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // Display Check-in List
              Text(
                'Check-in Days',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _checkInsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No check-ins found.'));
                  }

                  final checkIns = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,  // Ensure ListView takes only the necessary space
                    physics: NeverScrollableScrollPhysics(), // Disable ListView scrolling, as the whole page is scrollable
                    itemCount: checkIns.length,
                    itemBuilder: (context, index) {
                      final checkIn = checkIns[index];
                      final timestamp = checkIn['timestamp'] as Timestamp;
                      final formattedDate = _formatTimestamp(timestamp);

                      return ListTile(
                        title: Text(formattedDate),
                        leading: Icon(Icons.access_time),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              // Display Check-out List
              Text(
                'Check-out Days',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _checkOutsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No check-outs found.'));
                  }

                  final checkOuts = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,  // Ensure ListView takes only the necessary space
                    physics: NeverScrollableScrollPhysics(), // Disable ListView scrolling, as the whole page is scrollable
                    itemCount: checkOuts.length,
                    itemBuilder: (context, index) {
                      final checkOut = checkOuts[index];
                      final timestamp = checkOut['timestamp'] as Timestamp;
                      final formattedDate = _formatTimestamp(timestamp);

                      return ListTile(
                        title: Text(formattedDate),
                        leading: Icon(Icons.exit_to_app),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
