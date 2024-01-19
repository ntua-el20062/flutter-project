// // events.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Event {
//   final int id;
//   final int userId;
//   final String userName;
//   final String description;
//   final DateTime time;
//   final String location;

//   Event({
//     required this.id,
//     required this.userId,
//     required this.userName,
//     required this.description,
//     required this.time,
//     required this.location,
//   });

//   factory Event.fromJson(Map<String, dynamic> json) {
//     return Event(
//       id: json['id'],
//       userId: json['user_id'],
//       userName: json['user_name'],
//       description: json['description'],
//       time: DateTime.parse(json['time']),
//       location: json['location']
//     );
//   }
// }

// class EventsPage extends StatefulWidget {
//   @override
//   _EventsPageState createState() => _EventsPageState();
// }

// class _EventsPageState extends State<EventsPage> {
//   List<Event> events = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchEvents();
//   }

//   Future<void> fetchEvents() async {
//     try {
//       var response = await http.get(
//         Uri.parse('http://10.0.2.2:5000/api/events'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           events = data.map((e) => Event.fromJson(e)).toList();
//         });
//       } else {
//         print('Failed to fetch events. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching events: $e');
//     }
//   }

//     bool isChecked = false;

//   @override
//   Widget build(BuildContext context) {


//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Events'),
//       ),
//       body: ListView.builder(
//         itemCount: events.length,
//         itemBuilder: (context, index) {
//           Event event = events[index];
//           return Card(
//             elevation: 5.0,
//             margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: ListTile(
//               title: Text(event.userName),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Description: ${event.description}'),
//                   Text('Time: ${event.time.toString()}'),
//                   Text('Location: ${event.location}'),

//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'main.dart';

// class Event {
//   final int id;
//   final int userId;
//   final String userName;
//   final String description;
//   final DateTime time;
//   final String location;
//   bool isSelected;

//   Event({
//     required this.id,
//     required this.userId,
//     required this.userName,
//     required this.description,
//     required this.time,
//     required this.location,
//     this.isSelected = false,
//   });

//   factory Event.fromJson(Map<String, dynamic> json) {
//     return Event(
//       id: json['id'],
//       userId: json['user_id'],
//       userName: json['user_name'],
//       description: json['description'],
//       time: DateTime.parse(json['time']),
//       location: json['location'],
//     );
//   }
// }

// class EventsPage extends StatefulWidget {

//   EventsPage();

//   @override
//   _EventsPageState createState() => _EventsPageState();
// }

// class _EventsPageState extends State<EventsPage> {
//   List<Event> events = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchEvents();
//   }

//   Future<void> fetchEvents() async {
//     try {
//       var response = await http.get(
//         Uri.parse('http://10.0.2.2:5000/api/events'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           events = data.map((e) => Event.fromJson(e)).toList();
//         });
//       } else {
//         print('Failed to fetch events. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching events: $e');
//     }
//   }

//   Future<void> updateEventSelection(Event event, bool isSelected) async {
//     try {
//       String url = 'http://10.0.2.2:5000/api/update_user_event';
//       Map<String, dynamic> body = {
//         'user_id': UserAuth.userId,
//         'event_id': event.id,
//         'add_relation': isSelected,
//       };

//       var response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(body),
//       );

