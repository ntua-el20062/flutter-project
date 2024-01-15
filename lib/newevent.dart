// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'main.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'map.dart';
// import 'event.dart';
// import 'post_comments.dart';
// import 'myprofile.dart';
// import 'userpage.dart';

// class NewEventPage extends StatefulWidget {
//   @override
//   _NewEventPageState createState() => _NewEventPageState();
// }

// class _NewEventPageState extends State<NewEventPage> {
//   TextEditingController locationController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('New Event'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             TextField(
//               controller: locationController,
//               decoration: InputDecoration(labelText: 'Location'),
//             ),
//             TextField(
//               controller: descriptionController,
//               decoration: InputDecoration(labelText: 'Description'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 createEvent();
//               },
//               child: Text('Create Event'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> createEvent() async {
//     try {
//       var response = await http.post(
//         Uri.parse('http://10.0.2.2:5000/api/events'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//           'location': locationController.text,
//           'description': descriptionController.text,
//         }),
//       );

//       if (response.statusCode == 201) {
//         // Event created successfully
//         Navigator.pop(context);
//       } else {
//         print('Failed to create event. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error creating event: $e');
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class NewEventPage extends StatefulWidget {
  @override
  _NewEventPageState createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Add these controllers for new fields
  TextEditingController userIdController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  DateTime selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Row(
              children: [
                Text(
                  "${selectedDateTime.toLocal()}".split(' ')[0],
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () => _selectDateTime(context),
                  child: Text('Select Date & Time'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                createEvent();
              },
              child: Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createEvent() async {
    try {
      var response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/events'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'location': locationController.text,
          'description': descriptionController.text,
          'user_id': UserAuth.userId,
          'time': selectedDateTime.toUtc().toIso8601String(),
        }),
      );

      if (response.statusCode == 201) {
        // Event created successfully
        Navigator.pop(context);
      } else {
        print('Failed to create event. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating event: $e');
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }
}
