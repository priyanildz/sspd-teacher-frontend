import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'main_layout.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';
import 'package:teacher_portal/widgets/add_button.dart';

class LectureTestRecord extends StatefulWidget {
  const LectureTestRecord({super.key});

  @override
  _LectureTestRecordState createState() => _LectureTestRecordState();
}

class _LectureTestRecordState extends State<LectureTestRecord> {
  String? selectedStd;
  String? selectedDiv;

  // Sample Test Records
  final List<Map<String, String>> testRecords = [
    {"index": "1", "date": "30-01-2025", "day": "Wednesday", "subject": "English", "chapter": "2", "teacher": "Miss Sharma", "std": "5", "div": "C"},
    {"index": "2", "date": "29-01-2025", "day": "Tuesday", "subject": "Maths", "chapter": "1", "teacher": "Mr. Mishra", "std": "5", "div": "D"},
    {"index": "3", "date": "28-01-2025", "day": "Monday", "subject": "Science", "chapter": "1", "teacher": "Mr. Patel", "std": "6", "div": "A"},
  ];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMMM yyyy').format(now);
    String weekday = DateFormat('EEEE').format(now);

    // **Filter the Records Based on Selection**
    List<Map<String, String>> filteredRecords = testRecords.where((record) {
      return (selectedStd == null || record['std'] == selectedStd) &&
          (selectedDiv == null || record['div'] == selectedDiv);
    }).toList();

    return MainLayout(
      selectedIndex: 0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Header Section**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButtonWidget(),
                const Text("Test Record", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formattedDate, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(weekday, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            // **Dropdowns**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDropdown("Std", ["1", "2", "3", "4", "5"], selectedStd, (value) {
                      setState(() {
                        selectedStd = value;
                      });
                    }),
                    const SizedBox(height: 10),
                    _buildDropdown("Div", ["A", "B", "C", "D"], selectedDiv, (value) {
                      setState(() {
                        selectedDiv = value;
                      });
                    }),
                  ],
                ),

                // **Add Button (On the Opposite Side)**
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.add, color: Colors.white, size: 24),
                    onPressed: () {
                      _showAddTestSheet(context);
                    },
                  ),
                ),
              ],
            ),




            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Total Students: 50", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Class Teacher: Miss Sharma", style: TextStyle(fontSize: 16)),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        minimumSize: const Size(60, 30),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/test-record");
                      },
                      child: const Text("Class", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(60, 30),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      ),
                      onPressed: () {},
                      child: const Text("Lecture", style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),



            const Divider(),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search Tests",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.blue),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.blue),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),


            // **Test Record List**
            Expanded(
              child: filteredRecords.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredRecords.length,
                itemBuilder: (context, index) {
                  return _buildTestRecordItem(filteredRecords[index]);
                },
              )
                  : const Center(
                child: Text("No Records Found", style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTestSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddTestBottomSheet(),
    );
  }

  // **Dropdown Builder**
  Widget _buildDropdown(String label, List<String> options, String? selectedValue, Function(String?) onChanged) {
    return Row(
      children: [
        Text("$label:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        Container(
          width: 120,
          height: 30,
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
      ],
    );
  }

  // **Test Record Item Widget (UI Unchanged)**
  Widget _buildTestRecordItem(Map<String, String> record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(5),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // **Index Column**
            Container(
              width: 40,
              color: Colors.blue,
              alignment: Alignment.center,
              child: Text(
                record['index']!,
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 10),

            // **Expanded Content**
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // **Date & Teacher Row**
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${record['date']}  ${record['day']}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          record['teacher']!,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // **Subject, Chapter, Std & Div**
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("S-40  ${record['subject']}  Chp: ${record['chapter']}", style: const TextStyle(fontSize: 14)),
                      Text("Std: ${record['std']}  Div: ${record['div']}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("N-10 (Total Marks-50)", style: TextStyle(fontSize: 12, color: Colors.grey)),

                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/view-test-record');
                            },
                            child: const Text("View test record", style: TextStyle(color: Colors.blue)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
