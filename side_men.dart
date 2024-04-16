import 'package:autisme_app/login.dart';
import 'package:flutter/material.dart';
import 'settings.dart';
import 'profile.dart';
import 'face.dart';
import 'formulaire.dart';

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
        informations: {}, // Remplacez par la valeur appropriée
      ),
      routes: {
        '/formulaire': (context) => FormulairePage(),
      },
    );
  }
}

class SideMenuPage extends StatelessWidget {
  final Map<String, String> informations;
  final String userEmail;
  final String userName;

  const SideMenuPage({
    required this.informations,
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
                backgroundImage: AssetImage('assets/back.jpeg'),
              ),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/b1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
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
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: informations.entries.map((entry) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FacePage()),
                      );
                    },
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 219, 146, 170),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity, 0),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, '/formulaire');
          },
          label: const Text('Ajouter'),
          icon: const Icon(Icons.add),
          backgroundColor: const Color.fromARGB(255, 219, 146, 170),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
