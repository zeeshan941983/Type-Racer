import 'package:flutter/material.dart';

class PercentageIndicator extends StatelessWidget {
  final double percentage;

  PercentageIndicator(this.percentage);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          color: Colors.deepPurple,

          borderRadius: BorderRadius.circular(20),
          value: percentage,
          minHeight: 50, // Adjust the height to make it thin
          backgroundColor: Colors.deepPurple.shade200,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
        ),
        SizedBox(
          height: 20,
        ),
        Text('${(percentage * 100).toStringAsFixed(0)}%'),
      ],
    );
  }
}
