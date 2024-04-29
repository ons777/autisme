import 'package:flutter/material.dart';

// Modèle de données pour une activité
class Activity {
  final String name;
  final String image;
  final String time;

  Activity({required this.name, required this.image, required this.time});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  ActivityPage(),
    );
  }
}

class ActivityPage extends StatelessWidget {
  final List<Activity> activities = [
    Activity(name: "Se lever", image: "assets/wakeup.png", time: "7:00"),
    Activity(name: "Prendre le petit-déjeuner", image: "assets/breakfast.png", time: "7:15"),
    Activity(name: "Se brosser les dents", image: "assets/brush_teeth.png", time: "8:30"),
    Activity(name: "Aller à l'école", image: "assets/school.png", time: "8:00"),
    Activity(name: "Manger des collations", image: "assets/snack.png", time: "10:00"),
  ];

  ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
      ),
      body: GridView.builder(
        itemCount: activities.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return ActivityTile(activity: activities[index]);
        },
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final Activity activity;

  const ActivityTile({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            activity.image,
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 10),
          Text(
            activity.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            activity.time,
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
