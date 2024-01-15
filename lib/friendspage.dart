import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class FriendsPage extends StatefulWidget {
  final int userId;

  FriendsPage({required this.userId});

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late List<int> friendIds;
  List<Map<String, dynamic>> friends = [];
  late Map<String, dynamic> userInfo;


  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  Future<void> fetchUserData() async {
    try {
      final userResponse = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}'),
      );


      if (userResponse.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(userResponse.body);
        setState(() {
          userInfo = userData['user'];
        });
      } else {
        print('Failed to load user information. Status codes: ${userResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchFriends() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}/friends'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          friendIds = List<int>.from(data['friend_ids']);
        });

        // Now, fetch friend details based on friendIds
        await fetchFriendDetails();
      } else {
        print('Failed to load user friends. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user friends: $e');
    }
  }

  Future<void> fetchFriendDetails() async {
    for (int friendId in friendIds) {
      try {
        final response = await http.get(
          Uri.parse('http://10.0.2.2:5000/api/users/$friendId'),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> friendData = json.decode(response.body);
          setState(() {
            friends.add(friendData['user']);
          });
        } else {
          print('Failed to load friend details. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching friend details: $e');
      }
    }
  }

  Future<void> deleteFriendship(int friendId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5000/api/delete_friendships/${UserAuth.userId}/$friendId'),
      );

      if (response.statusCode == 204) {
        // Friendship deleted successfully
        setState(() {
          friends.removeWhere((friend) => friend['id'] == friendId);
        });
      } else {
        print('Failed to delete friendship. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting friendship: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends'),
      ),
      body: friends.isNotEmpty
          ? ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return ListTile(
                  title: Text(friend['nickname']),
                  subtitle: Text('ID: ${friend['id']}'), // Display the friend ID for reference
                  trailing: ElevatedButton(
                  onPressed: () async {
                    bool confirmed = await showDeleteConfirmationDialog(context, friend['id']);
                    if (confirmed) {
                      await deleteFriendship(friend['id']);
                    }
                  },
                  child: Text('Delete Friendship'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
                );
              },
            )
          :Center(
            child: Text('No friends available. :('),
          ),
    );
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context, int friendId) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Friendship'),
        content: Text('Are you sure you want to delete this friend?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true for confirmed deletion
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false for cancellation
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  ) ?? false; // Default to false if showDialog returns null
}

}