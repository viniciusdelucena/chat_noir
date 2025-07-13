import 'package:flutter/material.dart';

// Mais tarde, importaremos seus outros widgets, como o HexBoard.
// import 'package:chat_noir/features/game/presentation/widgets/hex_board.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // O Scaffold é a estrutura base de uma tela no Flutter.
    // Pense nele como a tag <body> que contém tudo.
    return Scaffold(
      // A AppBar é a barra no topo da tela, um ótimo lugar para o título.
      // É aqui que colocamos o seu <h1>Chat Noir</h1>.
      appBar: AppBar(
        title: const Text('Chat Noir'),
        centerTitle: true, // Centraliza o título, comum em apps.
      ),
      // O `body` conterá todo o nosso conteúdo principal.
      // Usamos uma `Column` para empilhar os widgets verticalmente.
      body: Padding(
        // Adiciona um espaçamento interno em todas as bordas da tela.
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Alinha os filhos da coluna no centro do eixo horizontal.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Esta `Row` representa a <div id="scoreboard">.
            // Usamos uma `Row` para colocar os dois placares lado a lado.
            const Row(
              // Distribui o espaço igualmente entre os widgets do placar.
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Corresponde a <span>Jogador: <span id="player-score">0</span></span>
                Text('Jogador: 0', style: TextStyle(fontSize: 18)),
                // Corresponde a <span>Gato: <span id="cpu-score">0</span></span>
                Text('Gato: 0', style: TextStyle(fontSize: 18)),
              ],
            ),

            // Um espaço vertical entre o placar e o tabuleiro.
            const SizedBox(height: 20),

            // Este `Expanded` com `Container` é um placeholder para a <div id="game-board">.
            // O `Expanded` faz com que este widget ocupe todo o espaço vertical disponível.
            // Futuramente, vamos substituí-lo pelo seu widget `HexBoard`.
            Expanded(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Aqui ficará o tabuleiro do jogo (HexBoard)'),
              ),
            ),

            // Um espaço vertical entre o tabuleiro e o botão.
            const SizedBox(height: 20),

            // Este `ElevatedButton` corresponde ao seu <button onclick="resetGame()">.
            // A propriedade `onPressed` é onde a lógica de `resetGame()` irá entrar.
            ElevatedButton(
              onPressed: () {
                // A lógica do botão será implementada no Passo 3.
                print('Botão Resetar pressionado!');
              },
              child: const Text('Resetar'),
            ),
          ],
        ),
      ),
    );
  }
}