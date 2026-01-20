import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class ExamMarksRecheckingScreen extends StatelessWidget {
  final String subject;
  final String std;
  final String div;
  final String classTeacher;
  final String checkedBy;
  final List<Map<String, String>> students;

  const ExamMarksRecheckingScreen({
    super.key,
    required this.subject,
    required this.std,
    required this.div,
    required this.classTeacher,
    required this.checkedBy,
    required this.students,
  });

  void _showMarksDialog(BuildContext context, Map<String, String> student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Student's Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.blue),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text("Roll no: ${student['rollNo']}", style: const TextStyle(color: Colors.grey)),
              InkWell(
                onTap: () {},
                child: Text("$std | $div", style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
              ),
              const SizedBox(height: 10),
              Text("Class Tr: $classTeacher", style: const TextStyle(fontSize: 16)),
              Text("Checked by: $checkedBy", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 15),
              Text("Marks Change:", style: const TextStyle(fontSize: 16)),
              TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
              ),
              const SizedBox(height: 10),
              Text("Comment", style: const TextStyle(fontSize: 16)),
              TextField(
                maxLines: 3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Submit", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime(2025, 2, 1);
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    return MainLayout(
      selectedIndex: 2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double fontSize = constraints.maxWidth > 600 ? 18.0 : 16.0;
          double paddingValue = constraints.maxWidth > 600 ? 32.0 : 16.0;

          return Padding(
            padding: EdgeInsets.all(paddingValue),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackButtonWidget(),
                    Text("Exam", style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                    Text("$formattedDate\n$weekday", textAlign: TextAlign.right, style: TextStyle(fontSize: fontSize - 2)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Standard: $std", style: TextStyle(fontSize: fontSize)),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("Class Teacher: $classTeacher", style: TextStyle(fontSize: fontSize)),
                ),
                const Divider(thickness: 1, color: Colors.blue),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(subject, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                    Text("Checked by $checkedBy", style: TextStyle(fontSize: fontSize)),
                  ],
                ),
                const Divider(thickness: 1, color: Colors.blue),
                Expanded(
                  child: ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final student = students[index];
                      return ListTile(
                        onTap: () => _showMarksDialog(context, student),
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
