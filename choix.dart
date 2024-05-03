import 'package:autisme_app/activites.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ChatPage .dart';
import 'formulaire.dart';
import 'profile.dart';
import 'ressources.dart';
import 'side_menu.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

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
  late String userUID;

  // Get current user loggzed in email address
  User? user = FirebaseAuth.instance.currentUser;
  String? getEmail = FirebaseAuth.instance.currentUser?.email;

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
      drawer: const Drawer(child: SideMenuPage()),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _addEnfant,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 80, 142, 209),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              ),
              padding: const EdgeInsets.all(20.0),
            ),
            child: const Text('Ajouter Enfant'),
          ),
          const SizedBox(height: 20),
          // create a stream builer to load all enfant under the user connected
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('enfants')
                .where('emailParent', isEqualTo: getEmail)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text('Aucun enfant trouvé.'),
                );
              }

              // display enfants in a list
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  return Card(
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email enfant:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ), // Mettre en gras
                          ),
                          Text('${data['emailenfant']}'),
                          SizedBox(height: 8), // Espacement

                          Text(
                            'Pseudo:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ), // Mettre en gras
                          ),
                          Text('${data['pseudo']}'),
                        ],
                      ),
                      // set destination widget when clicking on enfant
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ActivityPage(),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          )),
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
      builder: (context) => FormulaireDialog(userEmail: 'email@example.com'),
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
        'email@example.com',
      );
    }
  }

  Future<bool> ajouterEnfant(String pseudo, String emailenfant,
      String motDePasse, String emailParent) async {
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ChatPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RessourcesPage()));
        break;
      case 3:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
    }
  }

  void _showEnfantDetails(BuildContext context, Enfant enfant) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(enfant.pseudo),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email: ${enfant.emailenfant}'),
              // Add more details as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
