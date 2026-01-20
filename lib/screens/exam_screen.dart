import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';
import 'package:teacher_portal/screens/exam_timetable_screen.dart';
import 'package:teacher_portal/screens/exam_checking_screen.dart';
import 'package:teacher_portal/screens/exam_supervisor_screen.dart';
import 'package:teacher_portal/screens/exam_rechecking_screen.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); // Static date for design accuracy
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    // Get screen width and height for responsive layout
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Dynamically adjust font size and padding
    double fontSize = screenWidth < 350 ? 14 : 18; // Smaller font size on smaller screens
    double headerFontSize = screenWidth < 350 ? 16 : 20; // Header font size adjustment
    double padding = screenWidth < 350 ? 8 : 16; // Adjust padding based on screen size

    return MainLayout(
      selectedIndex: 2,
      child: Padding(
        padding: EdgeInsets.all(padding), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                Text(
                  "Exam",
                  style: TextStyle(fontSize: headerFontSize, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      weekday,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(),

            // Menu Buttons (Ensure they fit within screen width)
            Expanded(
              child: ListView(
                children: [
                  _buildExamCard(context, "TimeTable", const ExamTimetableScreen()),
                  _buildExamCard(context, "Supervisor", const SupervisorScreen()),
                  _buildExamCard(context, "Checking", const CheckingScreen()),
                  _buildExamCard(context, "Re checking", const ReCheckingScreen()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, String title, Widget screen) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 350 ? 14 : 18; // Adjust card font size for smaller screens

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(4),
            boxShadow: const [BoxShadow(color: Colors.white, blurRadius: 2, offset: Offset(2, 2))],
          ),
          child: Column(
            children: [
              Container(height: 50),
              Container(
                color: Colors.blue,
                height: 35,
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Container(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
