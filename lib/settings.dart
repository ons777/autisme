import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
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
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: notificationEnabled,
            onChanged: (bool value) {
              setState(() {
                notificationEnabled = value;
              });
            },
          ),
          ListTile(
            title: Text('Notification Frequency'),
            trailing: DropdownButton<int>(
              value: notificationFrequency,
              onChanged: (int? value) {
                if (value != null) {
                  setState(() {
                    notificationFrequency = value;
                  });
                }
              },
              items: <DropdownMenuItem<int>>[
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
