import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserProfile(),
    );
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cute Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
