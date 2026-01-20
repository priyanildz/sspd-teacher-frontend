import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/screens/subject_details_screen.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

void main() {
  runApp(const MaterialApp(
    home: SyllabusTrackerScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class SyllabusTrackerScreen extends StatefulWidget {
  const SyllabusTrackerScreen({super.key});

  @override
  _SyllabusTrackerScreenState createState() => _SyllabusTrackerScreenState();
}

class _SyllabusTrackerScreenState extends State<SyllabusTrackerScreen> {
  String selectedStd = "Select";
  String selectedSemester = "Sem 2";
  Map<String, TextEditingController> tableControllers = {};

  final List<String> subjects = [
    "English (4)", "Maths (3)", "Science", "History", "Geography", "Hindi"
  ];

  final List<String> columns = ["A", "B", "C", "D", "E", "F", "G"];

  @override
  void initState() {
    super.initState();
    for (var subject in subjects) {
      for (var column in columns) {
        tableControllers["$subject-$column"] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (var controller in tableControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define screenWidth and screenHeight here using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return MainLayout(
      selectedIndex: 0,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.03), // Adjust padding based on screen size
        child: Column(
          children: [

            _buildHeader(screenWidth, screenHeight),
            const SizedBox(height: 10),
            _buildTable(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double screenWidth, double screenHeight) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButtonWidget(),
              Text(
                "Syllabus Tracker",
                style: TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    weekday,
                    style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDropdown(
                label: "Std",
                value: selectedStd,
                items: ["Select", "1", "2", "3", "4"],
                onChanged: (value) {
                  setState(() {
                    selectedStd = value!;
                  });
                },
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
              _buildDropdown(
                label: "Semester",
                value: selectedSemester,
                items: ["Sem 1", "Sem 2", "Sem 3"],
                onChanged: (value) {
                  setState(() {
                    selectedSemester = value!;
                  });
                },
                screenWidth: screenWidth,
                screenHeight: screenHeight,
              ),
            ],
          ),

          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(screenWidth * 0.3, screenHeight * 0.05), // Responsive button size
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              onPressed: () {
                // PDF Export Logic
              },
              child: Text(
                "Export PDF",
                style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: screenWidth * 0.04)),
        const SizedBox(width: 5),
        Container(
          width: screenWidth * 0.2,
          height: screenHeight * 0.05,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(3),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              iconSize: 18,
              style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black),
              dropdownColor: Colors.white,
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(double screenWidth) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          border: TableBorder.all(color: Colors.blue, width: 1),
          headingRowColor: MaterialStateProperty.all(Colors.blue[100]),
          columns: [
            DataColumn(label: Text("Subject", style: TextStyle(fontWeight: FontWeight.bold))),
            ...columns.map((col) => DataColumn(
              label: Text(col, style: TextStyle(fontWeight: FontWeight.bold)),
            )),
          ],
          rows: subjects.map((subject) {
            return DataRow(
              cells: [
                DataCell(
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectDetailsScreen(subject: subject),
                        ),
                      );
                    },
                    child: Text(
                      subject,
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ),
                ...columns.map((col) => _buildEditableCell(subject, col, screenWidth)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  DataCell _buildEditableCell(String subject, String column, double screenWidth) {
    String key = "$subject-$column";
    return DataCell(
      TextFormField(
        controller: tableControllers[key],
        decoration: const InputDecoration(border: InputBorder.none),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: screenWidth * 0.035),
      ),
    );
  }
}
