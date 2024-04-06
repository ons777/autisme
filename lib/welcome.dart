import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autisme App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        title: Text('Welcome'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/welcome.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 170),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Bienvenue dans notre application conçue spécifiquement pour les enfants autistes et leurs parents. Notre application vise à soutenir les enfants autistes dans le maintien de leurs routines et à leur fournir un sentiment de structure. Les parents peuvent utiliser lapplication pour vérifier facilement leurs enfants et se connecter avec dautres parents faisant face à des défis similaires. Ensemble, nous pouvons créer une communauté de soutien et permettre aux familles de naviguer à travers les expériences uniques délever des enfants avec autisme.',
                        style: TextStyle(
                          color: Color.fromARGB(255, 24, 92, 186),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
