import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LearnAboutMeSettingsPage extends StatefulWidget {
  final int userId;

  LearnAboutMeSettingsPage({required this.userId});

  @override
  _LearnAboutMeSettingsPageState createState() => _LearnAboutMeSettingsPageState();
}

class _LearnAboutMeSettingsPageState extends State<LearnAboutMeSettingsPage> {
  TextEditingController imagePathController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch existing information when the page is initialized
    fetchLearnAboutMeInfo();
  }

  Future<Map<String, dynamic>> fetchLearnAboutMeInfo() async {
  try {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:5000/api/users/${widget.userId}/get-learn-about-me-info'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      print('Failed to fetch learn about me information. Status code: ${response.statusCode}');
      return {};
    }
  } catch (e) {
    print('Error fetching learn about me information: $e');
    return {};
  }
}

  Future<void> saveLearnAboutMeInfo() async {
    try {
      var response = await http.put(
        Uri.parse('http://10.0.2.2:5000/api/users/${widget.userId}/learn-about-me'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'image_path': imagePathController.text,
          'description': descriptionController.text,
          'links': linksController.text,
        }),
      );

      if (response.statusCode == 204) {
        // Data saved successfully
        Navigator.pop(context);
      } else {
        print('Failed to save learn about me information. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving learn about me information: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Learn About Me Settings'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<Map<String, dynamic>>(
        future: fetchLearnAboutMeInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Set initial values to TextControllers after fetching data
            imagePathController.text = snapshot.data!['image_path'] ?? '';
            descriptionController.text = snapshot.data!['description'] ?? '';
            linksController.text = snapshot.data!['links'] ?? '';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: imagePathController,
                  decoration: InputDecoration(labelText: 'Image Path'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: linksController,
                  decoration: InputDecoration(labelText: 'Links'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    saveLearnAboutMeInfo();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          }
        },
      ),
    ),
  );
}
}
