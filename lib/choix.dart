import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ChatPage.dart';
import 'formulaire.dart';
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
              backgroundColor: Color.fromARGB(255, 219, 146, 170),
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
