import 'package:flutter/material.dart';
import 'main_layout.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final String subject;
  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  String selectedStd = "Select";
  String selectedSemester = "Sem 1";

  final List<String> chapters = ["Chp 1", "Chp 2", "Chp 3", "Chp 4"];
  final List<String> columns = ["A", "B", "C", "D", "E", "F", "G"];

  Map<String, String> tableData = {};

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.04;
    final double spacing = screenHeight * 0.015;
    final double textSize = screenWidth * 0.045;

    return MainLayout(
      selectedIndex: 0,
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            _buildHeader(textSize),
            SizedBox(height: spacing),
            Text(
              widget.subject,
              style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: spacing),
            Expanded(child: _buildTable(screenWidth)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double textSize) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButtonWidget(),
              Text(
                "Syllabus Tracker",
                style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: textSize * 0.85, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    weekday,
                    style: TextStyle(fontSize: textSize * 0.75, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDropdown(
                label: "Std",
                value: selectedStd,
                items: ["Select", "1", "2", "3", "4"],
                onChanged: (value) => setState(() => selectedStd = value!),
              ),
              _buildDropdown(
                label: "Semester",
                value: selectedSemester,
                items: ["Sem 1", "Sem 2", "Sem 3"],
                onChanged: (value) => setState(() => selectedSemester = value!),
              ),
            ],
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(120, 35),
              ),
              onPressed: () {
                // PDF Export Logic
              },
              child: const Text("Export PDF", style: TextStyle(color: Colors.white)),
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
  }) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 5),
        Container(
          width: 100,
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              iconSize: 18,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              dropdownColor: Colors.white,
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 14)),
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: screenWidth * 0.05,
        border: TableBorder.all(color: Colors.blue, width: 1),
        headingRowColor: MaterialStateProperty.all(Colors.blue[100]),
        columns: [
          DataColumn(
            label: Text(widget.subject, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...columns.map((col) => DataColumn(
            label: Text(col, style: const TextStyle(fontWeight: FontWeight.bold)),
          )),
        ],
        rows: chapters.map((chapter) {
          return DataRow(
            cells: [
              DataCell(Text(chapter)),
              ...columns.map((col) => _buildEditableCell(chapter, col)),
            ],
          );
        }).toList(),
      ),
    );
  }

  DataCell _buildEditableCell(String chapter, String column) {
    String key = "$chapter-$column";

    return DataCell(
      GestureDetector(
        onTap: () => _showEditDialog(key),
        child: SizedBox(
          width: 60,
          child: Text(
            tableData[key] ?? "Tap to Edit",
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(String key) {
    TextEditingController controller = TextEditingController(text: tableData[key] ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Edit Cell", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: "Enter value"),
                autofocus: true,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        tableData[key] = controller.text.trim();
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
