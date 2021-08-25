import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

PreferredSizeWidget appBarMain(BuildContext context, String title) {
  return AppBar(
      title: Text(
    title,
    style: TextStyle(
      fontFamily: GoogleFonts.petitFormalScript().fontFamily,
      fontWeight: FontWeight.bold,
    ),
  ));
}

InputDecoration DecorateInput(String hint) {
  return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white),
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)));
}
