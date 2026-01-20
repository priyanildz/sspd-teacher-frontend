import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class ExamMarksEntryScreen extends StatelessWidget {
  final String subject;
  final String std;
  final String div;
  final String classTeacher;
  final List<Map<String, String>> students;

  const ExamMarksEntryScreen({
    super.key,
    required this.subject,
    required this.std,
    required this.div,
    required this.classTeacher,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime(2025, 2, 1);
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    return MainLayout(
      selectedIndex: 2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double paddingValue = constraints.maxWidth > 600 ? 32.0 : 16.0;
          double fontSize = constraints.maxWidth > 600 ? 18.0 : 16.0;

          return Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButtonWidget(),
                    Text("Exam", style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                    Text(
                      "$formattedDate\n$weekday",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: fontSize - 2),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Standard:  $std", style: TextStyle(fontSize: fontSize)),
                        Text("Division: $div", style: TextStyle(fontSize: fontSize)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Total Students: 50", style: TextStyle(fontSize: fontSize)),
                        Text("Total Marks: 100", style: TextStyle(fontSize: fontSize)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {},
                    child: Text("Submit", style: TextStyle(color: Colors.white, fontSize: fontSize)),
                  ),
                ),
                const SizedBox(height: 10),

                // Class Teacher Info
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Class Teacher: $classTeacher", style: TextStyle(fontSize: fontSize)),
                ),
                const Divider(thickness: 1, color: Colors.blue),
                Text(subject, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                const Divider(thickness: 1, color: Colors.blue),

                // Student List
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(student['initial']!, style: TextStyle(color: Colors.white, fontSize: fontSize)),
                        ),
                        title: Text("Students Name", style: TextStyle(fontSize: fontSize)),
                        subtitle: Text("Roll no: ${student['rollNo']}", style: TextStyle(color: Colors.grey, fontSize: fontSize - 2)),
                        trailing: Text(student['originalMarks']!, style: TextStyle(fontSize: fontSize)),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
