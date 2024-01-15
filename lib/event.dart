// events.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Event {
  final int id;
  final int userId;
  final String userName;
  final String description;
  final DateTime time;
  final String location;

  Event({
    required this.id,
    required this.userId,
    required this.userName,
    required this.description,
    required this.time,
    required this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      userId: json['user_id'],
      userName: json['user_name'],
      description: json['description'],
      time: DateTime.parse(json['time']),
      location: json['location']
    );
  }
}

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      var response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/events'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          events = data.map((e) => Event.fromJson(e)).toList();
        });
      } else {
        print('Failed to fetch events. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching events: $e');
    }
  }

    bool isChecked = false;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          Event event = events[index];
          return Card(
            elevation: 5.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(event.userName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description: ${event.description}'),
                  Text('Time: ${event.time.toString()}'),
                  Text('Location: ${event.location}'),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
