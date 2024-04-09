// ignore_for_file: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<types.Message> _messages = [];
  late final types.User _user; // Replace with the authenticated user's ID

 @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;

    _user = types.User(id: currentUser?.uid ?? ''); 

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();

    _loadMessages();
  }


  void _loadMessages() {
    FirebaseFirestore.instance
        .collection('public_messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) async {
      List<types.Message> fetchedMessages = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final timestamp = data['createdAt'] as Timestamp?;
        final createdAt = timestamp?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;

        // Fetch user data for each message author
        DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(data['uid']).get();
        Map<String, dynamic> userInfo = userData.data() as Map<String, dynamic>;

        // Construct the message with user information
        final message = types.TextMessage(
          author: types.User(
            id: data['uid'],
            firstName: userInfo['name'], // Assuming 'name' field for user's name
            imageUrl: userInfo['avatarUrl'], // Assuming 'avatarUrl' field for user's avatar URL
          ),
          createdAt: createdAt,
          id: doc.id,
          text: data['text'],
        );

        fetchedMessages.add(message);
      }

      setState(() {
        _messages = fetchedMessages;
      });
    });
  }



  void _handleSendPressed(types.PartialText message) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) { // Ensures there is a logged-in user
        FirebaseFirestore.instance.collection('public_messages').add({
            'text': message.text,
            'createdAt': FieldValue.serverTimestamp(),
            'uid': currentUser.uid, // Use the actual UID from FirebaseAuth
        });
    } else {
        // ignore: avoid_print
        print("No authenticated user found.");
    }
}


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Public Chat"),
        backgroundColor: const Color.fromARGB(255, 163, 162, 164), // AppBar color
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Chat(
          messages: _messages,
          onSendPressed: _handleSendPressed,
          user: _user,
          theme: DefaultChatTheme(
            backgroundColor: Colors.white,
            primaryColor: const Color.fromARGB(255, 20, 88, 233), // Influences the send button and more
            inputBackgroundColor: Colors.white,
            inputTextColor: Colors.black87,
            inputBorderRadius: BorderRadius.circular(30.0),
            dateDividerTextStyle: const TextStyle(color: Colors.black54),
            emptyChatPlaceholderTextStyle: const TextStyle(color: Colors.black38),
            inputTextStyle: const TextStyle(color: Colors.black87),
            inputTextDecoration: InputDecoration(
              hintText: "Type a message",
              hintStyle: const TextStyle(color: Colors.black54),
              border: InputBorder.none,
              filled: true,
              fillColor: const Color.fromARGB(255, 233, 233, 233),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 233, 233, 233)),
                borderRadius: BorderRadius.circular(30.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color.fromARGB(255, 233, 233, 233)),
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
