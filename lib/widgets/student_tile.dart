import 'package:flutter/material.dart';
import 'package:teacher_portal/routes/app_routes.dart';

class StudentTile extends StatelessWidget {
  final int index;
  final bool isDayView;
  final int presentCount;
  final int absentCount;
  final ValueChanged<bool>? onToggle; // Nullable for Day View

  const StudentTile({
    super.key,
    required this.index,
    required this.isDayView,
    required this.presentCount,
    required this.absentCount,
    this.onToggle, // Only needed for Day view
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(String.fromCharCode(65 + index)), // A, B, C, etc.
        ),
        title: const Text("Student Name"),
        subtitle: Text("Roll no: 0${index + 1}"),
        trailing: isDayView ? _buildDayViewToggle() : _buildWeekMonthView(),
        onTap: () {
          Navigator.pushNamed(context, '/monthly-attendance');
        },
      ),
    );
  }

  // ✅ Toggle UI for Day View
  Widget _buildDayViewToggle() {
    bool isPresent = presentCount == 1; // If present, toggle ON

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Absent "A" (Glows when absent)
        Text(
          "A",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPresent ? Colors.grey : Colors.red, // Glows when absent
          ),
        ),

        // Toggle Switch (Default OFF)
        Switch(
          value: isPresent,
          onChanged: onToggle,
          activeColor: Colors.blue, // Switch color when ON
        ),

        // Present "P" (Glows when present)
        Text(
          "P",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isPresent ? Colors.blue : Colors.grey, // Glows when present
          ),
        ),
      ],
    );
  }


  // ✅ Data Display for Week/Month View
  Widget _buildWeekMonthView() {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1), // Dark black outline
        borderRadius: BorderRadius.circular(20), // Elliptical shape
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            presentCount.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Container(height: 20, width: 1.5, color: Colors.black), // Black divider
          const SizedBox(width: 8),
          Text(
            absentCount.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

}

