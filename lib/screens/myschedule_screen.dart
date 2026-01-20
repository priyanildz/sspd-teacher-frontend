import 'package:flutter/material.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class MyScheduleScreen extends StatefulWidget {
  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen> {
  String? selectedStd;
  String? selectedClass;

  final List<Map<String, String>> scheduleList = [
    {"period": "1", "time": "7:00 to 7:30", "subject": "English- Chp: 1", "class": "5-B", "teacher": "Miss Sharma"},
    {"period": "2", "time": "8:00 to 8:30", "subject": "English- Chp: 1", "class": "5-C", "teacher": "Miss Pundit"},
    {"period": "3", "time": "8:30 to 9:00", "subject": "English- Chp: 3", "class": "6-C", "teacher": "Mr. Mishra"},
    {"period": "4", "time": "9:00 to 9:30", "subject": "English- Chp: 4", "class": "6-B", "teacher": "Mr. Roshan"},
    {"period": "5", "time": "10:00 to 10:30", "subject": "English Test- Chp: 4", "class": "6-B", "teacher": "Miss Sharma", "extraText": "Test Record"},
    {"period": "6", "time": "10:30 to 11:00", "subject": "English- Chp: 4", "class": "", "teacher": "Miss Sharma"},
    {"period": "7", "time": "11:00 to 8:00", "subject": "English- Chp: 4", "class": "", "teacher": "Miss Sharma"},
    {"period": "8", "time": "7:00 to 8:00", "subject": "English- Chp: 4", "class": "", "teacher": "Miss Sharma"},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredList = scheduleList.where((item) {
      if (selectedStd != null && !item["class"]!.startsWith(selectedStd!)) return false;
      if (selectedClass != null && selectedClass!.isNotEmpty && !item["class"]!.endsWith(selectedClass!)) return false;
      return true;
    }).toList();

    return MainLayout(
      selectedIndex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                const Text(
                  "Time Table",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildDropdown("Std", ["5", "6"], selectedStd, (val) {
                    setState(() {
                      selectedStd = val;
                    });
                  }),
                  const SizedBox(height: 10),
                  _buildDropdown("Class", ["A", "B", "C"], selectedClass, (val) {
                    setState(() {
                      selectedClass = val;
                    });
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Center(
              child: Column(
                children: [
                  Text(
                    "31 January 2025",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Thursday",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1, color: Colors.grey),

            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final item = filteredList[index];

                  Color? bgColor;
                  if (index == 4) bgColor = Colors.blue.shade100; // 5th item blue
                  if (index == 6) bgColor = Colors.yellow.shade100; // 7th item yellow

                  return Column(
                    children: [
                      _buildScheduleItem(
                        period: item["period"]!,
                        time: item["time"]!,
                        subject: item["subject"]!,
                        classInfo: item["class"]!,
                        teacher: item["teacher"]!,
                        extraText: item.containsKey("extraText") ? item["extraText"] : null,
                        backgroundColor: bgColor,
                      ),
                      if (index == 3) // Add divider after 4th item
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Break",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String? selectedValue, Function(String?) onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: selectedValue,
          hint: const Text("Select"),
          icon: const Icon(Icons.arrow_drop_down),
          onChanged: onChanged,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScheduleItem({
    required String period,
    required String time,
    required String subject,
    required String classInfo,
    required String teacher,
    String? extraText,
    Color? backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: 1,
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5)),
            ),
            child: Text(period,
                style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(time, style: const TextStyle(fontSize: 14)),
                  Text(subject,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("S-40  N-10  T-50", style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$classInfo $teacher",
                  style: const TextStyle(fontSize: 14),
                ),
                if (extraText == null)
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "View Assessment",
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                if (extraText != null)
                  Text(
                    extraText,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