//       if (response.statusCode == 200) {
//         print('User event updated successfully');
//       } else {
//         print('Failed to update user event. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error updating user event: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Events'),
//       ),
//       body: ListView.builder(
//         itemCount: events.length,
//         itemBuilder: (context, index) {
//           Event event = events[index];
//           return Card(
//             elevation: 5.0,
//             margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: ListTile(
//               title: Text(event.userName),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Description: ${event.description}'),
//                   Text('Time: ${event.time.toString()}'),
//                   Text('Location: ${event.location}'),
//                 ],
//               ),
//               trailing: Checkbox(
//                 value: event.isSelected,
//                 onChanged: (value) {
//                   setState(() {
//                     event.isSelected = value ?? false;
//                   });
//                   updateEventSelection(event, event.isSelected);
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'main.dart';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Event {
//   final int id;
//   final int userId;
//   final String userName;
//   final String description;
//   final DateTime time;
//   final String location;
//   bool isSelected;

//   Event({
//     required this.id,
//     required this.userId,
//     required this.userName,
//     required this.description,
//     required this.time,
//     required this.location,
//     this.isSelected = false,
//   });

//   factory Event.fromJson(Map<String, dynamic> json) {
//     return Event(
//       id: json['id'],
//       userId: json['user_id'],
//       userName: json['user_name'],
//       description: json['description'],
//       time: DateTime.parse(json['time']),
//       location: json['location'],
//     );
//   }
// }

// class EventsPage extends StatefulWidget {

//   @override
//   _EventsPageState createState() => _EventsPageState();
// }

// class _EventsPageState extends State<EventsPage> {
//   List<Event> events = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchAllEvents();
//     fetchUserEvents();
//   }

//   Future<void> fetchUserEvents() async {
//     try {
//       var response = await http.get(
//         Uri.parse('http://10.0.2.2:5000/api/user_events/${UserAuth.userId}'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           events = data.map((e) {
//             Event event = Event.fromJson(e);
//             event.isSelected = true; // Mark events from user_event table as selected
//             return event;
//           }).toList();
//           fetchAllEvents(); // Fetch all events after user-specific events to handle any remaining events
//         });
//       } else {
//         print('Failed to fetch user events. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching user events: $e');
//     }
//   }

//   Future<void> fetchAllEvents() async {
//     try {
//       var response = await http.get(
//         Uri.parse('http://10.0.2.2:5000/api/events'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           events += data.map((e) {
//             Event event = Event.fromJson(e);
//             return event;
//           }).toList();
//         });
//       } else {
//         print('Failed to fetch all events. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching all events: $e');
//     }
//   }

//   Future<void> updateEventSelection(Event event, bool isSelected) async {
//     try {
//       String url = 'http://10.0.2.2:5000/api/update_user_event';
//       Map<String, dynamic> body = {
//         'user_id': UserAuth.userId,
//         'event_id': event.id,
//         'add_relation': isSelected,
//       };

//       var response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(body),
//       );

//       if (response.statusCode == 200) {
//         print('User event updated successfully');
//       } else {
//         print('Failed to update user event. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error updating user event: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Events'),
//       ),
//       body: ListView.builder(
//         itemCount: events.length,
//         itemBuilder: (context, index) {
//           Event event = events[index];
//           return Card(
//             elevation: 5.0,
//             margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: ListTile(
//               title: Text(event.userName),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Description: ${event.description}'),
//                   Text('Time: ${event.time.toString()}'),
//                   Text('Location: ${event.location}'),
//                 ],
//               ),
//               trailing: Checkbox(
//                 value: event.isSelected,
//                 onChanged: (value) {
//                   setState(() {
//                     event.isSelected = value ?? false;
//                   });
//                   updateEventSelection(event, event.isSelected);
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// import 'main.dart';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Event {
//   final int id;
//   final int userId;
//   final String userName;
//   final String description;
//   final DateTime time;
//   final String location;
//   bool isSelected;

//   Event({
//     required this.id,
//     required this.userId,
//     required this.userName,
//     required this.description,
//     required this.time,
//     required this.location,
//     this.isSelected = false,
//   });

//   factory Event.fromJson(Map<String, dynamic> json) {
//     return Event(
//       id: json['id'],
//       userId: json['user_id'],
//       userName: json['user_name'],
//       description: json['description'],
//       time: DateTime.parse(json['time']),
//       location: json['location'],
//     );
//   }
// }

// class EventsPage extends StatefulWidget {
//   @override
//   _EventsPageState createState() => _EventsPageState();
// }

// class _EventsPageState extends State<EventsPage> {
//   List<Event> events = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchUserEvents();
//     fetchAllEvents();
//   }

//   Future<void> fetchAllEvents() async {
//     try {
//       var response = await http.get(
//         Uri.parse('http://10.0.2.2:5000/api/events'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           for (var e in data) {
//             Event event = Event.fromJson(e);
//             event.isSelected = true;
//             if (!events.any((existingEvent) => existingEvent.id != event.id)) {
//               events.add(event);
//             }
//           }
//         });
//       } else {
//         print('Failed to fetch all events. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching all events: $e');
//     }
//   }

//   Future<void> fetchUserEvents() async {
//     try {
//       var response = await http.get(
//         Uri.parse('http://10.0.2.2:5000/api/user_events/${UserAuth.userId}'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           for (var e in data) {
//             Event event = Event.fromJson(e);
//             event.isSelected = true;
//             if (!events.any((existingEvent) => existingEvent.id == event.id)) {
//               events.add(event);
//             }
//             print(e);
//           }
//         });
//       } else {
//         print('Failed to fetch user events. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching user events: $e');
//     }
//   }

//   Future<void> updateEventSelection(Event event, bool isSelected) async {
//     try {
//       String url = 'http://10.0.2.2:5000/api/update_user_event';
//       Map<String, dynamic> body = {
//         'user_id': UserAuth.userId,
//         'event_id': event.id,
//         'add_relation': isSelected,
//       };

//       var response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(body),
//       );

//       if (response.statusCode == 200) {
//         print('User event updated successfully');
//       } else {
//         print('Failed to update user event. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error updating user event: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Events'),
//       ),
//       body: ListView.builder(
//         itemCount: events.length,
//         itemBuilder: (context, index) {
//           Event event = events[index];
//           return Card(
//             elevation: 5.0,
//             margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: ListTile(
//               title: Text(event.userName),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Description: ${event.description}'),
//                   Text('Time: ${event.time.toString()}'),
//                   Text('Location: ${event.location}'),
//                 ],
//               ),
//               trailing: Checkbox(
//                 value: event.isSelected,
//                 onChanged: (value) {
//                   setState(() {
//                     event.isSelected = value ?? false;
//                   });
//                   updateEventSelection(event, event.isSelected);
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class Event {
  final int id;
  final String userName;
  final String description;
  final DateTime time;
  final String location;
  bool isSelected;

  Event({
    required this.id,
    required this.userName,
    required this.description,
    required this.time,
    required this.location,
    this.isSelected = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      userName: json['user_name'],
      description: json['description'],
      time: DateTime.parse(json['time']), // Assuming 'time' is a string in ISO 8601 format
      location: json['location'],
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
    fetchAllEvents();
    fetchUserEvents();
  }

  Future<void> fetchUserEvents() async {
  try {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/user_events/${UserAuth.userId}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<int> userEventIds = data.map<int>((e) => e[0]).toList();

      setState(() {
        events.forEach((event) {
          if (userEventIds.contains(event.id)) {
            event.isSelected = true;
          }
        });
      });

    } else {
      print('Failed to fetch user events. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching user events: $e');
  }
}






  Future<void> fetchAllEvents() async {
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
        print('Failed to fetch all events. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching all events: $e');
    }
  }

  Future<void> updateEventSelection(Event event, bool isSelected) async {
    try {
      // Replace 'USER_ID' with the actual user ID or retrieve it from your authentication system
      String url = 'http://10.0.2.2:5000/api/update_user_event';
      Map<String, dynamic> body = {
        'user_id': UserAuth.userId,
        'event_id': event.id,
        'add_relation': isSelected,
      };

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print('User event updated successfully');
      } else {
        print('Failed to update user event. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user event: $e');
    }
  }

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
              trailing: Checkbox(
                value: event.isSelected,
                onChanged: (value) {
                  setState(() {
                    event.isSelected = value ?? false;
                  });
                  updateEventSelection(event, event.isSelected);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
