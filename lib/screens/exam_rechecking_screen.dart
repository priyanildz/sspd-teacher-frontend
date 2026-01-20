import 'package:flutter/material.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/screens/exam_marks_rechecking_screen.dart';

class ReCheckingScreen extends StatelessWidget {
  const ReCheckingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now(); // Static date for design accuracy
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    List<Map<String, String>> examData = List.generate(3, (index) {
      return {
        "subject": "English",
        "std": "5th",
        "div": "A",
        "class_tr": "Mss Sharma",
        "checked_by": "Mr Mishra",
        "date": formattedDate,
        "papers": "50 Papers"
      };
    });

    return MainLayout(
      selectedIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonWidget(),
                Text(
                  "Exam",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$formattedDate\n$weekday",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              "Re-Checking",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                          builder: (context) => ExamMarksRecheckingScreen(
                            subject: "English",
                            std: "5th",
                            div: "A",
                            classTeacher: "Miss Sharma",
                            checkedBy: "Mr Mishra",
                            students: [
                              {"initial": "A", "rollNo": "01", "originalMarks": "45", "checkedMarks": "45"},
                              {"initial": "B", "rollNo": "02", "originalMarks": "40", "checkedMarks": "40"},
                              {"initial": "C", "rollNo": "03", "originalMarks": "42", "checkedMarks": "42"},
                              {"initial": "D", "rollNo": "04", "originalMarks": "38", "checkedMarks": "35"},
                              {"initial": "E", "rollNo": "05", "originalMarks": "NA", "checkedMarks": "NA"},
                              {"initial": "F", "rollNo": "06", "originalMarks": "42", "checkedMarks": "42"},
                              {"initial": "G", "rollNo": "07", "originalMarks": "43", "checkedMarks": "43"},
                              {"initial": "H", "rollNo": "08", "originalMarks": "NA", "checkedMarks": "NA"},
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
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
                              Text(
                                "Subject: ${data["subject"]}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "STd: ${data["std"]}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Div: ${data["div"]}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Class Tr: ${data["class_tr"]}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Checked by : ${data["checked_by"]}",
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                "Date : ${data["date"]}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          Text(
                            data["papers"]!,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
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
      ),
    );
  }
}
