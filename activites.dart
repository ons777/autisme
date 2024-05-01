// ignore_for_file: library_private_types_in_public_api, duplicate_ignore

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
      ),
      home: const ActivityPage(),
    );
  }
}

// Data model for an activity
class Activity {
  final String name;
  final String image;
  final String time;
  bool isDone;
  bool? isMarked;

  Activity({required this.name, required this.image, required this.time, this.isDone = false, this.isMarked});

  // Method to get sample activities
  static List<Activity> getSampleActivities() {
    return [
      Activity(name: "Wake Up", image: "assets/gnome6.jpg", time: "7:00 AM"),
      Activity(name: "Breakfast", image: "assets/gnome7.jpg", time: "7:15 AM"),
      Activity(name: "Brush Teeth", image: "assets/gnome8.jpg", time: "8:30 AM"),
      Activity(name: "Go to School", image: "assets/gnome5.jpg", time: "8:00 AM"),
      Activity(name: "Snack Time", image: "assets/gnome4.jpg", time: "10:00 AM"),
    ];
  }
}

// Data model for a category
class Category {
  final String name;
  final List<Activity> activities;

  Category({required this.name, required this.activities});

  void openCategoryPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryPage(category: this)));
  }

  // Method to get sample categories
  static List<Category> getSampleCategories() {
    return [
      Category(name: "Morning", activities: [
        Activity(name: "Wake Up", image: "assets/gnome6.jpg", time: "7:00 AM"),
        Activity(name: "Breakfast", image: "assets/gnome7.jpg", time: "7:15 AM"),
        Activity(name: "Brush Teeth", image: "assets/gnome8.jpg", time: "8:30 AM"),
      ]),
      Category(name: "School", activities: [
        Activity(name: "Go to School", image: "assets/gnome5.jpg", time: "8:00 AM"),
        Activity(name: "Snack Time", image: "assets/gnome4.jpg", time: "10:00 AM"),
      ]),
      // Add more categories as needed
    ];
  }
}



class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  late List<Category> categories;
  int selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    categories = Category.getSampleCategories();
  }

  void resetActivities() {
  setState(() {
    for (var category in categories) {
      for (var activity in category.activities) {
        activity.isDone = false;  // Reset to false
        activity.isMarked = null;
      }
    }
  });
}




@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activities'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetActivities,
          ),
          ],
      ),

      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Chip(
                      label: Text(categories[index].name),
                      backgroundColor: selectedCategoryIndex == index ? Colors.blue : Colors.grey,
                      labelStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: categories[selectedCategoryIndex].activities.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1 / 1.2,
              ),
              itemBuilder: (context, index) {
                return ActivityTile(activity: categories[selectedCategoryIndex].activities[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}


class CategoryPage extends StatelessWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: category.activities.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1 / 1.2,
        ),
        itemBuilder: (context, index) {
          return ActivityTile(activity: category.activities[index]);
        },
      ),
    );
  }
}

class ActivityTile extends StatefulWidget {
  final Activity activity;

  const ActivityTile({super.key, required this.activity});

  @override
  _ActivityTileState createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {
  bool _showIcons = false;  // Add this line

  @override
  Widget build(BuildContext context) {
    return InkWell(  // Replace GestureDetector with InkWell
      onTap: () {
        setState(() {
          _showIcons = !_showIcons;  // Toggle the visibility of the icons
        });
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    widget.activity.image,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                  ),
                ),
                Text(
                  widget.activity.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.activity.time,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            // Show a white overlay and the icons if _showIcons is true
            if (_showIcons)
              Container(
                color: Colors.white.withOpacity(0.7),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green, size: 40),
                      onPressed: () {
                        setState(() {
                          widget.activity.isDone = true;
                          widget.activity.isMarked = true;  // Mark as done
                          _showIcons = false;  // Hide the icons
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red, size: 40),
                      onPressed: () {
                        setState(() {
                          widget.activity.isDone = false;
                          widget.activity.isMarked = false;  // Mark as not done
                          _showIcons = false;  // Hide the icons
                        });
                      },
                    ),
                  ],
                ),
              ),
            // Show a green or red overlay depending on the value of isMarked
            if (widget.activity.isMarked == true)  // Check if isMarked is not null and true
              Container(
                color: Colors.green.withOpacity(0.7),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            if (widget.activity.isMarked == false)  // Check if isMarked is not null and false
              Container(
                color: Colors.red.withOpacity(0.7),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.cancel,
                  color: Colors.white,
                  size: 60,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
