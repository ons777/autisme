import 'package:autisme_app/login.dart';
import 'package:flutter/material.dart';
import 'login.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Page de Boutons',
      home: EspacePage(),
    );
  }
}

class EspacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              'assets/choix.jpg',
              fit: BoxFit.cover,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              print('Parent Space Button Pressed');
            },
            child: Text('Espace de Parent'),
          ),
          ElevatedButton(
            onPressed: () {
               Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              print('Child Space Button Pressed');
            },
            child: Text('Espace de Enfant'),
          ),
        ],
      ),
    );
  }
}
