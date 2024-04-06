import 'package:autisme/activites.dart';
import 'package:autisme/forum.dart';
import 'package:autisme/profile.dart';
import 'package:autisme/settings.dart';
import 'package:autisme/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:autisme/calender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      home: const FacePage(),
    );
  }
}

class FacePage extends StatelessWidget {
  const FacePage({super.key});

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
        child: SideMenuContent(),
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
                      MaterialPageRoute(builder: (context) => const CalendarPage()),
                    );
                  },
                ),
                CustomButton(
                  icon: Icons.local_activity,
                  label: 'Activités',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ActivityPage()),
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
      ),
    );
  }
}

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
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/background.jpg'),
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
                MaterialPageRoute(builder: (context) => const UserProfile()),
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

class CustomButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
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
            Text(label, style: const TextStyle(fontSize: 20.0, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
