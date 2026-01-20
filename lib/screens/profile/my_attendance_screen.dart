import 'package:flutter/material.dart';
import 'package:teacher_portal/utils/profile_header.dart';
import 'package:teacher_portal/widgets/custom_appBar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:teacher_portal/screens/main_layout.dart';

class MyAttendanceScreen extends StatelessWidget {
  const MyAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      selectedIndex: 0,
      child: Padding(
          padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(),

            SizedBox(height: 20,),
            Center(
              child: Text(
                "My Attendance",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendIndicator(Colors.blue, "Present"),
                const SizedBox(width: 20),
                _buildLegendIndicator(Colors.red, "Leave"),
                const SizedBox(width: 20),
                _buildLegendIndicator(Colors.yellow, "Holiday"),
              ],
            ),

            SizedBox(height: 20,),

            Expanded(
                child: TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  calendarFormat: CalendarFormat.month,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                 holidayTextStyle: TextStyle(color: Colors.yellow),
                  ),
            ),
                ),
              ],
            ),
        ),
    );
  }
}

Widget _buildLegendIndicator(Color color, String text) {
  return Row(
    children: [
      Container(width: 16, height: 16, color: color),
      const SizedBox(width: 5),
      Text(text, style: const TextStyle(fontSize: 16)),
    ],
  );
}

