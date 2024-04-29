<<<<<<< HEAD
// ignore_for_file: avoid_print, library_private_types_in_public_api, use_build_context_synchronously

import 'face.dart';
=======
import 'package:autisme_app/face.dart';
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD

class LoginenfantPage extends StatefulWidget {
  const LoginenfantPage({super.key});
=======
import 'face.dart';

class LoginenfantPage extends StatefulWidget {
  const LoginenfantPage({Key? key}) : super(key: key);
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginenfantPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailenfantController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  String useremailenfant = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.7),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
<<<<<<< HEAD
                        child: const Icon(
=======
                        child: Icon(
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
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
                      const Text(
                        'emailenfant',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _emailenfantController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre emailenfant';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Entrez votre emailenfant',
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
                      const SizedBox(height: 20),
                      const Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          hintText: 'Entrez votre mot de passe',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure; // Inverse l'état
                              });
                            },
                          ),
<<<<<<< HEAD
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: const OutlineInputBorder(
=======
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          focusedBorder: OutlineInputBorder(
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 7, 155, 205)),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage()),
                            );
                          },
                          child: const Text(
                            'Mot de passe oublié?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
<<<<<<< HEAD
                                print('Attempting to sign in with email: ${_emailenfantController.text.trim()}');
                                final userCredential = await FirebaseAuth.instance.signInWithCredential(
=======
                                final userCredential = await FirebaseAuth
                                    .instance
                                    .signInWithCredential(
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
                                  EmailAuthProvider.credential(
                                    email: _emailenfantController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  ),
                                );

                                // Fetch user data after successful login
                                await fetchUserData(
                                    _emailenfantController.text.trim());

                                // Navigate to  FacePage
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FacePage(
                                      useremailenfant: _useremailenfant,
<<<<<<< HEAD
                                      informations: const {},
=======
                                      informations: {},
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
                                    ),
                                  ),
                                );
                              } catch (e) {
<<<<<<< HEAD
      if (e is FirebaseAuthException) {
        print('Error code: ${e.code}');
        print('Error message: ${e.message}');
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
      print('Failed to sign in: $e');
    }

=======
                                print('Failed to sign in: $e');
                                // Handle sign-in errors (e.g., display error message)
                              }
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
                            }
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
                          child: const Text(
                            'Se connecter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
<<<<<<< HEAD
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
=======
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
    )
  }

  Future<void> fetchUserData(String emailenfant) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          FirebaseFirestore.instance
<<<<<<< HEAD
              .collection('enfants')
=======
              .collection('enfant')
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
              .where('emailenfant', isEqualTo: emailenfant)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final userData = snapshot.docs.first.data();
        setState(() {
<<<<<<< HEAD
          _useremailenfant = userData['emailenfant'] ?? '';
=======
          _useremailenfant = userData['emailenfant'] ?? '';
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
        });
        // Autres opérations après la connexion réussie, par exemple, navigation vers une autre page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FacePage(
              useremailenfant: _useremailenfant,
<<<<<<< HEAD
              informations: const {}, // Les informations supplémentaires peuvent être transmises ici
=======
              informations: {}, // Les informations supplémentaires peuvent être transmises ici
>>>>>>> 1fcbd148686285e2211357bb9421a7396bedeb18
            ),
          ),
        );
      } else {
        // Aucun utilisateur trouvé avec les identifiants fournis
        print('Utilisateur non trouvé');
        // Afficher un message d'erreur ou une boîte de dialogue pour informer l'utilisateur
      }
    } catch (e) {
      // Gérer les erreurs lors de la récupération des données utilisateur
      print('Erreur lors de la récupération des données utilisateur: $e');
    }
  }
}
