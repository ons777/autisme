import 'package:autisme_app/login.dart';
import 'package:autisme_app/welcome.dart';
import 'package:flutter/material.dart';
import '../settings.dart';
import '../profile.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon application',
      home: const SideMenuPage(
        userEmail: '', // Remplacez par la valeur appropriée
        userName: '', // Remplacez par la valeur appropriée
      ),
    );
  }
}

class SideMenuPage extends StatelessWidget {
  final String userEmail;
  final String userName;

  const SideMenuPage({
    required this.userEmail,
    required this.userName,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                userName.isEmpty ? 'Your Name' : userName,
                style: const TextStyle(color: Colors.black),
              ),
              accountEmail: Text(
                userEmail.isEmpty ? 'your_email@example.com' : userEmail,
                style: const TextStyle(color: Colors.black),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/background.jpg'),
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/b1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.handshake),
              title: const Text('Welcome'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
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
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.border_color),
              title: const Text('avis'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Se déconnecter'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
