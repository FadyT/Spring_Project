import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'AbsenceCalculator.dart';

class EmployeeProfilePage extends StatefulWidget {
  final String userId;

  const EmployeeProfilePage({super.key, required this.userId});

  @override
  EmployeeProfilePageState createState() => EmployeeProfilePageState();
}
class EmployeeProfilePageState extends State<EmployeeProfilePage> {
  late Stream<QuerySnapshot> _checkInsStream;
  late Stream<QuerySnapshot> _checkOutsStream;
  int? absenceDays;

  @override
  void initState() {
    super.initState();

    // Use widget.userId correctly
    _checkInsStream = FirebaseFirestore.instance
        .collection('attendance')  // Assuming attendance collection for check-ins
        .where('user_id', isEqualTo: widget.userId)
        .where('type', isEqualTo: 'check_in')  // Ensure we filter by type for check-out
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .orderBy('timestamp', descending: true)
        .snapshots();

    _checkOutsStream = FirebaseFirestore.instance
        .collection('attendance')  // Assuming attendance collection for check-outs too (or a separate one)
        .where('user_id', isEqualTo: widget.userId)
        .where('type', isEqualTo: 'check_out')  // Ensure we filter by type for check-out
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
        .orderBy('timestamp', descending: true)
        .snapshots();

    _calculateEmployeeAbsence(widget.userId);
  }

  // Calculate Absence Days
  void _calculateEmployeeAbsence(String userId) async {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, 1, 1);
    DateTime endDate = now;

    AbsenceCalculator calculator = AbsenceCalculator();
    int absenceCount = await calculator.calculateAbsence(userId, startDate, endDate);

    if (mounted) {
      setState(() {
        absenceDays = absenceCount;
      });
    }

    print('Employee absence days for ${now.year}: $absenceCount');
  }

  // Format Timestamp
  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate().toLocal();
    final format = DateFormat("MMMM d, yyyy 'at' h:mm:ss a");
    return format.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            absenceDays == null
                ? const Center(child: CircularProgressIndicator())
                : Text(
              'Absence Days: $absenceDays',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            const Text(
              'Check-in Days',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _checkInsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final checkIns = snapshot.data?.docs ?? [];

                if (checkIns.isEmpty) {
                  return const Center(child: Text('No check-ins found.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: checkIns.length,
                  itemBuilder: (context, index) {
                    final checkIn = checkIns[index];
                    final timestamp = checkIn['timestamp'] as Timestamp;
                    final formattedDate = _formatTimestamp(timestamp);

                    return ListTile(
                      title: Text(formattedDate),
                      leading: const Icon(Icons.access_time),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),
            const Text(
              'Check-out Days',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _checkOutsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final checkOuts = snapshot.data?.docs ?? [];

                if (checkOuts.isEmpty) {
                  return const Center(child: Text('No check-outs found.'));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: checkOuts.length,
                  itemBuilder: (context, index) {
                    final checkOut = checkOuts[index];
                    final timestamp = checkOut['timestamp'] as Timestamp;
                    final formattedDate = _formatTimestamp(timestamp);

                    return ListTile(
                      title: Text(formattedDate),
                      leading: const Icon(Icons.exit_to_app),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
