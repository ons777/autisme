// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ChatPage.dart';
import 'activites.dart';
import 'formulaire.dart';
import 'profile.dart';
import 'ressources.dart';
import 'side_menu.dart';
import 'thememodel.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider<ThemeModel>(
        create: (_) => ThemeModel(),
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Montserrat',
          ),
          home: const Choix(
            userEmail: '',
            userName: '',
            informations: {},
          ),
        ),
      ),
    );

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
  final String emailParent;

  Enfant({
    required this.emailenfant,
    required this.motDePasse,
    required this.pseudo,
    required this.emailParent,
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
    return Consumer<ThemeModel>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor:
              themeProvider.isDarkMode ? Colors.grey[900] : Colors.grey[200],
          appBar: AppBar(
            title: Text(
              'Liste des enfants',
              style: TextStyle(
                color:
                    themeProvider.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            elevation: 0,
            backgroundColor:
                themeProvider.isDarkMode ? Colors.grey[900] : Colors.grey[200],
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color:
                      themeProvider.isDarkMode ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
          drawer: const Drawer(child: SideMenuPage()),
          body: Stack(
            children: [
              // Background Image
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Dream_clouds.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => _addEnfant(getEmail!),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 80, 142, 209),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    icon: const Icon(Icons.add, size: 24),
                    label: const Text(
                      'Ajouter Enfant',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Create a stream builder to load all enfant under the user connected
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('enfants')
                          .where('emailParent', isEqualTo: getEmail)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              'Aucun enfant trouvé.',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          );
                        }

                        // Display enfants in a list
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document =
                                snapshot.data!.docs[index];
                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;

                            return Card(
                              color: themeProvider.isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.blueAccent,
                                  child: Icon(Icons.child_care,
                                      color: Colors.white),
                                ),
                                title: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${data['pseudo']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                // Set destination widget when clicking on
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ActivityPage(),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: themeProvider.isDarkMode
                ? Colors.grey[900]
                : Colors.grey[200],
            type: BottomNavigationBarType.shifting,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
                label: 'Chat',
                backgroundColor: themeProvider.isDarkMode
                    ? Colors.grey[900]
                    : Colors.grey[200],
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.folder,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
                label: 'Resources',
                backgroundColor: themeProvider.isDarkMode
                    ? Colors.grey[900]
                    : Colors.grey[200],
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  color: themeProvider.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
                label: 'Profile',
                backgroundColor: themeProvider.isDarkMode
                    ? Colors.grey[900]
                    : Colors.grey[200],
              ),
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
        );
      },
    );
  }

  Future<void> _addEnfant(String emailParent) async {
    final emailenfantMotDePasse = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => FormulaireDialog(userEmail: emailParent),
    );
    if (emailenfantMotDePasse != null) {
      final nouvelEnfant = Enfant(
        emailenfant: emailenfantMotDePasse['emailenfant']!,
        motDePasse: emailenfantMotDePasse['motDePasse']!,
        pseudo: emailenfantMotDePasse['pseudo']!,
        emailParent: emailParent,
      );
      setState(() => enfants.add(nouvelEnfant));
      await ajouterEnfant(
        nouvelEnfant.pseudo,
        nouvelEnfant.emailenfant,
        nouvelEnfant.motDePasse,
        nouvelEnfant.emailParent,
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const ChatPage()));
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RessourcesPage()));
        break;
      case 2:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
    }
  }
}
