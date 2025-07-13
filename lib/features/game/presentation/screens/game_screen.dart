import 'package:flutter/material.dart';

class GameScreen extends StatelessWidget { // Ou StatefulWidget
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Noir Game'),
      ),
      body: const Center(
        child: Text('Bem-vindo ao Game Screen!'),
      ),
    );
  }
}