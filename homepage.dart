import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'map.dart';
import 'event.dart';
import 'post_comments.dart';
import 'myprofile.dart';
import 'userpage.dart';

class Post {
  final String username;
  final String imagePath;
  final String location;
  final int userId;
  final int postId;  // Add userId to represent the foreign key
  final int likes;

  Post({
    required this.username,
    required this.imagePath,
    required this.location,
    required this.userId,
    required this.postId,
    required this.likes,


  });
}


Future<List<Post>> fetchPosts() async {
  try {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((post) => Post(
        username: post['username'],
        imagePath: post['image_path'],
        location: post['location'],
        userId: post['user_id'],  // Include userId from the response
        postId: post['id'],
        likes: post['likes']

      )).toList();
    } else {
      print('Failed to load posts. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching posts: $e');
    return [];
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Woof World! 🐾"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                "Woof World! 🐾", // Replace with the user's name
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyProfilePage()),
              );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Log Out'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform logout logic here
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Log Out'),
          ),
        ],
      );
    },
  );
},

            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            List<Post> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                Post post = posts[index];
                return InstagramPostWidget(
                  username: post.username,
                  location: post.location,
                  postImage: AssetImage(post.imagePath),
                  userId: post.userId,
                  postId: post.postId,
                  likes: post.likes,

                );
              },
            );
          } else {
            return Text('No data available');
          }
        },
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



class InstagramPostWidget extends StatefulWidget {
  final String username;
  final String location;
  final ImageProvider postImage;
  final int userId;
  final int postId;
  int likes; // Add likes property

  InstagramPostWidget({
    required this.username,
    required this.location,
    required this.postImage,
    required this.userId,
    required this.postId,
    required this.likes,
  });

  @override
  _InstagramPostWidgetState createState() => _InstagramPostWidgetState();
}

class _InstagramPostWidgetState extends State<InstagramPostWidget> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    // Call the API to get the like status when the widget is initialized
    fetchLikeStatus();
  }

  Future<void> fetchLikeStatus() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/posts/${widget.postId}/like-status/${UserAuth.userId}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          isLiked = data['liked'];
        });
      } else {
        print('Failed to fetch like status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching like status: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Text(widget.username.substring(0, 1)),
            ),
            title: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(userId: widget.userId),
                  ),
                );
              },
              child: Text(widget.username),
            ),
            subtitle: Text(widget.location),
          ),
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            child: Image(image: widget.postImage, fit: BoxFit.cover),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                      icon: Container(
                        width: 50,
                        height: 50,
                        child: Image.asset(
                          isLiked ? 'assets/paw_black.png' : 'assets/paw_pink.png',
                        ),
                      ),
                      onPressed: () async {
                        // Send a POST request to like or unlike the post
                        final response = await http.post(Uri.parse('http://10.0.2.2:5000/api/posts/${widget.postId}/${UserAuth.userId}/like'));
                        if (response.statusCode == 200) {
                          print("111111111111111111111111111111111111111111111111111111111111");
                          final Map<String, dynamic> data = json.decode(response.body);
                          setState(() {
                            // Update isLiked and likes based on the server response
                            isLiked = data['liked'];
                            widget.likes = data['likes'];
                          });
                        } else {
                          print('Failed to like or unlike the post. Status code: ${response.statusCode}');
                        }
                      },
                    ),
                  Text('${widget.likes} likes'),
                ],
              ),
              IconButton(
                icon: Icon(Icons.comment),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostCommentsPage(postId: widget.postId),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // Share button action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class CustomBottomNavigationBar extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onMapPressed;
  final VoidCallback onNotificationsPressed;

  CustomBottomNavigationBar({
    required this.onHomePressed,
    required this.onMapPressed,
    required this.onNotificationsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Events',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            onHomePressed();
            break;
          case 1:
            onMapPressed();
            break;
          case 2:
            onNotificationsPressed();
            break;
        }
      },
    );
  }
}


// class InstagramPostWidget extends StatefulWidget {
//   final String username;
//   final String location;
//   final ImageProvider postImage;
//   final int userId;
//   final int postId; // Add postId as a property
//   final int likes;

//   InstagramPostWidget({
//     required this.username,
//     required this.location,
//     required this.postImage,
//     required this.userId,
//     required this.postId, // Include postId in the constructor
//     required this.likes,

//   });

//   @override
//   _InstagramPostWidgetState createState() => _InstagramPostWidgetState();
// }

// class _InstagramPostWidgetState extends State<InstagramPostWidget> {
//   bool isLiked = false;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 5,
//       margin: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           ListTile(
//             leading: CircleAvatar(
//               child: Text(widget.username.substring(0, 1)),
//             ),
//             title: GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => UserProfilePage(userId: widget.userId),
//                   ),
//                 );
//               },
//               child: Text(widget.username),
//             ),
//             subtitle: Text(widget.location),
//           ),
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
//             child: Image(image: widget.postImage, fit: BoxFit.cover),
//           ),
//           ButtonBar(
//             alignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               IconButton(
//                 icon: Container(
//                   width: 50,
//                   height: 50,
//                   child: Image.asset(
//                     isLiked ? 'assets/paw_black.png' : 'assets/paw_pink.png',
//                   ),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     isLiked = !isLiked;
//                   });
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.comment),
//                 onPressed: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PostCommentsPage(postId: widget.postId),
//       ),
//     );
//                 }
//               ),
//               IconButton(
//                 icon: Icon(Icons.share),
//                 onPressed: () {
//                   // Share button action
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

