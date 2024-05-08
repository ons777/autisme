import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'account.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<DocumentSnapshot> fetchUserData(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Profil'),
        ),
        body: const Center(child: Text("Utilisateur non authentifié")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
              setState(() {}); // Trigger refresh on returning
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchUserData(user.uid),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userSnapshot.hasError) {
            return Center(child: Text("Erreur: ${userSnapshot.error}"));
          }
          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(child: Text("L'utilisateur n'existe pas"));
          }

          var userData = userSnapshot.data!.data() as Map<String, dynamic>;
          final parentEmail = userData['email'] as String?;

          return parentEmail == null
              ? const Center(child: Text("Email du parent non disponible"))
              : FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('enfants')
                      .where('emailParent', isEqualTo: parentEmail)
                      .get(),
                  builder: (context, enfantSnapshot) {
                    if (enfantSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (enfantSnapshot.hasError) {
                      return Center(child: Text("Erreur: ${enfantSnapshot.error}"));
                    }

                    final List<QueryDocumentSnapshot> enfantsDocs = enfantSnapshot.data?.docs ?? [];
                    return ListView(
                      children: [
                        _buildHeader(context, userData),
                        const SizedBox(height: 20),
                        for (var doc in enfantsDocs) _buildUserInfo(doc.data() as Map<String, dynamic>),
                      ],
                    );
                  },
                );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> userData) {
    final String? profilePictureUrl = userData['profilePictureUrl'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColorDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 70.0,
            backgroundImage: profilePictureUrl != null && profilePictureUrl.isNotEmpty
                ? NetworkImage(profilePictureUrl)
                : null,
            backgroundColor: Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData['name'] ?? 'Nom indisponible',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                userData['email'] ?? 'Email indisponible',
                style: TextStyle(
                  color: Colors.white.withAlpha(200),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> enfantData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informations de l\'enfant',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
              ),
              const Divider(),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.person, 'Pseudo:', enfantData['pseudo']),
              _buildInfoRow(Icons.email, 'Email:', enfantData['emailenfant']),
              _buildInfoRow(Icons.password, 'Mot de passe:', enfantData['motDePasse']),
              _buildInfoRow(Icons.calendar_today, 'Anniversaire:', enfantData['anniversaire']),
              _buildInfoRow(Icons.school, 'Classe:', enfantData['classe']),
              _buildInfoRow(Icons.color_lens, 'Couleur préférée:', enfantData['favoriteColor']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blueAccent),
                ),
                Flexible(
                  child: Text(
                    value ?? 'Non disponible',
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
