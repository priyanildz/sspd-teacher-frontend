import 'package:flutter/material.dart';
import 'package:teacher_portal/screens/main_layout.dart';
import 'package:teacher_portal/widgets/back_button_widget.dart';

class SupervisorScreen extends StatefulWidget {
  const SupervisorScreen({super.key});

  @override
  State<SupervisorScreen> createState() => _SupervisorScreenState();
}

class _SupervisorScreenState extends State<SupervisorScreen> {
  bool isFifth = true;
  int presentCount = 0;
  int absentCount = 25;
  String searchQuery = "";

  final Map<String, List<Map<String, dynamic>>> studentData = {
    "5th": List.generate(
      25,
          (index) => {
        "name": "Student Name",
        "roll": (index + 1).toString().padLeft(2, '0'),
        "initial": String.fromCharCode(65 + (index % 26)),
        "isPresent": false
      },
    ),
    "6th": List.generate(
      25,
          (index) => {
        "name": "Student Name",
        "roll": (index + 1).toString().padLeft(2, '0'),
        "initial": String.fromCharCode(65 + (index % 26)),
        "isPresent": false
      },
    ),
  };

  @override
  Widget build(BuildContext context) {
    String selectedStd = isFifth ? "5th" : "6th";
    List<Map<String, dynamic>> students = studentData[selectedStd]!
        .where((student) =>
        student["name"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return MainLayout(
      selectedIndex: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButtonWidget(),
                const Text("Exam", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Text("Block no: 1", style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Standard: $selectedStd", style: const TextStyle(fontSize: 16)),
                    const Text("Division: A", style: TextStyle(fontSize: 16)),
                    const Text("Students: 25", style: TextStyle(fontSize: 16)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Total Students: 50", style: TextStyle(fontSize: 16)),
                    const Text("5th: 25   6th: 25", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                toggleButton("5th", isFifth, () => toggleStandard(true)),
                const SizedBox(width: 10),
                toggleButton("6th", !isFifth, () => toggleStandard(false)),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                const Text("01 February 2025", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Saturday", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Present: $presentCount", style: const TextStyle(fontSize: 16)),
                    Text("Absent: $absentCount", style: const TextStyle(fontSize: 16)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                  child: const Text("Submit"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            searchBar(),
            const SizedBox(height: 10),
            Expanded(child: studentListView(students)),
          ],
        ),
      ),
    );
  }

  Widget toggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(color: isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget searchBar() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.blue),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        hintText: "Search Student",
      ),
    );
  }

  Widget studentListView(List<Map<String, dynamic>> students) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        var student = students[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(student["initial"], style: const TextStyle(color: Colors.white)),
            ),
            title: Text(student["name"]),
            subtitle: Text("Roll no: ${student["roll"]}"),
            trailing: attendanceSwitch(student),
          ),
        );
      },
    );
  }

  Widget attendanceSwitch(Map<String, dynamic> student) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("A", style: TextStyle(color: student["isPresent"] ? Colors.grey : Colors.red, fontWeight: FontWeight.bold)),
        Switch(
          value: student["isPresent"],
          onChanged: (value) {
            setState(() {
              student["isPresent"] = value;
              presentCount = studentData[isFifth ? "5th" : "6th"]!.where((s) => s["isPresent"]).length;
              absentCount = 25 - presentCount;
            });
          },
          activeColor: Colors.blue,
        ),
        Text("P", style: TextStyle(color: student["isPresent"] ? Colors.blue : Colors.grey, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void toggleStandard(bool toFifth) {
    setState(() {
      isFifth = toFifth;
      presentCount = studentData[isFifth ? "5th" : "6th"]!.where((s) => s["isPresent"]).length;
      absentCount = 25 - presentCount;
    });
  }
}
