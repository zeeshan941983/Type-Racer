import 'package:flutter/material.dart';

class Custom_button extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  final bool ishome;
  const Custom_button(
      {super.key,
      this.ishome = false,
      required this.ontap,
      required this.text});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: ElevatedButton(
        onPressed: ontap,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.black,
          minimumSize: Size(
            !ishome ? width : width / 5,
            50,
          ),
        ),
      ),
    );
  }
}
