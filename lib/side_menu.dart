import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login.dart';
import '../welcome.dart';
import '../settings.dart';
import '../profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autisme App',
      home: const SideMenuPage(),
    );
  }
}

class SideMenuPage extends StatefulWidget {
  const SideMenuPage({Key? key}) : super(key: key);

  @override
  _SideMenuPageState createState() => _SideMenuPageState();
}

class _SideMenuPageState extends State<SideMenuPage> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    // Votre logique de récupération des informations utilisateur ici
    // Par exemple :
    userName = '';
    userEmail = '';
  }

  Future<String> fetchUserProfilePicture() async {
    // Code pour récupérer l'image du profil de l'utilisateur
    return 'path_vers_l_image'; // Remplacez par le chemin réel de l'image
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              userName.isNotEmpty ? userName : 'Loading...',
              style: const TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              userEmail.isNotEmpty ? userEmail : 'Loading...',
              style: const TextStyle(color: Colors.black),
            ),
            currentAccountPicture: FutureBuilder<String>(
              future: fetchUserProfilePicture(), // Fetch user profile picture
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return CircleAvatar(
                    backgroundImage: AssetImage(
                        snapshot.data!), // Display user profile picture
                  );
                } else {
                  return const CircleAvatar(
                    backgroundImage: AssetImage(
                        'assets/default_profile_picture.jpg'), // Placeholder image
                  );
                }
              },
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/b1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.handshake_rounded),
            title: const Text('Bienvenue'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Paramètres'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Se déconnecter'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
