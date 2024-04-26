import 'dart:math';
import 'ChatPage .dart';
import 'activites.dart';
import 'profile.dart';
import 'choix.dart';
import 'side_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'calender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autisme App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FacePage(useremailenfant: '', informations: {}),
    );
  }
}

class FacePage extends StatelessWidget {
  final String useremailenfant;
  final Map<String, dynamic> informations;

  const FacePage({
    Key? key,
    required this.useremailenfant,
    required this.informations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autismo'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: const Drawer(
        child: SideMenuPage(),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/autismoo.png",
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                CustomButton(
                  icon: Icons.event,
                  label: 'Événements',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CalendarPage(),
                      ),
                    );
                  },
                ),
                CustomButton(
                  icon: Icons.local_activity,
                  label: 'Activités',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ActivityPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          switch (index) {
            case 0:
              // Navigate to Home
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Choix(
                    userEmail: '', // Remplacez par la valeur appropriée
                    userName: '', // Remplacez par la valeur appropriée
                    informations: {},
                  ),
                ),
              );
              break;
            case 1:
              // Navigate to Chat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
              break;
            case 2:
              // Navigate to Resources
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
              break;
          }
        },
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function() onPressed;

  const CustomButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50.0, color: Colors.white),
            const SizedBox(height: 10.0),
            Text(label,
                style: const TextStyle(fontSize: 20.0, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
