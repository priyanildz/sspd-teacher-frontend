import 'package:flutter/material.dart';
import 'package:teacher_portal/screens/assessment_screen.dart';

class TimetableList extends StatelessWidget {
  final List<dynamic> timetableEntries;

  const TimetableList({super.key, required this.timetableEntries});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: timetableEntries.map<Widget>((entry) {
          return _buildTimetableItem(
            context,
            entry['period'],
            entry['time'],
            entry['subject'],
            entry['teacher'],
            screenWidth,
            screenHeight,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimetableItem(BuildContext context, int number, String time, String subject, String teacher, double screenWidth, double screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.01),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 4, spreadRadius: 1),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: screenWidth * 0.1,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "$number",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time & Teacher
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
                      Text(teacher, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Subject & View Assessment
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(subject, style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.w500)),
                      Builder(
                        builder: (context) => InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AssessmentScreen(
                                  subject: subject,
                                  teacher: teacher,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "View Assessment",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
