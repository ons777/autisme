import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'side_menu.dart';
import 'face.dart';
import 'dart:ui'; // Pour utiliser les images locales

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autisme App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Choix(
        userEmail: '',
        userName: '',
        informations: {},
      ),
    );
  }
}

class Choix extends StatefulWidget {
  final Map<String, String> informations;
  final String userEmail;
  final String userName;

  const Choix({
    Key? key,
    required this.informations,
    required this.userEmail,
    required this.userName,
  }) : super(key: key);

  @override
  _ChoixState createState() => _ChoixState();
}

class Enfant {
  final String emailenfant;
  final String motDePasse;

  Enfant({required this.emailenfant, required this.motDePasse});
}

class _ChoixState extends State<Choix> {
  List<Enfant> enfants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des enfants'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: SideMenuPage(),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final emailenfantMotDePasse = await showDialog<Map<String, String>>(
                context: context,
                builder: (context) =>
                    FormulaireDialog(userEmail: widget.userEmail),
              );
              print("emailenfantMotDePasse != null");
              print(emailenfantMotDePasse != null);
              print("emailenfantMotDePasse != null");
              if (emailenfantMotDePasse != null) {
                final emailenfant = emailenfantMotDePasse['emailenfant']!;
                final motDePasse = emailenfantMotDePasse['motDePasse']!;
                final nouvelEnfant =
                    Enfant(emailenfant: emailenfant, motDePasse: motDePasse);
                setState(() {
                  enfants.add(nouvelEnfant);
                });
                ajouterEnfant(emailenfant, motDePasse, widget.userEmail);
              }
            },
            child: const Text('Ajouter Enfant'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 219, 146, 170),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              padding: const EdgeInsets.all(20.0),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: enfants.map((enfant) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Choix(
                                  informations: {},
                                  userEmail: widget.userEmail,
                                  userName: widget.userName,
                                )),
                      );
                    },
                    child: Text(
                      enfant.emailenfant,
                      style: const TextStyle(fontSize: 30),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 219, 146, 170),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(50.0),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity, 5),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Future<bool> ajouterEnfant(
      String emailenfant, String motDePasse, String emailParent) async {
    try {
      await FirebaseFirestore.instance.collection('enfants').add({
        'emailenfant': emailenfant,
        'motDePasse': motDePasse,
        'emailParent': emailParent,
      });
      print('Enfant ajouté avec succès à Firestore !');
      return true; // Retourne vrai si l'enfant est ajouté avec succès
    } catch (error) {
      print('Erreur lors de l\'ajout de l\'enfant à Firestore : $error');
      return false; // Retourne faux en cas d'erreur
    }
  }
}

class FormulaireDialog extends StatefulWidget {
  final String userEmail;

  FormulaireDialog({Key? key, required this.userEmail}) : super(key: key);

  @override
  _FormulaireDialogState createState() => _FormulaireDialogState();
}

class _FormulaireDialogState extends State<FormulaireDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _emailenfant;
  late String _motDePasse;
  late String _confirmationMotDePasse;
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ajouter un enfant',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
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
                        labelText: 'emailenfant',
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
                                _emailenfant, password.text, widget.userEmail);
                            // Utilisez la variable succes pour prendre des mesures appropriées en fonction du résultat de l'ajout d'enfant
                            print("await");
                            if (succes) {
                              print("succes");
                              afficherMessage(context,
                                  'Enfant ajouté avec succès');
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
  }

  void _validerFormulaire() async {
    final form = _formKey.currentState;
    if (form != null && _formKey.currentState!.validate()) {
      form.save();
      final succes =
          await ajouterEnfant(_emailenfant, _motDePasse, widget.userEmail);
      // Utilisez la variable succes pour prendre des mesures appropriées en fonction du résultat de l'ajout d'enfant
      print("await");
      if (succes) {
        print("succes");
        afficherMessage(context, 'Enfant ajouté avec succès à Firestore !');
      } else {
        print("err");
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

  Future<bool> ajouterEnfant(
      String emailenfant, String motDePasse, String emailParent) async {
    print("object");
    try {
      print("try");
      await FirebaseFirestore.instance.collection('enfants').add({
        'emailenfant': emailenfant,
        'motDePasse': motDePasse,
        'emailParent': emailParent,
      });
      print('Enfant ajouté avec succès à Firestore !');
      return true; // Retourne vrai si l'enfant est ajouté avec succès
    } catch (error) {
      print('Erreur lors de l\'ajout de l\'enfant à Firestore : $error');
      return false; // Retourne faux en cas d'erreur
    }
  }
}
