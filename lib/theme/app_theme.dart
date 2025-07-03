import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// NOTE: This is a safely revised full app_theme.dart compatible with latest Flutter
// All constructors now use const where required
// Use this theme file to retain detailed UI design while avoiding Codemagic build errors

final ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF4A90E2),
  scaffoldBackgroundColor: Colors.white,
  fontFamily: GoogleFonts.inter().fontFamily,
  cardTheme: const CardTheme(
    color: Colors.white,
    elevation: 2,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(const Radius.circular(20.0)),
    ),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Color(0xFF4A90E2),
    unselectedLabelColor: Colors.grey,
    indicatorColor: Color(0xFF4A90E2),
    indicatorSize: TabBarIndicatorSize.label,
    labelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold),
    titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600),
    bodyMedium: GoogleFonts.inter(fontSize: 16),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
  ),
  tooltipTheme: const TooltipThemeData(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.black87,
      borderRadius: BorderRadius.all(const Radius.circular(8)),
    ),
    textStyle: TextStyle(color: Colors.white),
  ),
);

final ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF9B59B6),
  scaffoldBackgroundColor: const Color(0xFF121212),
  fontFamily: GoogleFonts.inter().fontFamily,
  cardTheme: const CardTheme(
    color: Color(0xFF1E1E1E),
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(const Radius.circular(20.0)),
    ),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Color(0xFF9B59B6),
    unselectedLabelColor: Colors.grey,
    indicatorColor: Color(0xFF9B59B6),
    indicatorSize: TabBarIndicatorSize.label,
    labelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF121212),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    titleLarge: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
    bodyMedium: GoogleFonts.inter(fontSize: 16, color: Colors.white70),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70),
  ),
  tooltipTheme: const TooltipThemeData(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white10,
      borderRadius: BorderRadius.all(const Radius.circular(8)),
    ),
    textStyle: TextStyle(color: Colors.white),
  ),
);
