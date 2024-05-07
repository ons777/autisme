import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'choix.dart';
import 'thememodel.dart';

void main() async {
  runApp(
    ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Montserrat',
        ),
        home: FormulaireDialog(
          userEmail: '',
        ),
      ),
    ),
  );
}

class FormulaireDialog extends StatefulWidget {
  final String userEmail;

  FormulaireDialog({Key? key, required this.userEmail}) : super(key: key);

  get enfants => null;

  @override
  _FormulaireDialogState createState() => _FormulaireDialogState();
}

class _FormulaireDialogState extends State<FormulaireDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _pseudo;
  late String _emailenfant;
  late String _motDePasse;
  String? _genre;
  bool _isObscure = true;
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isValidEmail(String emailenfant) {
    final emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$");
    return emailRegExp.hasMatch(emailenfant);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, themeProvider, child) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      );
    });
  }

  contentBox(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, themeProvider, child) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: themeProvider.isDarkMode ? Colors.grey[900] : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode
                      ? Colors.grey[900]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ajouter un enfant',
                      style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Color.fromARGB(255, 80, 142, 209)),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: themeProvider.isDarkMode
                            ? Colors.grey[200]
                            : Colors.grey[900],
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Pseudo',
                          labelStyle: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 7, 155, 205)),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir un pseudo';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _pseudo = value!;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'emailenfant',
                          labelStyle: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 7, 155, 205)),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir un emailenfant';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _emailenfant = value!;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          labelStyle: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure; // Inverse l'état
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 7, 155, 205)),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        controller: password,
                        validator: (value) {
                          if (password.text == "") {
                            return 'Veuillez saisir un mot de passe';
                          }
                          return null;
                        },
                        // onSaved: (value) {
                        //   _motDePasse = value!;
                        // },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        obscureText: _isObscure, // Masque le texte par défaut
                        decoration: InputDecoration(
                          labelText: 'Confirmer le mot de passe',
                          labelStyle: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure; // Inverse l'état
                              });
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 7, 155, 205)),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        controller: confirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir à nouveau le mot de passe';
                          }
                          if (confirmPassword.text != password.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                        // onSaved: (value) {
                        //   _confirmationMotDePasse = value!;
                        // },
                      ),
                      SizedBox(height: 20),
                      Text('Genre:'),
                      Row(
                        children: <Widget>[
                          Radio<String>(
                            value: 'garçon',
                            groupValue: _genre,
                            onChanged: (value) {
                              setState(() {
                                _genre = value;
                              });
                            },
                          ),
                          const Text('Garçon'),
                          Radio<String>(
                            value: 'fille',
                            groupValue: _genre,
                            onChanged: (value) {
                              setState(() {
                                _genre = value;
                              });
                            },
                          ),
                          const Text('Fille'),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            print("dkhalna");
                            print(password.text);
                            final form = _formKey.currentState;
                            if (form != null &&
                                _formKey.currentState!.validate()) {
                              print("true");
                              form.save();
                              final succes = await ajouterEnfant(
                                  _pseudo,
                                  _emailenfant,
                                  password.text,
                                  widget.userEmail);
                              // Utilisez la variable succes pour prendre des mesures appropriées en fonction du résultat de l'ajout d'enfant
                              print("await");
                              if (succes) {
                                print("succes");
                                afficherMessage(
                                    context, 'Enfant ajouté avec succès');
                              } else {
                                print("err");
                                afficherMessage(context,
                                    'Erreur lors de l\'ajout de l\'enfant à Firestore');
                              }
                            } else {
                              print("false");
                              print(form != null);
                              print(_formKey.currentState!.validate());
                            }
                          },
//                        onPressed: _validerFormulaire,
                          child: const Text('Valider'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _validerFormulaire() async {
    final form = _formKey.currentState;
    if (form != null && _formKey.currentState!.validate()) {
      form.save();
      final succes = await ajouterEnfant(
          _pseudo, _emailenfant, _motDePasse, widget.userEmail);
      if (succes) {
        setState(() {
          // Ajouter l'enfant à la liste d'enfants

          widget.enfants.add(Enfant(
            emailenfant: _emailenfant,
            motDePasse: _motDePasse,
            pseudo: _pseudo,
            emailParent: widget.userEmail,
          ));
        });

        // Afficher un message de succès
        afficherMessage(context, 'Enfant ajouté avec succès à Firestore !');
      } else {
        afficherMessage(
            context, 'Erreur lors de l\'ajout de l\'enfant à Firestore');
      }
    }
  }

  void afficherMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Succès"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> ajouterEnfant(String pseudo, String emailenfant,
      String motDePasse, String emailParent) async {
    try {
      // Crée un nouvel ID de document
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('enfants').doc();

      // Ajouter l'enfant dans l'espace d'authentification
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailenfant, password: motDePasse);

      // Récupérer l'ID de l'utilisateur créé
      String? uid = userCredential.user?.uid;

      // Vérifier si l'ID de l'utilisateur est valide
      if (uid != null) {
        // Ajoute les données à Firestore
        await docRef.set({
          'uid': uid, // Utilisez l'ID de l'utilisateur créé dans Firebase Auth
          'pseudo': pseudo,
          'emailenfant': emailenfant,
          'motDePasse': motDePasse,
          'emailParent': emailParent,
        });

        print(
            'Enfant ajouté avec succès à Firestore avec l\'ID: ${docRef.id} !');
        return true; // Retourne vrai si l'enfant est ajouté avec succès
      } else {
        print(
            'Erreur lors de la récupération de l\'ID de l\'utilisateur créé.');
        return false; // Retourne faux en cas d'échec
      }
    } catch (error) {
      print('Erreur lors de l\'ajout de l\'enfant à Firestore : $error');
      return false; // Retourne faux en cas d'erreur
    }
  }
}
