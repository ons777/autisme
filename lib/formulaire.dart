import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importez le package Firestore
import 'choix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autismo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FormulairePage(),
    );
  }
}

class FormulairePage extends StatefulWidget {
  const FormulairePage({Key? key}) : super(key: key);

  @override
  _FormulairePageState createState() => _FormulairePageState();
}

class _FormulairePageState extends State<FormulairePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Initialisation de Firestore

  String _pseudo = '';
  String _genre = '';
  String _randomCode = '';
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/background.jpg"), // Chemin de votre image de fond
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pseudo',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre pseudo';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _pseudo = value!;
                    _randomCode = value!;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Genre:'),
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: 'garçon',
                      groupValue: _genre,
                      onChanged: (value) {
                        setState(() {
                          _genre = value!;
                        });
                      },
                    ),
                    const Text('Garçon'),
                    Radio<String>(
                      value: 'fille',
                      groupValue: _genre,
                      onChanged: (value) {
                        setState(() {
                          _genre = value!;
                        });
                      },
                    ),
                    const Text('Fille'),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Générer un code aléatoire
                        _randomCode = generateRandomCode();

                        // Enregistrement des données dans Firestore
                        DocumentReference docRef =
                            await _firestore.collection('users').add({
                          'pseudo': _pseudo,
                          'code_aléatoire': _randomCode,
                          'genre': _genre,
                        });

                        String docId = docRef
                            .id; // Récupération de l'ID du document ajouté

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Choix(
                              userEmail:
                                  '', // Remplacez par la valeur appropriée
                              userName:
                                  '', // Remplacez par la valeur appropriée
                              informations: {
                                "pseudo": _pseudo,
                              },
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text('Valider'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateRandomCode() {
    const characters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final code = String.fromCharCodes(Iterable.generate(
        6, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
    return code;
  }
}
