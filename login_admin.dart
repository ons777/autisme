import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dasbord_admin.dart';
import 'espace.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    // Appel de la fonction pour enregistrer l'administrateur par défaut lors de l'initialisation
    String defaultEmail = 'admin@gmail.com';
    String defaultPassword = 'Admin12@';
    registerAdminEmail(defaultEmail, defaultPassword);
  }

  Future<void> registerAdminEmail(String email, String password) async {
    try {
      // Enregistrement de l'email dans Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Récupération de l'ID de l'utilisateur créé
      String userId = userCredential.user!.uid;

      // Enregistrement de l'email et de l'ID dans la collection "admin" de Firestore
      await FirebaseFirestore.instance.collection('admin').doc(userId).set({
        'email': email,
        // Vous pouvez ajouter d'autres champs si nécessaire
      });

      // L'enregistrement a réussi
      print('Enregistrement de l\'administrateur réussi');
    } catch (e) {
      // Une erreur s'est produite lors de l'enregistrement
      print('Erreur lors de l\'enregistrement de l\'administrateur: $e');
      throw e; // Re-lancer l'erreur pour une gestion ultérieure si nécessaire
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion administrateur'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.7),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EspacePage(),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: Colors.black,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Image.asset(
                            'assets/logo.jpg',
                            width: 150,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Veuillez entrer votre email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Entrez votre email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 7, 155, 205)),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                        obscureText: _isObscure,
                        decoration: const InputDecoration(
                          hintText: 'Entrez votre mot de passe',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 7, 155, 205)),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminDashboardPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 7, 155, 205),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            elevation: 5,
                            shadowColor: Colors.black,
                          ),
                          child: Text(
                            'Se connecter en tant qu\'administrateur',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginAdmin() async {
    try {
      String email = 'admin@gmail.com';
      String password = 'Admin12@';

      if (_formKey.currentState!.validate()) {
        final inputEmail = _emailController.text.trim();
        final inputPassword = _passwordController.text.trim();

        if (inputEmail == email && inputPassword == password) {
          // Connexion avec Firebase Auth
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Rediriger vers le tableau de bord administrateur ou une autre page
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          // Afficher un message d'erreur
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Erreur'),
              content: Text('Identifiants incorrects'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      // Afficher un message d'erreur en cas d'erreur lors de l'authentification
      print('Erreur de connexion: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Erreur de connexion'),
          content: Text('Une erreur s\'est produite. Veuillez réessayer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
