import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> addEvent(String eventName, String eventLocation, String repetition, String reminder) async {
  var url = Uri.parse('http://localhost:8080/addEvent'); // Replace with your server URL
  var body = jsonEncode({
    'eventName': eventName,
    'eventLocation': eventLocation,
    'repetition': repetition,
    'reminder': reminder,
  });

  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: body,
  );

  if (response.statusCode == 200) {
    print('Event added successfully');
  } else {
    print('Failed to add event. Status code: ${response.statusCode}');
  }
}
