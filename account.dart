import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      title: 'Account Settings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const UserProfile(),
    );
  }
}

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  String profileImageUrl = '';

  @override
  void dispose() {
    nameController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final user = auth.currentUser;

    if (user != null) {
      final DocumentSnapshot userSnapshot = await firestore.collection('users').doc(user.uid).get();
      final Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null) {
        nameController.text = userData['name'] ?? '';
        profileImageUrl = userData['profilePictureUrl'] ?? '';
        setState(() {}); // Trigger a rebuild to show the image
      }
    }
  }

  Future<void> updateProfile(String userId) async {
    final user = auth.currentUser;
    if (user != null) {
      try {
        // Update name in Firestore
        await firestore.collection('users').doc(userId).update({
          'name': nameController.text,
        });

        // Update password if the new password is provided
        if (newPasswordController.text.isNotEmpty) {
          await user.updatePassword(newPasswordController.text);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil mis à jour avec succès!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la mise à jour du profil: $e')),
        );
      }
    }
  }

  Widget buildTextField(String label, TextEditingController controller, IconData icon, Color borderColor) {
    return TextFormField(
      controller: controller,
      obscureText: label.toLowerCase().contains('mot de passe'), // Obscure if it's the password field
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: borderColor),
        labelText: label,
        labelStyle: TextStyle(color: borderColor),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
      ),
      style: TextStyle(color: borderColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: const Text('Compte'),
        ),
        body: const Center(child: Text("Utilisateur non authentifié")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Compte'),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Dream_clouds.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  CircleAvatar(
                    radius: 70.0,
                    backgroundImage: profileImageUrl.isNotEmpty ? NetworkImage(profileImageUrl) : null,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    child: profileImageUrl.isEmpty
                        ? const Icon(Icons.person, size: 70, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 30.0),
                  buildTextField('Nom', nameController, Icons.person, Colors.blueAccent),
                  const SizedBox(height: 16.0),
                  buildTextField('Nouveau mot de passe', newPasswordController, Icons.lock, Colors.blueAccent),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: () => updateProfile(user.uid),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text(
                      'Sauvegarder',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
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
