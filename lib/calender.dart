import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application de Calendrier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const CalendarPage(),
    );
  }
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _eventNameController;
  late TextEditingController _eventLocationController;
  late DateTime _fromDateTime;
  late DateTime _toDateTime;
  bool _isAllDay = false;
  String _repetition = 'Aucune';
  String _reminder = 'Aucun';

  String? eventNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the event name';
    }
    return null;
  }

  String? eventLocationValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the event location';
    }
    return null;
  }

  String? _eventNameError;
  String? _eventLocationError;


  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _eventNameController = TextEditingController();
    _eventLocationController = TextEditingController();
    _fromDateTime = DateTime.now();
    _toDateTime = DateTime.now().add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventLocationController.dispose();
    super.dispose();
  }

  void addEvent(String eventName, String eventLocation, String repetition, String reminder) async {
    var url = Uri.parse('http://127.0.0.1:5001/pfeprojet-ac067/us-central1/addEvent'); // Replace with your Cloud Function URL
    var body = jsonEncode({
      'event_name': eventName,
      'event_location': eventLocation,
      'start_datetime': _fromDateTime.toIso8601String(), // Assuming _fromDateTime and _toDateTime are DateTime objects
      'end_datetime': _toDateTime.toIso8601String(),
      'repetition': repetition,
      'reminder': reminder,
      'is_all_day': _isAllDay.toString(), // Assuming isAllDay is a boolean
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
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Image.asset(
                            'assets/logo.jpg',
                            width: 150,
                          ),
                        ),
                      ),
                      TableCalendar(
                        calendarFormat: _calendarFormat,
                        focusedDay: _focusedDay,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          if (!isSameDay(_selectedDay, selectedDay)) {
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay = focusedDay;
                            });
                          }
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                        onPageChanged: (focusedDay) {
                          setState(() {
                            _focusedDay = focusedDay;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: MediaQuery.of(context).size.height * 0.7,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          controller: _eventNameController,
                                          decoration: const InputDecoration(
                                            labelText: 'Nom de l\'événement',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.event),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextField(
                                          controller: _eventLocationController,
                                          decoration: const InputDecoration(
                                            labelText: 'Lieu',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.location_pin),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time),
                                            const SizedBox(width: 
32),
                                            const Text('De :'),
                                            const SizedBox(width: 8),
                                            TextButton(
                                              onPressed: () => _selectFromDate(context),
                                              child: Text(_fromDateTime.toLocal().toString().split(' ')[0]),
                                            ),
                                            TextButton(
                                              onPressed: () => _selectFromTime(context),
                                              child: Text(_fromDateTime.toLocal().toString().split(' ')[1].substring(0, 5)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(width: 32),
                                            const Icon(Icons.access_time),
                                            const SizedBox(width: 8),
                                            const Text('À :'),
                                            const SizedBox(width: 8),
                                            TextButton(
                                              onPressed: () => _selectToDate(context),
                                                child: Text(_toDateTime.toLocal().toString().split(' ')[0]),
                                            ),
                                            TextButton(
                                              onPressed: () => _selectToTime(context),
                                              child: Text(_toDateTime.toLocal().toString().split(' ')[1].substring(0, 5)),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            const Icon(Icons.today),
                                            const SizedBox(width: 8),
                                            const Text('Toute la journée :'),
                                            const SizedBox(width: 8),
                                            Checkbox(
                                              value: _isAllDay,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isAllDay = value ?? false;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        DropdownButtonFormField<String>(
                                          value: _repetition,
                                          onChanged: (value) {
                                            setState(() {
                                              _repetition = value!;
                                            });
                                          },
                                          items: ['Aucune', 'Quotidienne', 'Hebdomadaire', 'Mensuelle', 'Annuelle']
                                              .map((repetition) => DropdownMenuItem(
                                                    value: repetition,
                                                    child: Text(repetition),
                                                  ))
                                              .toList(),
                                          decoration: const InputDecoration(
                                            labelText: 'Répétition',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.repeat),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        DropdownButtonFormField<String>(
                                          value: _reminder,
                                          onChanged: (value) {
                                            setState(() {
                                              _reminder = value!;
                                            });
                                          },
                                          items: ['Aucun', '5 minutes avant', '15 minutes avant', '30 minutes avant', '1 heure avant']
                                              .map((reminder) => DropdownMenuItem(
                                                    value: reminder,
                                                    child: Text(reminder),
                                                  ))
                                              .toList(),
                                          decoration: const InputDecoration(
                                            labelText: 'Rappel',
                                            border: OutlineInputBorder(),
                                            prefixIcon: Icon(Icons.alarm),
                                          ),
                                        ),
                                        
                                        const SizedBox(height: 16),
                                        Center(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              String eventName = _eventNameController.text;
                                              String eventLocation = _eventLocationController.text;
                                              addEvent(eventName, eventLocation, _repetition, _reminder);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Ajouter un événement'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              barrierColor: Colors.transparent,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 7, 155, 205),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            elevation: 0, // Set elevation to 0
                            shadowColor: Colors.transparent, // Set shadow color to transparent
                          ),
                          child: const Text(
                            'Ajouter',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fromDateTime) {
      setState(() {
        _fromDateTime = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _toDateTime) {
      setState(() {
        _toDateTime = picked;
      });
    }
  }

  Future<void> _selectFromTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_fromDateTime),
    );
    if (picked != null) {
      setState(() {
        _fromDateTime = DateTime(
          _fromDateTime.year,
          _fromDateTime.month,
          _fromDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _selectToTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_toDateTime),
    );
    if (picked != null) {
      setState(() {
        _toDateTime = DateTime(
          _toDateTime.year,
          _toDateTime.month,
          _toDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }
}
