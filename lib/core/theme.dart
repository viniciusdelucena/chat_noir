import 'package:flutter/material.dart';
import 'package:chat_noir/core/styles/colors.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.background,

  fontFamily: 'sans-serif',

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.cell, 
    foregroundColor: Colors.white, 
    elevation: 0,
    centerTitle: true,
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black, fontSize: 18), 
    titleLarge: TextStyle(color: Colors.white), 
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.cell,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
);