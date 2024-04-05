import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'formulaire.dart';
import 'face.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Utiliser 'async' pour pouvoir utiliser 'await' pour l'initialisation Firebase
  // Ajouter 'await' pour attendre l'initialisation de Firebase
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyClb3HXKi_0I9XMGs9Jhu175x-YEG-bL-Y",
    authDomain: "autisme-app.firebaseapp.com",
    projectId: "autisme-app",
    storageBucket: "autisme-app.appspot.com",
    messagingSenderId: "845131115457",
    appId: "1:845131115457:web:5b74a6ea7b06634dc49d40",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon application',
      home: const Choix(
          informations: {}), // Modification de l'argument informations
      routes: {
        '/formulaire': (context) => const FormulairePage(),
      },
    );
  }
}

class Choix extends StatelessWidget {
  final Map<String, String> informations;

  const Choix({super.key, required this.informations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enfant'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: informations.entries.map((entry) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FacePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 219, 146, 170),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: const EdgeInsets.all(50.0),
                      minimumSize: const Size(double.infinity, 5),
                    ),
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 30),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/formulaire');
          },
          label: const Text('Ajouter'),
          icon: const Icon(Icons.add),
          backgroundColor: const Color.fromARGB(255, 219, 146, 170),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
