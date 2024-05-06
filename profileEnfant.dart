import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'accountenfant.dart';

class KidProfilePage extends StatefulWidget {
  const KidProfilePage({super.key});

  @override
  _KidProfilePageState createState() => _KidProfilePageState();
}

class _KidProfilePageState extends State<KidProfilePage> {
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _anniversaireController = TextEditingController();
  final TextEditingController _classeController = TextEditingController();
  final TextEditingController _favoriteColorController = TextEditingController();
  String uid = '';
  bool isLoading = true;

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
            .collection('enfants')
            .where('emailenfant', isEqualTo: user.email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          final userData = querySnapshot.docs.first.data();
          setState(() {
            _pseudoController.text = userData['pseudo'] ?? 'Nom inconnu';
            _ageController.text = userData['age'] != null ? userData['age'].toString() : '';
            _anniversaireController.text = userData['anniversaire'] ?? 'Anniversaire inconnu';
            _classeController.text = userData['classe'] ?? 'Classe inconnue';
            _favoriteColorController.text = userData['favoriteColor'] ?? 'Couleur préférée inconnue';
            uid = querySnapshot.docs.first.id;
            isLoading = false;
          });
        } else {
          print('User document does not exist for email: ${user.email}');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Current user is null');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user info: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _navigateToAccountEnfantPage(BuildContext context) async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountEnfantPage(uid: uid),
      ),
    );

    if (updatedData != null) {
      setState(() {
        _pseudoController.text = updatedData['pseudo'] ?? 'Nom inconnu';
        _ageController.text = updatedData['age'] != null ? updatedData['age'].toString() : '';
        _anniversaireController.text = updatedData['anniversaire'] ?? 'Anniversaire inconnu';
        _classeController.text = updatedData['classe'] ?? 'Classe inconnue';
        _favoriteColorController.text = updatedData['favoriteColor'] ?? 'Couleur préférée inconnue';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/page.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.blueAccent.withOpacity(0.3),
                    ),
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/gnome7.jpg'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                buildInfoField('Pseudo', _pseudoController, Icons.person),
                const SizedBox(height: 10),
                buildInfoField('Âge', _ageController, Icons.calendar_today),
                const SizedBox(height: 10),
                buildInfoField('Anniversaire', _anniversaireController, Icons.cake),
                const SizedBox(height: 10),
                buildInfoField('Classe', _classeController, Icons.school),
                const SizedBox(height: 10),
                buildInfoField('Couleur préférée', _favoriteColorController, Icons.color_lens),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _navigateToAccountEnfantPage(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Modifier le profil',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: _getIconColor(icon)),
        labelText: label,
        labelStyle: TextStyle(color: _getIconColor(icon)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: _getIconColor(icon)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: _getIconColor(icon), width: 2),
        ),
      ),
      style: TextStyle(color: _getIconColor(icon)),
    );
  }

  Color _getIconColor(IconData icon) {
    switch (icon) {
      case Icons.person:
        return Colors.deepPurple;
      case Icons.calendar_today:
        return Colors.orangeAccent;
      case Icons.cake:
        return Colors.pinkAccent;
      case Icons.school:
        return Colors.lightBlueAccent;
      case Icons.color_lens:
        return Colors.greenAccent;
      default:
        return Colors.blueAccent;
    }
  }
}
