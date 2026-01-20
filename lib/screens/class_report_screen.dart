import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/screens/student_report_screen.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class ClassReportScreen extends StatefulWidget {
  const ClassReportScreen({super.key});

  @override
  State<ClassReportScreen> createState() => _ClassReportScreenState();
}

class _ClassReportScreenState extends State<ClassReportScreen> {
  String? selectedStd;
  String? selectedDiv;
  String? selectedSem;

  List<Map<String, dynamic>> students = [
    {"name": "Aman Kumar", "eng": 85, "maths": 90, "sci": 80, "social": 75, "hindi": 88, "tm": 418},
    {"name": "Bhavya Sharma", "eng": 78, "maths": 82, "sci": 89, "social": 77, "hindi": 85, "tm": 411},
    {"name": "Chetan Singh", "eng": 92, "maths": 88, "sci": 91, "social": 80, "hindi": 90, "tm": 441},
    {"name": "Divya Patel", "eng": 81, "maths": 79, "sci": 85, "social": 82, "hindi": 87, "tm": 414},
    {"name": "Esha Verma", "eng": 76, "maths": 80, "sci": 84, "social": 78, "hindi": 86, "tm": 404},
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    return MainLayout(
      selectedIndex: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                const Text(
                  "Report Card",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      weekday,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),

            // Dropdowns
            _buildDropdown("Std", ["1", "2", "3", "4", "5"], selectedStd, (value) {
              setState(() {
                selectedStd = value;
              });
            }),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildDropdown("Div", ["A", "B", "C", "D"], selectedDiv, (value) {
                    setState(() {
                      selectedDiv = value;
                    });
                  }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildDropdown("Sem", ["1", "2"], selectedSem, (value) {
                    setState(() {
                      selectedSem = value;
                    });
                  }),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Export PDF Button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(100, 30),
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                ),
                onPressed: () {
                  // PDF Export Logic
                },
                child: const Text(
                  "Export PDF",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),

            const Divider(thickness: 1, color: Colors.blue),

            // Report Card Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    border: TableBorder.all(color: Colors.grey),
                    columnSpacing: screenWidth * 0.03, // Adjust column spacing dynamically
                    columns: const [
                      DataColumn(label: Text("Student Name", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Eng", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Maths", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Sci", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Social", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("Hindi", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("TM", style: TextStyle(fontWeight: FontWeight.bold))),
                      DataColumn(label: Text("%", style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                    rows: students.map((student) {
                      return DataRow(cells: [
                        DataCell(
                          GestureDetector(
                            onTap: () => _showStudentDetails(context, student),
                            child: Text(
                              student["name"],
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataCell(Text("${student["eng"]}")),
                        DataCell(Text("${student["maths"]}")),
                        DataCell(Text("${student["sci"]}")),
                        DataCell(Text("${student["social"]}")),
                        DataCell(Text("${student["hindi"]}")),
                        DataCell(Text("${student["tm"]}")),
                        DataCell(Text("${(student["tm"] / 5).toStringAsFixed(1)}%")), // Percentage calculation
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String? selectedValue, Function(String?) onChanged) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Text("$label:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                hint: const Text("Select"),
                isExpanded: true,
                items: options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showStudentDetails(BuildContext context, Map<String, dynamic> student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentReportScreen(student: student),
      ),
    );
  }
}
