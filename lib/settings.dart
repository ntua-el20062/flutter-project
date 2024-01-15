import 'package:flutter/material.dart';
import 'main.dart';
import 'learn_about_me_settings.dart';
import 'changemyinfo.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'General Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Add your settings options here
            SettingOption(
              title: 'Account',
              onTap: () {
 Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeMyInfoPage()),
                  );              },
            ),
            SettingOption(
                title: 'Modify the "Learn About Me" page',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LearnAboutMeSettingsPage(userId: UserAuth.userId)),
                  );
                },
              ),
            // Add more settings options as needed
          ],
        ),
      ),
    );
  }
}

class SettingOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  SettingOption({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
