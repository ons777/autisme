// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discussion Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const DiscussionPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await FirebaseAuth.instance.signInAnonymously();
            } on FirebaseAuthException catch (e) {
              String errorMessage = 'An error occurred';
              if (e.code == 'user-not-found') {
                errorMessage = 'No user found for that email.';
              } else if (e.code == 'wrong-password') {
                errorMessage = 'Wrong password provided for that user.';
              }
              print('FirebaseAuthException: ${e.message ?? errorMessage}');
            } on FirebaseException catch (e) {
              print('FirebaseException: ${e.message ?? 'Unknown error'}');
            } catch (e) {
              // Handle other exceptions
              print('Error: $e');
            }
          },
          child: const Text('Sign in Anonymously'),
        ),
      ),
    );
  }
}

class DiscussionPage extends StatelessWidget {
  const DiscussionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion Page'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
              } on FirebaseAuthException catch (e) {
                print('FirebaseAuthException: ${e.message ?? 'Unknown error'}');
              } on FirebaseException catch (e) {
                print('FirebaseException: ${e.message ?? 'Unknown error'}');
              } catch (e) {
                print('Error: $e');
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: MessagesList(),
          ),
          SendMessageField(),
        ],
      ),
    );
  }
}

class MessagesList extends StatelessWidget {
  const MessagesList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final messages = snapshot.data!.docs;
        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
            return ListTile(
              title: Text(message['text']),
              subtitle: Text(message['userId']),
            );
          },
        );
      },
    );
  }
}

class SendMessageField extends StatefulWidget {
  const SendMessageField({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SendMessageFieldState createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  final _messageController = TextEditingController();

  void _sendMessage(String messageText) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        await FirebaseFirestore.instance.collection('messages').add({
          'text': messageText,
          'userId': currentUser.uid,
          'timestamp': DateTime.now(),
        });
        _messageController.clear();
      } on FirebaseException catch (e) {
        print('FirebaseException: ${e.message ?? 'Unknown error'}');
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(hintText: 'Enter message'),
            ),
          ),
          IconButton(
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                _sendMessage(_messageController.text);
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
