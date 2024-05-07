import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'accountenfant.dart';
import 'loginenfant.dart';
import 'thememodel.dart';

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
      home: Settings2Page(),
    );
  }
}

class Settings2Page extends StatefulWidget {
  const Settings2Page({Key? key}) : super(key: key);

  @override
  _Settings2PageState createState() => _Settings2PageState();
}

class _Settings2PageState extends State<Settings2Page> {
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
            title: 'Dark Mode',
            subtitle: 'Enable dark theme for better night-time reading.',
            value: themeProvider.isDarkMode,
            onChanged: (bool value) async {
              setState(() {
                // Mettre à jour le thème de manière asynchrone
                themeProvider.toggleTheme(value);
              });
            },
          ),
          _buildSwitchTile(
            title: 'Enable Notifications',
            subtitle: 'Receive notifications for updates and announcements.',
            value: notificationEnabled,
            onChanged: (bool value) {
              setState(() {
                notificationEnabled = value;
              });
            },
          ),
          _buildSwitchTile(
            title: 'Show Activity Status',
            subtitle: 'Let others see when you’re active.',
            value: showActivityStatus,
            onChanged: (bool value) {
              setState(() {
                showActivityStatus = value;
              });
            },
          ),
          _buildListTile(
            title: 'Account',
            subtitle: 'Manage your account settings',
            icon: Icons.person,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AccountEnfantPage(
                    uid: '',
                  ),
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
                                  .collection('enfants')
                                  .doc(user.uid)
                                  .delete();
                              setState(() {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => LoginenfantPage(),
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
