import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountEnfantPage extends StatefulWidget {
  final String uid;

  const AccountEnfantPage({super.key, required this.uid});

  @override
  _AccountEnfantPageState createState() => _AccountEnfantPageState();
}

class _AccountEnfantPageState extends State<AccountEnfantPage> {
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _anniversaireController = TextEditingController();
  final TextEditingController _classeController = TextEditingController();
  final TextEditingController _favoriteColorController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChildData();
  }

  Future<void> fetchChildData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance.collection('enfants').doc(widget.uid).get();

      if (snapshot.exists) {
        final data = snapshot.data()!;
        setState(() {
          _pseudoController.text = data['pseudo'] ?? '';
          _ageController.text = data['age'] != null ? data['age'].toString() : '';
          _anniversaireController.text = data['anniversaire'] ?? '';
          _classeController.text = data['classe'] ?? '';
          _favoriteColorController.text = data['favoriteColor'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching child data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveProfile() async {
    try {
      final updatedData = {
        'pseudo': _pseudoController.text,
        'age': int.tryParse(_ageController.text) ?? 0,
        'anniversaire': _anniversaireController.text,
        'classe': _classeController.text,
        'favoriteColor': _favoriteColorController.text,
      };

      await FirebaseFirestore.instance.collection('enfants').doc(widget.uid).update(updatedData);

      Navigator.pop(context, updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour')),
      );
    } catch (e) {
      print('Error saving profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Modifier le profil')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
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
                buildTextField('Pseudo', _pseudoController, Icons.person),
                const SizedBox(height: 10),
                buildTextField('Âge', _ageController, Icons.calendar_today),
                const SizedBox(height: 10),
                buildTextField('Anniversaire', _anniversaireController, Icons.cake),
                const SizedBox(height: 10),
                buildTextField('Classe', _classeController, Icons.school),
                const SizedBox(height: 10),
                buildTextField('Couleur préférée', _favoriteColorController, Icons.color_lens),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text(
                    'Sauvegarder',
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

  Widget buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
      style: const TextStyle(color: Colors.blueAccent),
    );
  }
}
