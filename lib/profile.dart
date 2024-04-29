import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return MaterialApp(
      title: 'User Profile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProfilePage(),
=======
    return const MaterialApp(
      home: UserProfile(),
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
    );
  }
}

<<<<<<< HEAD
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
=======
class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String firstName = '';
  String lastName = '';
  int age = 0;
  String email = '';
  String sexe = '';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    getUserData('9Ksk5CiL3veqw1KHWiWh');
  }

  Future<void> getUserData(String userId) async {
    final docRef = firestore.collection('users').doc(userId);
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        firstName = data?['firstName'] ?? '';
        lastName = data?['lastName'] ?? '';
        age = data?['age']?.toInt() ?? 0;
        email = data?['email'] ?? '';
        sexe = data?['sexe'] ?? '';
        profileImageUrl = data?['profileImageUrl'] ?? '';
      });
      print('User data retrieved: $data');
    } else {
      print('No user data found!');
    }
  }

  Future<void> updateUserField(String fieldName, String newValue) async {
    final docRef = firestore.collection('users').doc('9Ksk5CiL3veqw1KHWiWh');
    await docRef.update({fieldName: newValue});
    setState(() {
      if (fieldName == 'age') {
        age = int.parse(newValue);
      } else if (fieldName == 'sexe') {
        sexe = newValue;
      } else if (fieldName == 'email') {
        email = newValue;
      }
    });
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
            Row(
              children: [
                Text(
                  content,
                  style: const TextStyle(fontSize: 16.0),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Modifier la valeur'),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            String newValue =
                                ''; // Nouvelle valeur saisie par l'utilisateur

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Nouvelle valeur',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      newValue = value;
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (newValue.isNotEmpty) {
                                      await updateUserField(
                                          title.toLowerCase(), newValue);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Enregistrer'),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18

  @override
  Widget build(BuildContext context) {
    final userUID = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
<<<<<<< HEAD
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the edit profile page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
=======
      appBar: AppBar(
        title: const Text('My Cute Profile'),
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userUID).get(),
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
              if (enfantSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (enfantSnapshot.hasError) {
                return Center(child: Text("Error: ${enfantSnapshot.error}"));
              }
              final QuerySnapshot<Map<String, dynamic>> querySnapshot = enfantSnapshot.data! as QuerySnapshot<Map<String, dynamic>>;
              if (querySnapshot.docs.isEmpty) {
                return const Center(child: Text("Child does not exist"));
              }
              return ListView(
                children: [
                  _buildHeader(context, userData),
                  for (var doc in querySnapshot.docs) _buildUserInfo(doc.data()),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget buildHeader(BuildContext context, Map<String, dynamic> userData) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 40),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColorDark,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(userData['profilePictureUrl']),
          backgroundColor: Colors.white,
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
<<<<<<< HEAD
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
=======
            const SizedBox(height: 20.0),
            CircleAvatar(
              radius: 70.0,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Modifier la photo de profil'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Galerie'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final XFile? image = await ImagePicker()
                                .pickImage(source: ImageSource.camera);
                            if (image != null) {
                              // Implement logic to handle captured image
                            }
                          },
                          child: const Text('Caméra'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
            const SizedBox(height: 10.0),
            Text(
              '$firstName $lastName',
              style:
                  const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
              indent: 50.0,
              endIndent: 50.0,
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  buildInfoCard('Age', age.toString()),
                  const SizedBox(height: 8.0),
                  buildInfoCard('Email', email),
                  const SizedBox(height: 8.0),
                  buildInfoCard('Sexe', sexe),
                ],
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  Widget buildUserInfo(Map<String, dynamic> enfantData) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Child Information',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Email: ${enfantData['emailenfant'] ?? 'No email available'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Password: ${enfantData['motDePasse'] ?? 'No password available'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Pseudo: ${enfantData['pseudo'] ?? 'No pseudo available'}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
