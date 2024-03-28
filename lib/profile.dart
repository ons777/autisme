import 'package:flutter/material.dart';

void main() {
  runApp(const ProfilePage());
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        
        body: Stack(
          children: [
            Positioned.fill(
              bottom: null,
              child: Container(
                color: Colors.lightBlue,
                height: MediaQuery.of(context).size.height / 3, // 1/3 of the screen height
              ),
            ),
            const Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: ProfileAvatar(imagePath: 'assets/background.jpg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final String imagePath;

  const ProfileAvatar({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 80,
      backgroundImage: AssetImage(imagePath),
    );
  }
}
