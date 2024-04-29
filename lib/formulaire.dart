// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'choix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
}

class FormulairePage extends StatefulWidget {
  const FormulairePage({super.key});

  @override
  _FormulairePageState createState() => _FormulairePageState();
}

class _FormulairePageState extends State<FormulairePage> {
  final _formKey = GlobalKey<FormState>();

  String _pseudo = '';
  String _genre = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulaire'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage("assets/background.jpg"), // Chemin de votre image de fond
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
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre Email';
                    }
                    // Vérification de format email
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                  onSaved: (value) {
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mot de passe',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    // Limiter la longueur du mot de passe à 8 caractères
                    if (value.length >= 8) {
                      return 'Le mot de passe ne doit pas infirieur à 8 caractères';
                    }
                    return null;
                  },
                  onSaved: (value) {
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Naviguer vers la page de choix avec le pseudo
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Choix(
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
}
