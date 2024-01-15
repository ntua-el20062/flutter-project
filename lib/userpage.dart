// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'homepage.dart';
// import 'main.dart';
// import 'post_comments.dart';
// import 'map.dart';
// import 'notifications.dart';

// class UserProfilePage extends StatefulWidget {
//   final int userId;

//   UserProfilePage({required this.userId});

//   @override
//   _UserProfilePageState createState() => _UserProfilePageState();
// }

// class _UserProfilePageState extends State<UserProfilePage> {
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
//         Uri.parse('http://10.0.2.2:5000/api/users/${widget.userId}'),
//       );

//       final postsResponse = await http.get(
//         Uri.parse('http://10.0.2.2:5000/api/users/${widget.userId}/posts'),
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

//   Future<void> sendFriendRequest(int receiverUserId) async {
//     try {
//       // Perform the request sending logic
//       // Make a POST request to your Flask API endpoint
//       var response = await http.post(
//         Uri.parse('http://10.0.2.2:5000/api/friendships/${UserAuth.userId}/$receiverUserId'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: jsonEncode(<String, dynamic>{
//           'user_id': UserAuth.userId,
//         }),
//       );

//       // Check if the request was successful
//       if (response.statusCode == 204) {
//         // Request successful, show pop-up window
//         showFriendRequestSentDialog();
//       } else {
//         // Handle the case where the request was not successful
//         print('Failed to send friend request. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle exceptions
//       print('Error sending friend request: $e');
//     }
//   }

//   void showFriendRequestSentDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Friend Request Sent'),
//           content: Text('Your friend request has been sent.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Welcome to my Profile! 🐾'),
        
