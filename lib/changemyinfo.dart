// changemyinfo.dartimport 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:convert';


class ChangeMyInfoPage extends StatefulWidget {
  @override
  _ChangeMyInfoPageState createState() => _ChangeMyInfoPageState();
}


class _ChangeMyInfoPageState extends State<ChangeMyInfoPage> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController accountTypeController = TextEditingController();
  TextEditingController businessNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

 @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }


  Future<Map<String, dynamic>> fetchUserInfo() async {
    try {
      var response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}/info'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(response.body);

        return userData;
      } else {
        print('Failed to fetch user information. Status code: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Error fetching user information: $e');
      return {};
    }
  }


  Future<void> saveChanges() async {
    try {
      var response = await http.put(
        Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}/info'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'nickname': nicknameController.text,
          'password': passwordController.text,
          'account_type': accountTypeController.text,
          'business_name': businessNameController.text,
          'address': addressController.text,
          'phone': phoneController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        print('Failed to save changes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error saving changes: $e');
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Account Settings'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Show a loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            // Set initial values to TextControllers after fetching data
            nicknameController.text = snapshot.data!['nickname'] ?? '';
            passwordController.text = snapshot.data!['password'] ?? '';
            accountTypeController.text = snapshot.data!['account_type'] ?? '';
            businessNameController.text = snapshot.data!['business_name'] ?? '';
            addressController.text = snapshot.data!['address'] ?? '';
            phoneController.text = snapshot.data!['phone'] ?? '';




            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: nicknameController,
                  decoration: InputDecoration(labelText: 'Nickname'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                TextField(
                  controller: accountTypeController,
                  decoration: InputDecoration(labelText: 'Account Type'),
                ),
                TextField(
                  controller: businessNameController,
                  decoration: InputDecoration(labelText: 'Business Name'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    saveChanges();
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

