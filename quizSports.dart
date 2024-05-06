import 'package:flutter/material.dart';

import 'ppp.dart';

void main() {
  runApp(const MaterialApp(home: SoccerStory()));
}

class SoccerStory extends StatefulWidget {
  const SoccerStory({Key? key}) : super(key: key);

  @override
  _SoccerStoryState createState() => _SoccerStoryState();
}

class _SoccerStoryState extends State<SoccerStory> {
  int _storyIndex = 0;
  final List<int> _previousScenes = []; // Suivre les scènes précédentes

  final List<String> _storyTexts = [
    "C'est votre premier grand match de football ! Vous vous sentez excité mais aussi un peu nerveux à l'approche du terrain, entendant les acclamations et les chants de la foule.",
    "Le jeu commence, et vous voyez vos coéquipiers passer le ballon. Que voulez-vous faire ?",
    "Vous décidez de vous joindre et de passer le ballon. Vous entrez rapidement dans le rythme du jeu, vous sentant moins nerveux et plus excité.",
    "Pendant la mi-temps, vous remarquez qu'un coéquipier a l'air contrarié d'avoir manqué un but. Que faites-vous ?",
    "Vous approchez votre coéquipier et le encouragez, en lui disant que tout le monde fait des erreurs et qu'il reste encore une demi-partie à jouer. Il sourit et semble se sentir mieux.",
    "Votre entraîneur discute des stratégies pour la deuxième mi-temps. Quel rôle voulez-vous prendre ?",
    "Vous proposez de vous concentrer sur la défense pour protéger votre avance. L'équipe est d'accord, et vous vous sentez fier de contribuer vos idées.",
    "Vous proposez de vous concentrer sur l'attaque pour augmenter les opportunités de marquer de l'équipe. L'équipe est d'accord, et vous vous sentez motivé pour mener l'attaque.",
    "À la fin du match, vous réfléchissez à vos expériences. Que vous ayez gagné, appris quelque chose de nouveau ou aidé un coéquipier, vous vous sentez bien de votre contribution.",
    "Vous décidez de regarder le match depuis la touche. En regardant, vous remarquez un joueur de l'équipe adverse effectuer un mouvement que vous n'avez jamais vu auparavant. Cela éveille votre curiosité et vous inspire à pratiquer davantage.",
    "Vous décidez de les laisser tranquilles et essaierez de les réconforter après la fin du match.",
  ];

  final List<List<String>> _choices = [
    ["Commencer le match !"],
    ["Participer et jouer", "Regarder depuis la touche"],
    ["Continuer"],
    ["Les encourager", "Les laisser tranquilles"],
    ["Continuer"],
    ["Se concentrer sur la défense", "Se concentrer sur l'attaque"],
    ["Continuer"],
    ["Terminer"],
    ["Terminer"],
    ["Terminer"],
    ["Terminer"],
  ];

  // Carte liant les scènes de l'histoire avec les choix menant aux scènes suivantes
  final Map<int, Map<int, int>> _nextSceneMap = {
    0: {0: 1},
    1: {0: 2, 1: 9},
    2: {0: 3},
    3: {0: 4, 1: 10},
    4: {0: 5},
    5: {0: 6, 1: 7},
    6: {0: 8},
  };

  void _nextScene(int choiceIndex) {
    setState(() {
      _previousScenes.add(_storyIndex);

      if (_nextSceneMap.containsKey(_storyIndex)) {
        final nextSceneOptions = _nextSceneMap[_storyIndex];
        if (nextSceneOptions != null && nextSceneOptions.containsKey(choiceIndex)) {
          _storyIndex = nextSceneOptions[choiceIndex]!;
        }
      } else {
        if (_storyIndex == 7 || _storyIndex == 8 || _storyIndex == 9 || _storyIndex == 10) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StorySelectionPage()),
          );
        }
      }
    });
  }

  void _goBack() {
    setState(() {
      if (_previousScenes.isNotEmpty) {
        _storyIndex = _previousScenes.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jour de Match de Football'),
        leading: _storyIndex > 0
            ? IconButton(
                onPressed: _goBack,
                icon: const Icon(Icons.arrow_back),
              )
            : null,
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/Dream_clouds.jpeg',
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            _storyTexts[_storyIndex],
                            style: const TextStyle(fontSize: 20.0),
                          ),
                        ),
                        // Ajouter un widget image sous le texte
                        if (_storyIndex >= 0 && _storyIndex <= 10)
                          Image.asset(
                            'assets/sport0${_storyIndex + 1}.jpeg',
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 200.0,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                if (_storyIndex < _choices.length)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _choices[_storyIndex]
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final choice = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: ElevatedButton(
                          onPressed: () => _nextScene(index),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 218, 238, 247),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              choice,
                              style: const TextStyle(color: Colors.black87, fontSize: 18.0),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
