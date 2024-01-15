// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'homepage.dart';
// import 'main.dart';
// import 'post_comments.dart';
// import 'map.dart';
// import 'settings.dart';
// import 'newpost.dart';
// import 'friendspage.dart';
// import 'friend_request.dart';
// import 'learn_about_me_settings.dart';
// import 'event.dart';

// class MyProfilePage extends StatefulWidget {
//   @override
//   _MyProfilePageState createState() => _MyProfilePageState();
// }

// class _MyProfilePageState extends State<MyProfilePage> {
//   late Map<String, dynamic> userInfo;
//   late List<Map<String, dynamic>> userPosts;

//   @override
//   void initState() {
//     super.initState();
//     fetchUserData();
//   }

//   Future<void> fetchUserData() async {
//     try {
//       final userResponse = await http.get(
//         Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}'),
//       );

//       final postsResponse = await http.get(
//         Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}/posts'),
//       );

//       if (userResponse.statusCode == 200 && postsResponse.statusCode == 200) {
//         final Map<String, dynamic> userData = json.decode(userResponse.body);
//         final List<Map<String, dynamic>> postsData =
//             List.from(json.decode(postsResponse.body)['posts']);

//         setState(() {
//           userInfo = userData['user'];
//           userPosts = postsData;
//         });
//       } else {
//         print('Failed to load user information or posts. Status codes: ${userResponse.statusCode}, ${postsResponse.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome to my Profile! 🐾'),
        
//         actions: [
//           IconButton(
//             icon: Icon(Icons.settings),
//             onPressed: () {
//               Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SettingsPage(),
//                             ),
//                           );
//             },
//           ),
//         ],

        
        
//       ),
//       body: userInfo != null
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FriendsPage(userId: UserAuth.userId),
//       ),
//     );
//   },
//   child: Text('View Friends'),
// ),

// ElevatedButton(
//   onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => FriendRequestsPage(userId: UserAuth.userId)),
//     );
//   },
//   child: Text('Friend Requests'),
// ),

//                 ListTile(
//                   title: Text(userInfo['nickname']),
//                 ),
//                 ListTile(
//                   title: Text('Email: ${userInfo['email']}'),
//                 ),
//                 // Add more user information fields as needed
//                 Divider(),
//                 ListTile(
//                   title: Text('User Posts'),
//                 ),
//                 Expanded(
//   child: ListView.builder(
//     itemCount: userPosts.length,
//     itemBuilder: (context, index) {
//       final post = userPosts[index];
//       return Card(
//         margin: EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             ListTile(
//               title: Text(post['username']),
//               subtitle: Text('Location: ${post['location']}'),
//               leading: CircleAvatar(
//   child: Text(
//     post['username'] != null ? post['username'][0].toUpperCase() : '',
//     style: TextStyle(
//       fontWeight: FontWeight.bold,
//       color: Colors.white,
//     ),
//   ),
// ),
//             ),
//             // Add more post information fields as needed

//             // Display the post image
//             Image.asset(
//               post['image_path'],
//               height: 200,
//               fit: BoxFit.cover,
//             ),

//             // Add a comment button
//             IconButton(
//                         icon: Icon(Icons.comment),
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => PostCommentsPage(postId: post['id']),
//                             ),
//                           );
//                         },
//                       ),
//           ],
//         ),
//       );
//     },
//   ),
// ),
//               ],
//             )
//           : Center(
//               child: CircularProgressIndicator(),
//             ),
//             floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => NewPostPage(), //NEW POST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//             ),
//           );
//         },
//         child: Icon(Icons.add),
//         backgroundColor: Colors.green,
//       ),
//             bottomNavigationBar: CustomBottomNavigationBar(
//         onHomePressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => HomePage()),
//           );
//         },
//         onMapPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => MapPage()),
//           );
//         },
//         onNotificationsPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => EventsPage()),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'main.dart';
import 'post_comments.dart';
import 'map.dart';
import 'settings.dart';
import 'newpost.dart';
import 'newevent.dart'; // Import the NewEventPage
import 'friendspage.dart';
import 'friend_request.dart';
import 'event.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late Map<String, dynamic> userInfo;
  late List<Map<String, dynamic>> userPosts;

  @override
  void initState() {
    super.initState();
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

  Future<void> showPostTypeSelectionDialog() async {
    String? result = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Select Post Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'post'); // 'post' indicates a new post
              },
              child: Text('New Post'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'event'); // 'event' indicates a new event
              },
              child: Text('New Event'),
            ),
          ],
        ),
      ),
    );

    if (result == 'post') {
      // Navigate to new post page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPostPage(),
        ),
      );
    } else if (result == 'event') {
      // Navigate to new event page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewEventPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to my Profile! 🐾'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: userInfo != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendsPage(userId: UserAuth.userId),
                      ),
                    );
                  },
                  child: Text('View Friends'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FriendRequestsPage(userId: UserAuth.userId)),
                    );
                  },
                  child: Text('Friend Requests'),
                ),
                ListTile(
                  title: Text(userInfo['nickname']),
                ),
                ListTile(
                  title: Text('Email: ${userInfo['email']}'),
                ),
                // Add more user information fields as needed
                Divider(),
                ListTile(
                  title: Text('User Posts'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: userPosts.length,
                    itemBuilder: (context, index) {
                      final post = userPosts[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(post['username']),
                              subtitle: Text('Location: ${post['location']}, Likes:  ${post['likes']}'),
                              leading: CircleAvatar(
                                child: Text(
                                  post['username'] != null ? post['username'][0].toUpperCase() : '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            // Add more post information fields as needed

                            // Display the post image
                            Image.asset(
                              post['image_path'],
                              height: 200,
                              fit: BoxFit.cover,
                            ),

                            // Add a comment button
                            IconButton(
                              icon: Icon(Icons.comment),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostCommentsPage(postId: post['id']),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showPostTypeSelectionDialog(); // Display the dialog for selecting post type
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        onHomePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        onMapPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MapPage()),
          );
        },
        onNotificationsPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EventsPage()),
          );
        },
      ),
    );
  }
}
