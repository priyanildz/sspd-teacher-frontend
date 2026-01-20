import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StudentFeesTile extends StatefulWidget {
  final String studentName;
  final String rollNo;
  final double totalFees; // Total fees of the student
  final double paidFees;  // Paid amount

  const StudentFeesTile({
    super.key,
    required this.studentName,
    required this.rollNo,
    required this.totalFees,
    required this.paidFees,
  });

  @override
  _StudentFeesTileState createState() => _StudentFeesTileState();
}

class _StudentFeesTileState extends State<StudentFeesTile> {
  bool isPaid = true; // Default: Paid

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showStudentFeesChart(context); // Show Pie Chart on Tap
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // **Oval Avatar with Initial**
            Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.studentName[0], // First letter
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // **Student Name & Roll No**
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.studentName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Roll no: ${widget.rollNo}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            // **Custom Fees Toggle**
            GestureDetector(
              onTap: () {
                setState(() {
                  isPaid = !isPaid;
                });
              },
              child: Container(
                width: 60,
                height: 30,
                decoration: BoxDecoration(
                  color: isPaid ? Colors.lightBlue[100] : Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Stack(
                  children: [
                    Align(
                      alignment: isPaid ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: 30,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          isPaid ? "P" : "U",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ **Show Pie Chart Dialog on Tap**
  void _showStudentFeesChart(BuildContext context) {
    double remainingFees = widget.totalFees - widget.paidFees;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("${widget.studentName}'s Fees"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // **Pie Chart**
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: widget.paidFees,
                        title: "Paid",
                        color: Colors.green,
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: remainingFees,
                        title: "Unpaid",
                        color: Colors.red,
                        radius: 50,
                      ),
                    ],
                    sectionsSpace: 5,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // **Text Information**
              Text("Total Fees: ₹${widget.totalFees}", style: const TextStyle(fontSize: 16)),
              Text("Paid: ₹${widget.paidFees}", style: const TextStyle(fontSize: 16, color: Colors.green)),
              Text("Unpaid: ₹${remainingFees}", style: const TextStyle(fontSize: 16, color: Colors.red)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
