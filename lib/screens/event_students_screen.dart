import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class EventStudentsScreen extends StatefulWidget {
  final String eventName;
  final String managedBy;
  final String date;
  final String venue;

  const EventStudentsScreen({
    super.key,
    required this.eventName,
    required this.managedBy,
    required this.date,
    required this.venue,
  });

  @override
  State<EventStudentsScreen> createState() => _EventStudentsScreenState();
}

class _EventStudentsScreenState extends State<EventStudentsScreen> {
  String selectedStd = "Select";
  String selectedClass = "Select";
  final List<String> standards = ["Select", "I", "II", "III", "IV", "V"];
  final List<String> classes = ["Select", "A", "B", "C", "D"];

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat("dd MMMM yyyy").format(DateTime.now());
    String weekday = DateFormat("EEEE").format(DateTime.now());

    return MainLayout(
      selectedIndex: 0,
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          bool isWide = width > 600;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButtonWidget(),
                      const Text(
                        "Events",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(formattedDate, style: const TextStyle(fontSize: 16)),
                          Text(weekday, style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("Managed by ${widget.managedBy}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Search Student",
                            border: OutlineInputBorder(),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.search, size: 30, color: Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoTile("Event Name:", widget.eventName),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: _buildInfoTile("Date & Day:", widget.date)),
                      const SizedBox(width: 6),
                      Expanded(child: _buildInfoTile("Venue:", widget.venue)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: _buildDropdown("Std:", selectedStd, standards, (value) {
                        setState(() {
                          selectedStd = value!;
                        });
                      })),
                      const SizedBox(width: 6),
                      Expanded(child: _buildDropdown("Class:", selectedClass, classes, (value) {
                        setState(() {
                          selectedClass = value!;
                        });
                      })),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return _buildStudentTile(index + 1);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(value, style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
      String label, String selectedValue, List<String> options, Function(String?) onChanged) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Expanded(
          child: DropdownButtonFormField(
            value: selectedValue,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
            ),
            items: options.map((String option) {
              return DropdownMenuItem(value: option, child: Text(option));
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentTile(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 80,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text("$index", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Student Name", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Div: A"),
                  Text("Class: 5th"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}