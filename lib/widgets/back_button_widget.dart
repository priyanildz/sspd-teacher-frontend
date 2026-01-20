import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final Color color;
  final double size;
  final bool goHome; // 🔥 New parameter to control behavior

  const BackButtonWidget({
    super.key,
    this.color = Colors.black,
    this.size = 24.0,
    this.goHome = false, // Default: pop the screen
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: color, size: size),
      onPressed: () {
        if (goHome) {
          Navigator.pushReplacementNamed(context, '/home'); // 🔥 Go to Home
        } else if (Navigator.canPop(context)) {
          Navigator.pop(context); // 🔙 Pop if possible
        } else {
          Navigator.pushReplacementNamed(context, '/home'); // 🔥 Fallback to Home
        }
      },
    );
  }
}
