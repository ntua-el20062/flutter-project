import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'homepage.dart';

class PostCommentsPage extends StatefulWidget {
  final int postId;

  PostCommentsPage({required this.postId});

  @override
  _PostCommentsPageState createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage> {
  late List<Map<String, dynamic>> comments;
  final TextEditingController commentController = TextEditingController();
    late Map<String, dynamic> userInfo;
  late List<Map<String, dynamic>> userPosts;

  @override
  void initState() {
    super.initState();
    fetchComments();
    fetchUserData();

  }

  Future<void> fetchUserData() async {
    try {
      final userResponse = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}'),
      );

      final postsResponse = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}/posts'),
      );

      if (userResponse.statusCode == 200 && postsResponse.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(userResponse.body);
        final List<Map<String, dynamic>> postsData =
            List.from(json.decode(postsResponse.body)['posts']);

        setState(() {
          userInfo = userData['user'];
          userPosts = postsData;
        });
      } else {
        print('Failed to load user information or posts. Status codes: ${userResponse.statusCode}, ${postsResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/comments/${widget.postId}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<Map<String, dynamic>> fetchedComments = List.from(data['comments']);
        setState(() {
          comments = fetchedComments;
        });
      } else {
        print('Failed to load comments. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }
  
  Future<void> addComment() async {
    String commentText = commentController.text;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/comments/${widget.postId}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': userInfo['nickname'], 'comment': commentText}),
      );

      if (response.statusCode == 201) {
        await fetchComments();
        commentController.clear();
      } else {
        print('Failed to create comment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          // Display image and user icon/name here
          // ...

          // Display comments using ListView
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return ListTile(
                  title: Text(comment['username']),
                  subtitle: Text(comment['comment']),
                );
              },
            ),
          ),

          // Add a text field and button for adding new comments
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: addComment,
                  child: Text('Add Comment'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
