import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  final _light = ThemeData.light().copyWith(
      primaryColor: const Color(0xff6200EE),
      textTheme: TextTheme(
          bodySmall: GoogleFonts.inter(color: Color(0xFF757575), fontSize: 11),
          titleLarge: GoogleFonts.inter(
              color: Color(0xFFFFFFFF),
              fontSize: 20,
              fontWeight: FontWeight.w400),
          titleSmall: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.5), fontSize: 13),
          titleMedium: GoogleFonts.inter(
              color: Color(0xFF212121),
              fontWeight: FontWeight.w400,
              fontSize: 15),
        labelSmall: GoogleFonts.inter(color: Color(0xFF9E9E9E), fontWeight: FontWeight.w400, fontSize: 13),
          bodyMedium : GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14)
      ),
      disabledColor: Color(0xFFF5F5F5),
      errorColor: Color(0xFFEE2D45),
      dividerColor: Color(0xFFEEEEEE),
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(
        0xff8167e6,
        <int, Color>{
          50: Color(0xff6200EE),
          100: Color(0xff6200EE),
          200: Color(0xff6200EE),
          300: Color(0xff6200EE),
          400: Color(0xff6200EE),
          600: Color(0xff6200EE),
          700: Color(0xff6200EE),
          800: Color(0xff6200EE),
          900: Color(0xff6200EE)
        },
      )).copyWith());
  final _dark = ThemeData.dark();

  get lightTheme => _light;

  get darkTheme => _dark;
}
