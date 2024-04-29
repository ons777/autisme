// ignore_for_file: prefer_const_constructors, avoid_print, library_private_types_in_public_api

import 'dart:math';
<<<<<<< HEAD
import 'ChatPage.dart';
import 'activites.dart';
import 'login.dart';
import 'profile.dart';
import 'settings.dart';
import 'welcome.dart';
=======
import 'ChatPage .dart';
import 'choix.dart';
import 'side_menu.dart';
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'calender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Autisme App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
<<<<<<< HEAD
      home: const FacePage(useremailenfant: '', informations: {},),
=======
      home: const FacePage(useremailenfant: '', informations: {}),
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
    );
  }
}

class FacePage extends StatelessWidget {
<<<<<<< HEAD
  const FacePage({super.key, required String useremailenfant, required Map informations});
=======
  final String useremailenfant;
  final Map<String, dynamic> informations;

  const FacePage({
    super.key,
    required this.useremailenfant,
    required this.informations,
  });
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18

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
<<<<<<< HEAD
                MaterialPageRoute(builder: (context) => const FacePage(useremailenfant: '', informations: {},)),
=======
                MaterialPageRoute(
                  builder: (context) => Choix(
                    userEmail: '', // Remplacez par la valeur appropriée
                    userName: '', // Remplacez par la valeur appropriée
                    informations: const {},
                  ),
                ),
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
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

<<<<<<< HEAD
class SideMenuContent extends StatefulWidget {
  const SideMenuContent({super.key});

  @override
  _SideMenuContentState createState() => _SideMenuContentState();
}

class _SideMenuContentState extends State<SideMenuContent> {
  String userName = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  // List of profile picture file names
  List<String> profilePictures = [
    'gnome1.jpg',
    'gnome2.jpg',
    'gnome3.jpg',
    'gnome4.jpg',
    'gnome5.jpg',
    'gnome6.jpg',
    'gnome7.jpg',
    'gnome8.jpg',
  ];

  // Function to select a random profile picture
  String getRandomProfilePicture() {
    Random random = Random();
    int index = random.nextInt(profilePictures.length);
    return profilePictures[index];
  }

  // Function to handle user account creation
  Future<void> createUserAccount() async {
  try {
    // Get the current user
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Check if the user already has a profile picture assigned
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!snapshot.exists || snapshot.data()?['profilePictureUrl'] == null) {
        // Generate a random profile picture URL only if it's not already set
        String profilePictureUrl = getRandomProfilePicture();
        // Update the user's profile picture URL in the database
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'profilePictureUrl': profilePictureUrl,
        }, SetOptions(merge: true));
      }
    }
  } catch (e) {
    print('Error creating user account: $e');
  }
}


  Future<void> fetchUserInfo() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userData = querySnapshot.docs.first.data();
          setState(() {
            userName = userData['name'];
            userEmail = user.email!;
          });
        }
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<String> fetchUserProfilePicture() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot<Map<String, dynamic>> snapshot =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (snapshot.exists) {
          // Check if the user has a profile picture set in the database
          final String? profilePicture = snapshot.data()?['profilePicture'];
          if (profilePicture != null && profilePicture.isNotEmpty) {
            return profilePicture; // Return user profile picture URL
          }
        }
      }
    } catch (e) {
      print('Error fetching user profile picture: $e');
    }

    // If user profile picture is not found, return a random one from the list
    String randomPicture = getRandomProfilePicture();
    return 'assets/$randomPicture';
  }



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              userName.isNotEmpty ? userName : 'Loading...',
              style: const TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              userEmail.isNotEmpty ? userEmail : 'Loading...',
              style: const TextStyle(color: Colors.black),
            ),
            currentAccountPicture: FutureBuilder<String>(
              future: fetchUserProfilePicture(), // Fetch user profile picture
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData) {
                  return CircleAvatar(
                    backgroundImage: AssetImage(snapshot.data!), // Display user profile picture
                  );
                } else {
                  return const CircleAvatar(
                    backgroundImage: AssetImage('assets/default_profile_picture.jpg'), // Placeholder image
                  );
                }
              },
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/b1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.handshake_rounded),
            title: const Text('Welcome'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.verified_user),
            title: const Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

=======
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function() onPressed;

  const CustomButton({super.key, 
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
