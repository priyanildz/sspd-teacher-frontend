import 'package:flutter/material.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class StudentReportScreen extends StatelessWidget {
  final Map<String, dynamic> student;

  const StudentReportScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.045; // Adjust font size based on screen width
    double buttonWidth = screenWidth * 0.25; // Adjust button width dynamically
    double padding = screenWidth * 0.03; // Responsive padding

    return MainLayout(
      selectedIndex: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// **Header Row**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButtonWidget(),
                    Text("Report Card", style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formattedDate,
                          style: TextStyle(fontSize: fontSize * 0.8, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          weekday,
                          style: TextStyle(fontSize: fontSize * 0.7, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                Center(
                  child: Text(
                    student["name"], // Displaying student's name
                    style: TextStyle(fontSize: fontSize * 1.2, fontWeight: FontWeight.bold),
                  ),
                ),

                SizedBox(height: padding),

                Text("Std:", style: TextStyle(fontSize: fontSize * 0.8)),
                Text("Div:", style: TextStyle(fontSize: fontSize * 0.8)),
                Text("Sem:", style: TextStyle(fontSize: fontSize * 0.8)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(flex: 2), // Pushes "Exam Record" to the center
                    Text("Exam Record", style: TextStyle(fontSize: fontSize * 0.9, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(buttonWidth, 35),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      onPressed: () {
                        // PDF Export Logic
                      },
                      child: Text("Export PDF", style: TextStyle(color: Colors.white, fontSize: fontSize * 0.6)),
                    ),
                  ],
                ),

                Divider(thickness: 1, color: Colors.blue),

                SizedBox(height: padding),

                /// **Scrollable Table**
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    border: TableBorder.all(color: Colors.grey),
                    columnSpacing: screenWidth * 0.05, // Responsive column spacing
                    columns: [
                      DataColumn(label: Text("Subject", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize * 0.8))),
                      DataColumn(label: Text("Sem 1", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize * 0.8))),
                      DataColumn(label: Text("Sem 2", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize * 0.8))),
                      DataColumn(label: Text("Sem 3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize * 0.8))),
                      DataColumn(label: Text("Sem 4", style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize * 0.8))),
                    ],
                    rows: [
                      _buildRow("English", [student["eng"], null, null, null], fontSize),
                      _buildRow("Maths", [student["maths"], null, null, null], fontSize),
                      _buildRow("Science", [student["sci"], null, null, null], fontSize),
                      _buildRow("History", [null, null, null, null], fontSize),
                      _buildRow("Geography", [null, null, null, null], fontSize),
                      _buildRow("Total Marks", [student["tm"], null, null, null], fontSize, isBold: true),
                      _buildRow("Percentage", ["${(student["tm"] / 5).toStringAsFixed(1)}%", null, null, null], fontSize, isBold: true),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  DataRow _buildRow(String subject, List<dynamic> marks, double fontSize, {bool isBold = false}) {
    return DataRow(
      cells: [
        DataCell(Text(subject, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize * 0.8))),
        for (var mark in marks)
          DataCell(Text(mark != null ? mark.toString() : "", style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: fontSize * 0.8))),
      ],
    );
  }
}
