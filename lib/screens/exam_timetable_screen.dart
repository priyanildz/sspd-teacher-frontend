import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class ExamTimetableScreen extends StatefulWidget {
  const ExamTimetableScreen({super.key});

  @override
  State<ExamTimetableScreen> createState() => _ExamTimetableScreenState();
}

class _ExamTimetableScreenState extends State<ExamTimetableScreen> {
  String selectedStd = '5';

  final Map<String, List<Map<String, String>>> timetableData = {
    '5': [
      {'date': '1 Mar', 'subject': 'English', 'time': '9:00 AM - 11:00 AM'},
      {'date': '2 Mar', 'subject': 'Maths', 'time': '11:30 AM - 1:30 PM'},
      {'date': '3 Mar', 'subject': 'Science', 'time': '2:00 PM - 4:00 PM'},
    ],
    '6': [
      {'date': '1 Mar', 'subject': 'History', 'time': '9:00 AM - 11:00 AM'},
      {'date': '2 Mar', 'subject': 'Physics', 'time': '11:30 AM - 1:30 PM'},
      {'date': '3 Mar', 'subject': 'Chemistry', 'time': '2:00 PM - 4:00 PM'},
    ],
    '7': [
      {'date': '1 Mar', 'subject': 'Biology', 'time': '9:00 AM - 11:00 AM'},
      {'date': '2 Mar', 'subject': 'Geography', 'time': '11:30 AM - 1:30 PM'},
      {'date': '3 Mar', 'subject': 'Civics', 'time': '2:00 PM - 4:00 PM'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    return MainLayout(
      selectedIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                const Text("Exam", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Column(
                  children: [
                    Text(formattedDate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(weekday, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                const Text("Std:", style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Container(
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedStd,
                      onChanged: (newValue) {
                        setState(() {
                          selectedStd = newValue!;
                        });
                      },
                      items: timetableData.keys.map((std) {
                        return DropdownMenuItem(
                          value: std,
                          child: Text(std, style: const TextStyle(fontSize: 16)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Center(child: Text("Timetable", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            const Divider(),

            Expanded(
              child: ListView.builder(
                itemCount: timetableData[selectedStd]!.length,
                itemBuilder: (context, index) {
                  var item = timetableData[selectedStd]![index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          color: Colors.blue,
                          child: Text(
                            item['date']!,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item['subject']!, style: const TextStyle(fontSize: 16)),
                                Text(item['time']!, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ],
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
