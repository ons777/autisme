// ignore_for_file: library_private_types_in_public_api, file_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'ppp.dart';

void main() {
  runApp(const MaterialApp(home: FriendshipStory()));
}

class FriendshipStory extends StatefulWidget {
  const FriendshipStory({super.key});

  @override
  _FriendshipStoryState createState() => _FriendshipStoryState();
}

class _FriendshipStoryState extends State<FriendshipStory> {
  int _storyIndex = 0;
  final List<int> _previousScenes = []; 

final List<String> _storyTexts = [
  "Toi et ton meilleur amie décidez de partir à l'aventure. Vous aimez explorer et vous avez décidé de découvrir un nouveau sentier de randonnée.",
  "Au début de la randonnée, vous arrivez à un carrefour. Quel chemin choisissez-vous ?",
  "Vous optez pour le chemin de gauche. Le chemain étè difficile, mais vous vous aidez mutuellement et profitez du voyage.",
  "Vous prenez le chemin de droite. C'est pittoresque avec une belle vue. Vous prenez un moment pour admirer la nature.",
  "Après une longue marche, vous trouvez un endroit parfait pour pique-niquer. Vous partagez des histoires en mangeant vos snacks préférés.",
  "Vous décidez de jouer à un jeu. En jouant, vous repérez un petit lapin piégé dans un buisson. Que faites-vous ?",
  "Vous décidez de libérer le lapin. Avec précaution, vous parvenez à le libérer. Il s'enfuit dans la forêt et vous ressentez un soulagement.",
  "Vous décidez de continuer le pique-nique. Après un moment, vous remarquez que le lapin s'est libéré d'eux-mêmes.",
  "Rafraîchis après le pique-nique, vous continuez la randonnée. Vous découvrez une belle cascade.",
  "À la fin de la journée, vous revenez, partageant des histoires et faisant des plans pour la prochaine aventure.",
  "Vous célébrez le sauvetage, fiers et heureux de votre gentillesse.",
  "Après la randonnée difficile, vous trouvez un endroit paisible près d'un ruisseau. C'est parfait pour le pique-nique. En déballant vos snacks, vous profitez du bruit apaisant de l'eau et des feuilles.",
  "Inspirés par le paysage, vous prenez des photos pour garder des souvenirs de l'aventure.",
  "Après que le lapin se soit libéré, vous discutez de votre soulagement et du respect pour la nature.",
  "À la tombée de la nuit, vous rentrez chez vous, réfléchissant à l'aventure de la journée.",
];


  final List<List<String>> _choices = [
    ["Commencer l'aventure !"],
    ["Prendre le chemin de gauche", "Prendre le chemin de droite"],
    ["Reposez-vous un moment", "Continuer la randonnée"],
    ["Prendre quelques photos", "Continuer la randonnée"],
    ["Jouer à un jeu", "Continuer le pique-nique"],
    ["Aider le lapin", "Continuer le pique-nique"],
    ["Célébrer le sauvetage", "Continuer la randonnée"],
    ["Discuter de l'incident", "Continuer la randonnée"],
    ["Profiter de la cascade", "Continuer la randonnée"],
    ["Planifier la prochaine aventure", "Terminer la journée"],
    ["Fin"],
    ["Fin"],
    ["Fin"],
    ["Fin"],
    ["Fin"],
    ["Fin"],
  ];

  final Map<int, Map<int, int>> _nextSceneMap = {
    0: {0: 1}, 
    1: {0: 2, 1: 3},    // After choosing path
    2: {0: 4, 1: 4},    // After left path
    3: {0: 12, 1: 4},    // After right path
    4: {0: 5, 1: 11},    // After picnic
    5: {0: 6, 1: 7},    // After creature decision
    6: {0: 10, 1: 8},    // After helping creature
    7: {0: 13, 1: 8},    // After ignoring creature
    8: {0: 9, 1: 9},    // After waterfall
    9: {0: 14, 1: 15},  // End
    
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
        if (_storyIndex == 15 || _storyIndex == 14 || _storyIndex == 13 || _storyIndex == 12|| _storyIndex == 11|| _storyIndex == 10) {
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
        // Retrieve the last scene index from the list of previous scenes
        _storyIndex = _previousScenes.removeLast();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friendship Story'),
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
                        // Add an image widget below the text
                        if (_storyIndex >= 0 && _storyIndex <= 14)
                          Image.asset(
                            'assets/friend0${_storyIndex + 1}.jpeg',
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
