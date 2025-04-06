import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AbsenceCalculator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch the holidays from Firestore
  Future<List<DateTime>> _getHolidays() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('holidays').get();
      List<DateTime> holidays = snapshot.docs.map((doc) {
        return DateTime.parse(doc['date']);
      }).toList();
      return holidays;
    } catch (e) {
      print('Error fetching holidays: $e');
      return [];
    }
  }

  // Calculate the number of absence days
  Future<int> calculateAbsence(String userId, DateTime startDate, DateTime endDate) async {
    List<DateTime> holidays = await _getHolidays();
    int absenceCount = 0;

    // Iterate through the days in the range and check if the employee has checked in
    DateTime currentDay = startDate;

    while (currentDay.isBefore(endDate) || currentDay.isAtSameMomentAs(endDate)) {
      // Skip weekends (Friday and Saturday)
      if (currentDay.weekday == DateTime.friday || currentDay.weekday == DateTime.saturday) {
        currentDay = currentDay.add(Duration(days: 1));
        continue;
      }

      // Check if the current day is a holiday
      bool isHoliday = holidays.any((holiday) => holiday.year == currentDay.year && holiday.month == currentDay.month && holiday.day == currentDay.day);
      if (isHoliday) {
        currentDay = currentDay.add(Duration(days: 1));
        continue;
      }

      // Fetch the employee's check-in data for the current day
      QuerySnapshot attendanceSnapshot = await _firestore
          .collection('attendance')
          .where('user_id', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(currentDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(currentDay.add(Duration(days: 1))))
          .get();

      // If no check-in found for the current day, it is considered an absence
      if (attendanceSnapshot.docs.isEmpty) {
        absenceCount++;
      }

      currentDay = currentDay.add(Duration(days: 1)); // Move to the next day
    }

    return absenceCount;
  }
}
