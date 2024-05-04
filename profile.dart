import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings.dart';
import 'thememodel.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Montserrat',
        ),
        home: ProfilePage(),
      ),
    ),
  );
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final userUID = FirebaseAuth.instance.currentUser?.uid;
    return Consumer<ThemeModel>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          backgroundColor:
              themeProvider.isDarkMode ? Colors.grey[900] : Colors.grey[200],
          appBar: AppBar(
            title: Text(
              'Profile',
              style: TextStyle(
                  color:
                      themeProvider.isDarkMode ? Colors.white : Colors.black),
            ),
            backgroundColor:
                themeProvider.isDarkMode ? Colors.grey[900] : Colors.grey[200],
            leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color:
                      themeProvider.isDarkMode ? Colors.white : Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings,
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          body: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userUID)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (userSnapshot.hasError) {
                return Center(child: Text("Error: ${userSnapshot.error}"));
              }
              if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                return const Center(child: Text("User does not exist"));
              }
              var userData = userSnapshot.data!.data() as Map<String, dynamic>;

              // Fetch child's data using the parent's email
              final parentEmail = userData['email'] as String;
              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('enfants')
                    .where('emailParent', isEqualTo: parentEmail)
                    .get(),
                builder: (context, enfantSnapshot) {
                  if (enfantSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (enfantSnapshot.hasError) {
                    return Center(
                        child: Text("Error: ${enfantSnapshot.error}"));
                  }
                  final QuerySnapshot<Map<String, dynamic>> querySnapshot =
                      enfantSnapshot.data!
                          as QuerySnapshot<Map<String, dynamic>>;
                  if (querySnapshot.docs.isEmpty) {
                    return const Center(child: Text("Child does not exist"));
                  }
                  return ListView(
                    children: [
                      _buildHeader(context, userData),
                      for (var doc in querySnapshot.docs)
                        _buildUserInfo(doc.data(), context),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> userData) {
    final themeProvider = Provider.of<ThemeModel>(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode
            ? Colors.grey[900]
            : Theme.of(context).primaryColorDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(userData['profilePictureUrl'] ?? ''),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData['name'] ?? 'Name unavailable',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                userData['email'] ?? 'Email unavailable',
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

  Widget _buildUserInfo(Map<String, dynamic> enfantData, BuildContext context) {
    final themeProvider = Provider.of<ThemeModel>(context);
    return Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        color: themeProvider.isDarkMode ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Child Information',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 16),
              Text(
                'Email: ${enfantData['emailenfant'] ?? 'No email available'}',
                style: TextStyle(
                    fontSize: 16,
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'Password: ${enfantData['motDePasse'] ?? 'No password available'}',
                style: TextStyle(
                    fontSize: 16,
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 8),
              Text(
                'Pseudo: ${enfantData['pseudo'] ?? 'No pseudo available'}',
                style: TextStyle(
                    fontSize: 16,
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
