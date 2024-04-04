import 'package:autisme/settings.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autisme/profile.dart';

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
            icon: Image.asset('assets/h.jpg'),
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
              leading: const Icon(Icons.settings),
              title: const Text('Welcome'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
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
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.border_color),
              title: const Text('Feedback'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
