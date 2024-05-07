import 'package:flutter/material.dart';

import 'ppp.dart';

void main() {
  runApp(const MaterialApp(home: FamilyStory()));
}

class FamilyStory extends StatefulWidget {
  const FamilyStory({super.key});

  @override
  _FamilyStoryState createState() => _FamilyStoryState();
}

class _FamilyStoryState extends State<FamilyStory> {
  int _storyIndex = 0;
  final List<int> _previousScenes = []; // Suivre les scènes précédentes

  // Mettre à jour la liste _storyTexts pour inclure la scène du choix de la salade de fruits
  final List<String> _storyTexts = [
    "C'est un après-midi ensoleillé et votre famille décide de partir en pique-nique. Vous préparez des collations, des jeux et une couverture et vous dirigez vers le parc local.",
    "Au parc, vous remarquez différentes activités se déroulant autour de vous. Que voulez-vous faire en premier ?",
    "Vous décidez de jouer au soccer avec votre frère/sœur. Le jeu est compétitif, mais tout le monde s'amuse. Après le match, vous rejoignez vos parents pour le pique-nique.",
    "Vous décidez de faire voler un cerf-volant avec votre frère/sœur. Le vent est parfait, et vous regardez le cerf-volant s'envoler haut.",
    "Vos parents installent le pique-nique, et vous remarquez que votre frère/sœur a du mal avec le cerf-volant. Que faites-vous ?",
    "Vous approchez votre frère/sœur et proposez de l'aider avec le cerf-volant. Ensemble, vous parvenez enfin à le faire voler, et votre frère/sœur est ravi(e) ! Après avoir fait voler le cerf-volant, vous rejoignez vos parents pour le pique-nique.",
    "Vous décidez de continuer à faire voler le cerf-volant. Après un moment, vous rejoignez vos parents pour le pique-nique.",
    "Après avoir joué, c'est l'heure de manger. Quelle est votre collation de pique-nique préférée ?",
    "Vous partagez votre amour pour les sandwiches avec tout le monde, et ils conviennent que c'est la meilleure collation. Tout le monde commence à partager des histoires et à rire ensemble.",
    "Votre famille parle des plans à venir et vous élaborez tous des idées pour la prochaine sortie en famille. Quelle suggestion faites-vous ?",
    "Vous proposez de faire une randonnée en famille jusqu'à une montagne voisine. Tout le monde est d'accord, et vous commencez tous à planifier l'aventure.",
    "Vous suggérez de visiter un musée à proximité pour une journée éducative mais amusante. Votre famille adore l'idée et l'ajoute à la liste des sorties à venir.",
    "À la fin du pique-nique, vous vous sentez reconnaissant(e) d'avoir passé du temps de qualité avec votre famille. Tout le monde range et rentre chez lui, excité pour les aventures futures ensemble.",
    "Vous choisissez la salade de fruits comme collation. C'est rafraîchissant et délicieux ! Après avoir mangé, vous rejoignez votre famille pour des activités amusantes au parc.",
  ];

  // Ajouter la scène pour choisir la salade de fruits et mettre à jour la liste _choices
  final List<List<String>> _choices = [
    ["Explorer le parc !"],
    ["Jouer au soccer", "Faire voler un cerf-volant"],
    ["Continuer vers le pique-nique"],
    ["Continuer"],
    ["Aider avec le cerf-volant", "Continuer à profiter du moment"],
    ["Continuer vers le pique-nique"],
    ["Continuer vers le pique-nique"],
    ["Sandwichs", "Salade de fruits"],
    ["Continuer"],
    ["Proposer une randonnée", "Proposer une visite au musée"],
    ["Continuer"],
    ["Continuer"],
    ["Terminer"],
    // Options après avoir choisi la salade de fruits
    ["Continuer"],
  ];


// Update the _nextSceneMap to include the new scene and choices
final Map<int, Map<int, int>> _nextSceneMap = {
  0: {0: 1}, 
  1: {0: 2, 1: 3},    // After choosing activity
  2: {0: 7},          // After playing soccer
  3: {0: 4},          // Choices after kite flying
  4: {0: 5, 1: 6},          // After helping with kite
  5: {0: 7},          // After helping with kite
  6: {0: 7},          // After ignoring kite
  7: {0: 8, 1: 13},    // After snacks choice
  8: {0: 9},          // After eating, suggest the next outing
  9: {0: 10, 1: 11},  // Suggestions for next outing
  10: {0: 12},        // Continue after hiking suggestion
  11: {0: 12},        // Continue after museum suggestion
  13: {0: 9},        // Continue after choosing fruit salad  
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
        if (_storyIndex == 12|| _storyIndex == 11|| _storyIndex == 10) {
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
        title: const Text('Family Day'),
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
                        if (_storyIndex >= 0 && _storyIndex <= 13)
                          Image.asset(
                            'assets/family0${_storyIndex + 1}.jpeg',
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
