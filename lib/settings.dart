import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationEnabled = true;
  int notificationFrequency = 1; // Example: 1 for every hour

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: notificationEnabled,
            onChanged: (bool value) {
              setState(() {
                notificationEnabled = value;
              });
            },
          ),
          ListTile(
            title: const Text('Notification Frequency'),
            trailing: DropdownButton<int>(
              value: notificationFrequency,
              onChanged: (int? value) {
                if (value != null) {
                  setState(() {
                    notificationFrequency = value;
                  });
                }
              },
              items: const <DropdownMenuItem<int>>[
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text('Every hour'),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text('Every 2 hours'),
                ),
                DropdownMenuItem<int>(
                  value: 3,
                  child: Text('Every 3 hours'),
                ),
                // Add more frequency options as needed
              ],
            ),
          ),
          // Add more settings UI elements here as needed
        ],
      ),
    );
  }
}
