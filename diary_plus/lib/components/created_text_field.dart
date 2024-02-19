import 'package:diary_plus/constant.dart';
import 'package:flutter/material.dart';

class CreatedTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const CreatedTextField(
      {super.key,
      required this.controller,
      required this.obscureText,
      required this.hintText});

// This is the created text box to enhance UX
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: purple),
          ),
          fillColor: Colors.grey[100],
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: black),
          hoverColor: Colors.grey[200],
        ),
      ),
    );
  }
}
