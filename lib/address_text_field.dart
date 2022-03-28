import 'package:flutter/material.dart';

class PostTextField extends StatelessWidget {
  PostTextField({
    required this.controller,
    this.hintText,
    this.maxLines = 3,
    this.hintStyle,
  });

  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        hintText: hintText,
        hintStyle: hintStyle,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        border: InputBorder.none,
      ),
    );
  }
}