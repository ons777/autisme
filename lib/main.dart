import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Import your Firebase options file
import 'espace.dart';
import 'face.dart';
import 'loginenfant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => EspacePage(),
        '/loginenfant': (context) => LoginenfantPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/face') {
          // Extracting arguments passed to the FacePage
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>?;

          // Check if the arguments are not null
          if (args != null) {
            return MaterialPageRoute(
              builder: (context) => FacePage(
                useremailenfant: args['useremailenfant'],
                informations: args['informations'],
              ),
            );
          }
        }
        return null;
      },
    );
  }
}
