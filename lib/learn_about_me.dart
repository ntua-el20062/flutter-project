import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/link.dart';

import 'package:url_launcher/url_launcher.dart';

class LearnAboutMePage extends StatefulWidget {
  final int userId;

  LearnAboutMePage({required this.userId});

  @override
  _LearnAboutMePageState createState() => _LearnAboutMePageState();
}

class _LearnAboutMePageState extends State<LearnAboutMePage> {
  late Map<String, dynamic> learnAboutMeInfo;

  @override
  void initState() {
    super.initState();
    fetchLearnAboutMeInfo();
  }

  Future<void> fetchLearnAboutMeInfo() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${widget.userId}/get-learn-about-me-info'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          learnAboutMeInfo = data;
        });
      } else {
        print('Failed to load learn about me information. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching learn about me information: $e');
    }
  }

  void openLink() async {
  String link = learnAboutMeInfo['links'];

  // Ensure the link starts with a valid scheme
  if (!link.startsWith('http://') && !link.startsWith('https://')) {
    link = 'http://' + link;
  }

  launchUrl(Uri.parse(link), mode:LaunchMode.inAppWebView);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learn About Me'),
      ),
      body: learnAboutMeInfo != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Display other information about the user from learn_about_me table
                Image.asset(learnAboutMeInfo['image_path']),
                Text(learnAboutMeInfo['description']),
                ElevatedButton(
                  onPressed: openLink,
                  child: Text('Open Link'),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