//       ),
//       body: userInfo != null
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 ListTile(
//                   title: Text(userInfo['nickname']),
//                 ),
                
//                 ListTile(
//                   title: Text('Email: ${userInfo['email']}'),
//                 ),
//                 ElevatedButton(
//       onPressed: () async {
//         // Call the function to send the friend request
//         await sendFriendRequest(userInfo['user_id']);

//         // No need to display a pop-up here; it will be shown after the request is sent
//       },
//       child: Text('Add Friend'),
//     ),
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
//             MaterialPageRoute(builder: (context) => NotificationPage()),
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
import 'learn_about_me.dart';
import 'event.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class UserProfilePage extends StatefulWidget {
  final int userId;

  UserProfilePage({required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
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
        Uri.parse('http://10.0.2.2:5000/api/users/${widget.userId}'),
      );

      final postsResponse = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${widget.userId}/posts'),
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

  Future<void> sendFriendRequest(int receiverUserId) async {
    try {
      
      var response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/friendships/${UserAuth.userId}/$receiverUserId'),
      );

      if (response.statusCode == 204) {
        showFriendRequestSentDialog();
      } else {
        print('Failed to send friend request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

  void showFriendRequestSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Friend Request Sent'),
          content: Text('Your friend request has been sent.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Welcome to my Profile! 🐾'),
  //     ),
  //     body: userInfo != null
  //         ? Column(
  //             crossAxisAlignment: CrossAxisAlignment.stretch,
  //             children: [
  //               ListTile(
  //                 title: Text(userInfo['nickname']),
  //               ),

  //               ListTile(
  //                 title: Text('Account Type: ${userInfo['account_type']}'),
  //               ),
 
  //               if (userInfo['account_type'] == 'business') {
  //                   ListTile(
  //                     title: Text('Business Name: ${userInfo['business_name']}'),
  //                   ),
  //                   launchButton(
  //                     title: 'Phone: ${userInfo['phone']}', 
  //                     icon: Icons.phone_rounded, 
  //                     onPressed: () async {
  //                       Uri uri = Uri.parse('tel:${userInfo['phone']}');
  //                       if (!await launcher.launchUrl(uri)) {
  //                         debugPrint("Could not launch the phone");
  //                       }
  //                     },
  //                 ),
  //               },

  //               launchButton(
  //                 title: 'Email: ${userInfo['email']}', 
  //                 icon: Icons.email_rounded, 
  //                 onPressed: () async {
  //                   Uri uri = Uri.parse('mailto:${userInfo['email']}');
  //                   if (!await launcher.launchUrl(uri)) {
  //                     debugPrint("could not launch the email");
  //                   }
  //                 },
  //               ),

  //               ElevatedButton(
  //                 onPressed: () async {
  //                   await sendFriendRequest(widget.userId);
  //                 },
  //                 child: Text('Add Friend'),
  //               ),

  //               ElevatedButton(
  //                 onPressed: () async {
  //                     Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => LearnAboutMePage(userId: widget.userId),
  //                           ),
  //                     );                  
  //                 },
  //                 child: Text('Learn About ${userInfo['nickname']}'),
  //               ),

  //               Divider(),
  //               ListTile(
  //                 title: Text('User Posts'),
  //               ),
  //               Expanded(
  //                 child: ListView.builder(
  //                   itemCount: userPosts.length,
  //                   itemBuilder: (context, index) {
  //                     final post = userPosts[index];
  //                     return Card(
  //                       margin: EdgeInsets.all(8.0),
  //                       child: Column(
  //                         children: [
  //                           ListTile(
  //                             title: Text(post['username']),
  //                             subtitle: Text('Location: ${post['location']}'),
  //                             leading: CircleAvatar(
  //                               child: Text(
  //                                 post['username'] != null ? post['username'][0].toUpperCase() : '',
  //                                 style: TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.white,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                           Image.asset(
  //                             post['image_path'],
  //                             height: 200,
  //                             fit: BoxFit.cover,
  //                           ),
  //                           IconButton(
  //                             icon: Icon(Icons.comment),
  //                             onPressed: () {
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                   builder: (context) => PostCommentsPage(postId: post['id']),
  //                                 ),
  //                               );
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ),
  //             ],
  //           )
  //         : Center(
  //             child: CircularProgressIndicator(),
  //           ),
  //     bottomNavigationBar: CustomBottomNavigationBar(
  //       onHomePressed: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => HomePage()),
  //         );
  //       },
  //       onMapPressed: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => MapPage()),
  //         );
  //       },
  //       onNotificationsPressed: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => EventsPage()),
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Welcome to my Profile! 🐾'),
    ),
    body: userInfo != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text(userInfo['nickname']),
              ),

              ListTile(
                title: Text('Account Type: ${userInfo['account_type']}'),
              ),
              
              // Conditionally add widgets for business type
              if (userInfo['account_type'] == 'business') ...[
                ListTile(
                  title: Text('Business Name: ${userInfo['business_name']}'),
                ),
                launchButton(
                  title: 'Phone: ${userInfo['phone']}',
                  icon: Icons.phone_rounded,
                  onPressed: () async {
                    Uri uri = Uri.parse('tel:${userInfo['phone']}');
                    if (!await launcher.launchUrl(uri)) {
                      debugPrint("Could not launch the phone");
                    }
                  },
                ),
              ],

              launchButton(
                title: 'Email: ${userInfo['email']}',
                icon: Icons.email_rounded,
                onPressed: () async {
                  Uri uri = Uri.parse('mailto:${userInfo['email']}');
                  if (!await launcher.launchUrl(uri)) {
                    debugPrint("could not launch the email");
                  }
                },
              ),

              ElevatedButton(
                onPressed: () async {
                  await sendFriendRequest(widget.userId);
                },
                child: Text('Add Friend'),
              ),

              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LearnAboutMePage(userId: widget.userId),
                    ),
                  );
                },
                child: Text('Learn About ${userInfo['nickname']}'),
              ),

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
                            subtitle: Text('Location: ${post['location']}, Likes: ${post['likes']}'),
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
                          Image.asset(
                            post['image_path'],
                            height: 200,
                            fit: BoxFit.cover,
                          ),
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


  Widget launchButton({
    required String title, 
    required IconData icon, 
    required Function() onPressed, 
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical:10),
      child: ElevatedButton(
        onPressed: onPressed, 
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ]
      ),
     )
    );
  }
}






