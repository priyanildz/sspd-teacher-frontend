import 'package:flutter/material.dart';

class DashboardTile extends StatelessWidget {
  const DashboardTile({super.key, required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(  // ✅ Make it tappable
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.blue),
          SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
