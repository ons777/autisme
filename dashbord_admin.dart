import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'espace.dart';
import 'login.dart'; // Importez la page espace.dart

class AdminDashboardPage extends StatefulWidget {
  @override
  _AdminDashboardPageState createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  List<String> _childrenEmails = [];
  List<String> _parentEmails = [];

  @override
  void initState() {
    super.initState();
    _loadChildrenEmails();
    _loadParentEmails();
  }

  Future<void> _loadChildrenEmails() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('enfants').get();
      List<String> emails = snapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        _childrenEmails = emails;
      });
    } catch (e) {
      print('Erreur lors du chargement des emails des enfants: $e');
    }
  }

  Future<void> _loadParentEmails() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('parents').get();
      List<String> emails = snapshot.docs.map((doc) => doc.id).toList();
      setState(() {
        _parentEmails = emails;
      });
    } catch (e) {
      print('Erreur lors du chargement des emails des parents: $e');
    }
  }

  // Fonction de déconnexion
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EspacePage()),
      );
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Profil'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Paramètres'),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Se déconnecter',
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Déconnexion',
                      ),
                      content: Text(
                        'Voulez-vous vraiment vous déconnecter ?',
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Fermer la boîte de dialogue
                          },
                          child: Text(
                            'Non',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut(); // Se déconnecter
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EspacePage()),
                            ); // Naviguer vers la page de connexion
                          },
                          child: Text(
                            'Oui',
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Emails des enfants'),
                Tab(text: 'Emails des parents'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildEmailList(_childrenEmails),
                  _buildEmailList(_parentEmails),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailList(List<String> emails) {
    return ListView.builder(
      itemCount: emails.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(emails[index]),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteChildEmail(emails[index]);
            },
          ),
        );
      },
    );
  }

  Future<void> _deleteChildEmail(String email) async {
    try {
      // Supprimer l'email de la collection "enfants"
      await FirebaseFirestore.instance
          .collection('enfants')
          .doc(email)
          .delete();
      // Recharger la liste des emails des enfants
      await _loadChildrenEmails();
    } catch (e) {
      print('Erreur lors de la suppression de l\'email enfant: $e');
    }
  }
}
