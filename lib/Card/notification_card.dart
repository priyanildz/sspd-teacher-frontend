import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final String date;

  const NotificationCard({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Index Number Box
          Container(
            width: 40,
            height: 70,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFF3E77A4), // Blue background
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Text(
              index.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // Notification Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF3E77A4)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

          // Date and View Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Date",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // Handle view action
                  },
                  child: const Text("View", style: TextStyle(fontSize: 12, color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
