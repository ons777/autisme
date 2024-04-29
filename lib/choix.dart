<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ChatPage.dart';
import 'profile.dart';
import 'ressources.dart';
import 'side_menu.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    super.key,
    required this.informations,
    required this.userEmail,
    required this.userName,
  });

  @override
  _ChoixState createState() => _ChoixState();
}

class Enfant {
  final String emailenfant;
  final String motDePasse;
  final String pseudo;

  Enfant({
    required this.emailenfant,
    required this.motDePasse,
    required this.pseudo,
  });
}

class _ChoixState extends State<Choix> {
  List<Enfant> enfants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des enfants'),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      drawer: const Drawer(child: SideMenuPage()),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addEnfant,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 219, 146, 170),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              padding: const EdgeInsets.all(20.0),
            ),
            child: const Text('Ajouter Enfant'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: enfants.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(enfants[index].pseudo),
                  subtitle: Text(enfants[index].emailenfant),
                  onTap: () => _showEnfantDetails(context, enfants[index]),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> _addEnfant() async {
    final emailenfantMotDePasse = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => FormulaireDialog(userEmail: widget.userEmail),
    );
    if (emailenfantMotDePasse != null) {
      final nouvelEnfant = Enfant(
        emailenfant: emailenfantMotDePasse['emailenfant']!,
        motDePasse: emailenfantMotDePasse['motDePasse']!,
        pseudo: emailenfantMotDePasse['pseudo']!,
      );
      setState(() => enfants.add(nouvelEnfant));
      await ajouterEnfant(
        nouvelEnfant.pseudo,
        nouvelEnfant.emailenfant,
        nouvelEnfant.motDePasse,
        widget.userEmail,
      );
    }
  }

  Future<bool> ajouterEnfant(
      String pseudo, String emailenfant, String motDePasse, String emailParent) async {
    try {
      await FirebaseFirestore.instance.collection('enfants').add({
        'emailenfant': emailenfant,
        'motDePasse': motDePasse,
        'emailParent': emailParent,
        'pseudo': pseudo,
      });
      return true;
    } catch (error) {
      print('Error adding child: $error');
      return false;
    }
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        if (ModalRoute.of(context)!.settings.name != '/choix') {
          Navigator.pushNamed(context, '/choix');
        }
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const RessourcesPage()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
    }
  }

  void _showEnfantDetails(BuildContext context, Enfant enfant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Child Information'),
        content: Text('Email: ${enfant.emailenfant}\nPassword: ${enfant.motDePasse}\nPseudo: ${enfant.pseudo}'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
=======
import 'package:autisme_app/ChatPage%20.dart';
import 'package:autisme_app/profile.dart';
import 'face.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    super.key,
    required this.informations,
    required this.userEmail,
    required this.userName,
  });

  @override
  _ChoixState createState() => _ChoixState();
}

class Enfant {
  final String emailenfant;
  final String motDePasse;
  final String pseudo;

  Enfant(
      {required this.emailenfant,
      required this.motDePasse,
      required this.pseudo});
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
      drawer: const Drawer(
        child: SideMenuPage(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final emailenfantMotDePasse =
                  await showDialog<Map<String, String>>(
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
                final pseudo = emailenfantMotDePasse['pseudo']!;
                final nouvelEnfant = Enfant(
                    emailenfant: emailenfant,
                    motDePasse: motDePasse,
                    pseudo: pseudo);
                setState(() {
                  enfants.add(nouvelEnfant);
                });
                ajouterEnfant(
                    pseudo, emailenfant, motDePasse, widget.userEmail);
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 219, 146, 170),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              padding: const EdgeInsets.all(20.0),
            ),
            child: const Text('Ajouter Enfant'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: enfants.map((enfant) {
                  return ElevatedButton(
                    onPressed: () {
                      // Action lorsque le bouton de l'enfant est appuyé
                    },
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
                        const EdgeInsets.all(50.0),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(double.infinity, 5),
                      ),
                    ),
                    child: Text(
                      enfant
                          .pseudo, // Utilisez le pseudo de l'enfant comme texte du bouton
                      style: const TextStyle(fontSize: 30),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          switch (index) {
            case 0:
              // Vérifier si nous sommes déjà sur la page de choix
              if (ModalRoute.of(context)!.settings.name != '/choix') {
                // Nous ne sommes pas sur la page de choix, donc nous naviguons vers elle

                // Navigate to Home
                Navigator.pushNamed(context, '/choix');

                MaterialPageRoute(
                  builder: (context) => const Choix(
                    userEmail: '', // Remplacez par la valeur appropriée
                    userName: '', // Remplacez par la valeur appropriée
                    informations: {},
                  ),
                );
              }

              break;
            case 1:
              // Navigate to Chat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatPage()),
              );
              break;
            case 2:
              // Navigate to Resources
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
              break;
          }
        },
      ),
    );
  }

  Future<bool> ajouterEnfant(String emailenfant, String motDePasse,
      String emailParent, String pseudo) async {
    try {
      await FirebaseFirestore.instance.collection('enfants').add({
        'emailenfant': emailenfant,
        'motDePasse': motDePasse,
        'emailParent': emailParent,
        'pseudo': pseudo,
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

  const FormulaireDialog({super.key, required this.userEmail});

  get enfants => null;

  @override
  _FormulaireDialogState createState() => _FormulaireDialogState();
}

class _FormulaireDialogState extends State<FormulaireDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _pseudo;
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
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ajouter un enfant',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Pseudo',
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
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 20),
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
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: const OutlineInputBorder(
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
                    const SizedBox(height: 20),
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
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: const OutlineInputBorder(
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
                    const SizedBox(height: 20),
                    const Text('Genre:'),
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
                    const SizedBox(height: 20),
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
                            final succes = await ajouterEnfant(_pseudo,
                                _emailenfant, password.text, widget.userEmail);
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
          title: const Text("Succès"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> ajouterEnfant(String pseudo, String emailenfant,
      String motDePasse, String emailParent) async {
    print("object");
    try {
      print("try");
      await FirebaseFirestore.instance.collection('enfants').add({
        'pseudo': pseudo,
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
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
