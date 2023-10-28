import 'package:flutter/material.dart';

class custom_textfield extends StatelessWidget {
  final TextEditingController controller;
  final String hinttext;
  const custom_textfield({
    super.key,
    required this.controller,
    required this.hinttext,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          fillColor: const Color(0xffF5F5FA),
          filled: true,
          hintText: hinttext,
          hintStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
    );
  }
}
