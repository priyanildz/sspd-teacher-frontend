import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'exam_marks_entry_screen.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class CheckingScreen extends StatelessWidget {
  const CheckingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime(2025, 2, 1); // Static date for accuracy
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    List<Map<String, String>> examData = List.generate(3, (index) {
      return {
        "subject": "English",
        "std": "5th",
        "div": "A",
        "class_tr": "Miss Sharma",
        "date": formattedDate,
        "papers": "50 Papers"
      };
    });

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
                    Text(
                      "Exam",
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "$formattedDate\n$weekday",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: fontSize - 2),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                Text(
                  "Checking",
                  style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                ),
                const Divider(thickness: 1, color: Colors.blue),
                const SizedBox(height: 10),

                // Cards
                Expanded(
                  child: ListView.builder(
                    itemCount: examData.length,
                    itemBuilder: (context, index) {
                      var data = examData[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExamMarksEntryScreen(
                                subject: "English",
                                std: "5th",
                                div: "A",
                                classTeacher: "Miss Sharma",
                                students: [
                                  {"initial": "A", "rollNo": "01", "originalMarks": "45"},
                                  {"initial": "B", "rollNo": "02", "originalMarks": "40"},
                                  {"initial": "C", "rollNo": "03", "originalMarks": "42"},
                                  {"initial": "D", "rollNo": "04", "originalMarks": "38"},
                                  {"initial": "E", "rollNo": "05", "originalMarks": "NA"},
                                  {"initial": "F", "rollNo": "06", "originalMarks": "42"},
                                  {"initial": "G", "rollNo": "07", "originalMarks": "43"},
                                  {"initial": "H", "rollNo": "08", "originalMarks": "NA"},
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(paddingValue / 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Subject: ${data["subject"]}", style: TextStyle(fontSize: fontSize)),
                                  Text("Std: ${data["std"]}", style: TextStyle(fontSize: fontSize)),
                                  Text("Div: ${data["div"]}", style: TextStyle(fontSize: fontSize)),
                                  Text("Class Tr: ${data["class_tr"]}", style: TextStyle(fontSize: fontSize)),
                                  Text("Date: ${data["date"]}", style: TextStyle(fontSize: fontSize)),
                                ],
                              ),
                              Text(
                                data["papers"]!,
                                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
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
