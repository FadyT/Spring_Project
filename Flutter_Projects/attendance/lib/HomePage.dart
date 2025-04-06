import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'EmployeeProfilePage.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Location location = Location();
  double? latitude;
  double? longitude;
  String? error;
  bool isInsideArea = false;

  final double targetLatitude = 37.4219983;
  final double targetLongitude = -122.084;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          setState(() => error = 'Location services are disabled.');
          return;
        }
      }

      PermissionStatus permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          setState(() => error = 'Location permission denied.');
          return;
        }
      }

      final locData = await location.getLocation();
      double lat = locData.latitude!;
      double lon = locData.longitude!;

      double distance = _calculateDistance(lat, lon, targetLatitude, targetLongitude);

      setState(() {
        latitude = lat;
        longitude = lon;
        isInsideArea = distance <= 15.0;
        error = null;
      });
    } catch (e) {
      setState(() => error = 'Error: $e');
    }
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371000;
    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Save check-in timestamp to Firestore
  Future<void> _checkIn() async {
    if (isInsideArea) {
      try {
        final timestamp = DateTime.now();
        final userDoc = FirebaseFirestore.instance.collection('employees').doc(user!.uid);

        // Check if the user document exists, create it if necessary
        final docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          // Create a new user document if it doesn't exist
          await userDoc.set({
            'uid': user!.uid,
            'name': user!.displayName ?? 'Unknown',
            'email': user!.email ?? 'No email',
            'last_check_in': timestamp,
            'last_check_out': null,
            'profile_picture': user!.photoURL ?? '',
          });
        } else {
          // Update the existing document with the check-in time
          await userDoc.update({
            'last_check_in': timestamp,
          });
        }

        // Add the check-in entry to the attendance collection
        await FirebaseFirestore.instance.collection('attendance').add({
          'user_id': user?.uid,
          'timestamp': timestamp,
          'type': 'check_in',  // Track check-in type
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Check-in successful!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to check-in: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are not inside the designated area!')),
      );
    }
  }

  // Save check-out timestamp to Firestore
  Future<void> _checkOut() async {
    try {
      final timestamp = DateTime.now();
      final userDoc = FirebaseFirestore.instance.collection('employees').doc(user!.uid);

      // Check if the user document exists
      final docSnapshot = await userDoc.get();
      if (docSnapshot.exists) {
        // Update the existing document with the check-out time
        await userDoc.update({
          'last_check_out': timestamp,
        });

        // Add the check-out entry to the attendance collection
        await FirebaseFirestore.instance.collection('attendance').add({
          'user_id': user?.uid,
          'timestamp': timestamp,
          'type': 'check_out',  // Track check-out type
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Check-out successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User document does not exist!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check-out: $e')),
      );
    }
  }

  // Navigate to Employee Profile page
  void _goToEmployeeProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployeeProfilePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomePage - Location Proximity"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => AuthPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: error != null
            ? Text(error!)
            : (latitude == null || longitude == null)
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Latitude: $latitude"),
            Text("Longitude: $longitude"),
            SizedBox(height: 10),
            Text(
              isInsideArea
                  ? "✅ You are inside the area (within 15m)"
                  : "❌ You are outside the area",
              style: TextStyle(
                color: isInsideArea ? Colors.green : Colors.red,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: Text("Refresh Location"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkIn,
              child: Text("Check-in"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkOut,
              child: Text("Check-out"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _goToEmployeeProfile,
              child: Text("View Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
