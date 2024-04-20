import 'package:flutter/material.dart';
import 'side_menu.dart';
import 'face.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autismo',
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

class _ChoixState extends State<Choix> {
  List<String> enfants = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enfant'),
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
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: enfants.map((pseudo) {
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Informations sur $pseudo'),
                          // Afficher les informations supplémentaires sur l'enfant ici
                        ),
                      );
                    },
                    child: Text(
                      pseudo,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final pseudo = await showDialog<String>(
            context: context,
            builder: (context) => FormulaireDialog(),
          );
          if (pseudo != null) {
            setState(() {
              enfants.add(pseudo);
            });
          }
        },
        label: const Text('Ajouter'),
        icon: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 219, 146, 170),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class FormulaireDialog extends StatefulWidget {
  const FormulaireDialog({Key? key}) : super(key: key);

  @override
  _FormulaireDialogState createState() => _FormulaireDialogState();
}

class _FormulaireDialogState extends State<FormulaireDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _pseudo;
  late String _motDePasse;
  String? _genre;

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
                        labelText: 'Pseudo',
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez saisir un mot de passe';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _motDePasse = value!;
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
                    ElevatedButton(
                      onPressed: _validerFormulaire,
                      child: const Text('Valider'),
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

  void _validerFormulaire() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      Navigator.of(context).pop(_pseudo);
    }
  }
}
