import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'side_men.dart';
import 'formulaire.dart';
import 'face.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Otismo',
      home: const Choix(
        userEmail: '',
        userName: '',
        informations: {},
      ),
      routes: {
        '/formulaire': (context) => FormulairePage(),
      },
    );
  }
}

class Choix extends StatelessWidget {
  final Map<String, String> informations;
  final String userEmail;
  final String userName;

  const Choix({
    Key? key,
    required this.informations,
    required this.userEmail,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enfant'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: SideMenuPage(
          userEmail: userEmail,
          userName: userName,
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
                      style: const TextStyle(fontSize: 30),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 219, 146, 170),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.all(50.0),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(double.infinity, 5),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FormulairePage()),
            );
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
