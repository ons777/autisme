import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login.dart';
import 'thememodel.dart';
import 'account.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Montserrat',
      ),
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationEnabled = true;
  bool showActivityStatus = true;
  bool showMessage = false; // Nouvelle variable pour le message de succès

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramètres'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<ThemeModel>(builder: (context, themeProvider, _) {
        return ListView(padding: const EdgeInsets.all(16.0), children: <Widget>[
          _buildSwitchTile(
            title: 'Mode sombre',
            subtitle: 'Activer le thème sombre pour une meilleure lecture nocturne.',
            value: themeProvider.isDarkMode,
            onChanged: (bool value) async {
              setState(() {
                // Mettre à jour le thème de manière asynchrone
                themeProvider.toggleTheme(value);
              });
            },
          ),
          _buildSwitchTile(
            title: 'Activer les notifications',
            subtitle: 'Recevez des notifications pour les mises à jour et les annonces.',
            value: notificationEnabled,
            onChanged: (bool value) {
              setState(() {
                notificationEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            title: 'Afficher l’état de l’activité',
            subtitle: 'Laissez les autres voir quand vous êtes actif.',
            value: showActivityStatus,
            onChanged: (bool value) {
              setState(() {
                showActivityStatus = value;
              });
            },
          ),
          _buildListTile(
            title: 'Compte',
            subtitle: 'Gérer les paramètres de votre compte',
            icon: Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfile(),
                ),
              );
            },
          ),
          _buildListTile(
            title: 'Supprimer le compte',
            subtitle: '',
            icon: Icons.delete,
            onTap: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirmation'),
                    content: Text(
                      'Êtes-vous sûr de vouloir supprimer votre compte ?',
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () async {
                          try {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              await user.delete();
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .delete();
                              setState(() {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                                showMessage =
                                    true; // Activer le message de succès
                              });
                            }
                          } catch (error) {
                            print(
                                'Erreur lors de la suppression du compte: $error');
                          }
                        },
                        child: Text('Oui'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Non'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ]);
      }),
      bottomNavigationBar: showMessage
          ? BottomAppBar(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                color: Colors.green, // Couleur du message de succès
                child: Text(
                  'Compte supprimé avec succès',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          : null,
    );
  }
}

Widget _buildSwitchTile({
  required String title,
  String? subtitle,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return SwitchListTile(
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: subtitle != null ? Text(subtitle) : null,
    value: value,
    onChanged: onChanged,
  );
}

ListTile _buildListTile({
  required String title,
  required String subtitle,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return ListTile(
    title: Text(title),
    subtitle: Text(subtitle),
    leading: Icon(icon),
    onTap: onTap,
  );
}
