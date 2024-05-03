import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextForm extends StatelessWidget {
  const AppTextForm({
    super.key,
    required this.vertical,
    required this.horizontal,
    required this.hintText,
    required this.weight,
    required this.size,
    required this.textcolor,
    required this.focusColor,
    required this.enableColor,
    required this.validator,
    required this.controller,
    required this.keybordType,
    this.onChanged,
  });

  final double vertical;
  final double horizontal;
  final String hintText;
  //
  final FontWeight weight;
  final double size;
  final Color textcolor;
  //
  final Color focusColor;
  final Color enableColor;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextEditingController controller;

  final TextInputType keybordType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      keyboardType: keybordType,
      decoration: InputDecoration(

          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
              fontSize: size, fontWeight: weight, color: textcolor),
          contentPadding:
              EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: focusColor),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: enableColor),
            borderRadius: BorderRadius.circular(10),
          ),
          border: const OutlineInputBorder()),
      validator: validator,
    );
  }
}
