import 'package:flutter/material.dart';

import 'ChatPage .dart';
import 'choix.dart';
import 'profile.dart';
import 'resources.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autisme App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FooterPage(),
      routes: {
        '/choix': (context) => const Choix(
              userEmail: '', // Remplacez par la valeur appropriée
              userName: '', // Remplacez par la valeur appropriée
              informations: {},
            ),
      },
    );
  }
}

class FooterPage extends StatefulWidget {
  const FooterPage({Key? key}) : super(key: key);

  @override
  State<FooterPage> createState() => _FooterPageState();
}

class _FooterPageState extends State<FooterPage> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    Choix(
      userEmail: '', // Remplacez par la valeur appropriée
      userName: '', // Remplacez par la valeur appropriée
      informations: {},
    ),
    ChatPage(),
    RessourcesPage(),
    UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autisme App'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
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
              title: Text('Home'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Chat'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Resources'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
