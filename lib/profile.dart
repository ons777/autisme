// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
    return const MaterialApp(
      home: UserProfile(), // Display the UserProfile widget as the home page
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

  String firstName = ''; // Removed initial value
  String lastName = ''; // Removed initial value
  int age = 0; // Removed initial value
  String email = ''; // Removed initial value
  String sexe = ''; // Removed initial value

  @override
  void initState() {
    super.initState();
    getUserData('9Ksk5CiL3veqw1KHWiWh'); // Replace with actual user ID
  }

  Future<void> getUserData(String userId) async {
    final docRef = firestore.collection('users').doc(userId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        firstName = data?['firstName'] ?? ''; // Handle missing data with empty string
        lastName = data?['lastName'] ?? '';
        age = data?['age']?.toInt() ?? 0; // Convert age to int and handle null values
        email = data?['email'] ?? '';
        sexe = data?['sexe'] ?? '';
      });
      print('Fetched user data: $data'); // Print retrieved data to console for debugging
    } else {
      print('No user data found!');
      // Handle the case where the document doesn't exist
    }
  }

  Widget buildInfoCard(String title, String content) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              content,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent.shade100,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade700,
        title: const Text(
          'My Cute Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile picture with rounded corners
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 50.0,
              ),
            ),
            // Username section
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  color: Colors.pinkAccent.shade700,
                  size: 16.0,
                ),
                const SizedBox(width: 8.0),
                Text(
                  '$firstName $lastName',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
            // Divider with a cute pattern
            Divider(
              color: Colors.pinkAccent.shade400,
              thickness: 1.0,
              indent: 30.0,
              endIndent: 30.0,
              height: 20.0,
            ),
            // Info cards with rounded corners
            Padding(
              padding: const EdgeInsets.all(8.0
),
              child: Column(
                children: [
                  buildInfoCard('Age', age.toString()), // Call the renamed function
                  const SizedBox(height: 8.0),
                  buildInfoCard('Email', email),
                  const SizedBox(height: 8.0),
                  buildInfoCard('Sexe', sexe), // Assuming 'Sexe' is the intended label
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
