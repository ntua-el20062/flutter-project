// friend_requests_page.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class FriendRequestsPage extends StatefulWidget {
  final int userId;

  FriendRequestsPage({required this.userId});

  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  List<int> friendRequests = [];

  @override
  void initState() {
    super.initState();
    fetchFriendRequests();
  }

  Future<void> fetchFriendRequests() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}/friend-requests'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          friendRequests = List<int>.from(data['users_ids']);
        });
      } else {
        print('Failed to load friend requests. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching friend requests: $e');
    }
  }

  Future<void> acceptFriendRequest(int friendId) async {
    try {
      var response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/create_friendships/${UserAuth.userId}/$friendId'),
      );

      if (response.statusCode == 204) {
        // Friendship created successfully, you may want to refresh the friend requests list
        await fetchFriendRequests();
      } else {
        // Handle the case where the request was not successful
        print('Failed to accept friend request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error accepting friend request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend Requests'),
      ),
      body: friendRequests.isNotEmpty
          ? ListView.builder(
              itemCount: friendRequests.length,
              itemBuilder: (context, index) {
                final friendId = friendRequests[index];
                return ListTile(
                  title: Text('User ID: $friendId'),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await acceptFriendRequest(friendId);
                    },
                    child: Text('Accept Friend'),
                  ),
                );
              },
            )
          : Center(
              child: Text('No friend requests available. :('),
            ),
    );
  }
}

