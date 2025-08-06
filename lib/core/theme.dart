import 'package:flutter/material.dart';
import 'package:chat_noir/core/styles/colors.dart'; // Importando nossas cores

// ThemeData para a aplicação
final appTheme = ThemeData(
  useMaterial3: true,
  // Cor de fundo principal do Scaffold (a tela)
  scaffoldBackgroundColor: AppColors.background,

  // Fonte padrão para a aplicação
  fontFamily: 'sans-serif', // Flutter mapeará para a fonte sans-serif do sistema

  // Tema da AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.cell, // Uma cor mais escura para contraste
    foregroundColor: Colors.white, // Cor do texto do título
    elevation: 0,
    centerTitle: true,
  ),

  // Tema para os textos
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black, fontSize: 18), // Estilo padrão
    titleLarge: TextStyle(color: Colors.white), // Estilo do título na AppBar
  ),

  // Tema para os botões elevados
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.cell,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
);