// import 'dart:convert';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'main.dart';
// import 'homepage.dart';

// class NewPostPage extends StatefulWidget {

//   @override
//   _NewPostPageState createState() => _NewPostPageState();
// }

// class _NewPostPageState extends State<NewPostPage> {
//   late Map<String, dynamic> userInfo;

//   final TextEditingController locationController = TextEditingController();
//   File? selectedImage;

//   Future<void> pickImageFromGallery() async {
//     final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

//         if (returnedImage == null) return;

//     setState(() {
//       selectedImage = File(returnedImage!.path);
//       }
//     );
//   }

//   Future<void> pickImageFromCamera() async {
//     final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);

//     if (returnedImage == null) return;
//     setState(() {
//       selectedImage = File(returnedImage!.path);
//       }
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Create New Post'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Image picker
//             ElevatedButton(
//               onPressed: pickImageFromGallery,
//               child: Text('Pick Image From Phone Gallery'),
//             ),
//             SizedBox(height: 16),

//             ElevatedButton(
//               onPressed: pickImageFromCamera,
//               child: Text('Pick Image From Phone Camera'),
//             ),
//             SizedBox(height: 16),

//             // Display selected image
//             selectedImage != null
//                 ? Image.file(
//                     selectedImage!,
//                     height: 100,
//                     width: 100,
//                     fit: BoxFit.cover,
//                   )
//                 : Container(),

//             SizedBox(height: 16),

//             // Text field for location
//             TextField(
//               controller: locationController,
//               decoration: InputDecoration(labelText: 'Location'),
//             ),

//             SizedBox(height: 16),

//             ElevatedButton(
//               onPressed: () => createPost(context),
//               child: Text('Create Post'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }


//   Future<void> fetchUserData() async {
//     try {
//       final userResponse = await http.get(
//         Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}'),
//       );


//       if (userResponse.statusCode == 200) {
//         final Map<String, dynamic> userData = json.decode(userResponse.body);
//         setState(() {
//           userInfo = userData['user'];
//         });
//       } else {
//         print('Failed to load user information. Status codes: ${userResponse.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching user data: $e');
//     }
//   }

//   Future<void> createPost(BuildContext context) async {
//   if (selectedImage == null) {
//     // Show an error if the user tries to create a post without an image
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text('Please pick an image.'),
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
//     return;
//   }

//   // Assuming you have a function to upload the post to the server
//   // Modify the function based on your server implementation
//   await uploadPostToServer('assets/pet26.png', 'Thessaloniki', 1);

//   Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//   );
// }

// Future<void> uploadPostToServer(String imagePath, String location, int userId) async {
//   try {
//     // Construct the post data
//     Map<String, dynamic> postData = {
//       'image_path': 'assets/pet26.png',
//       'location': location,
//       'user_id': UserAuth.userId,
//       'likes': 0,
//     };

//     // Send the post request to your server
//     var response = await http.post(
//       Uri.parse('http://your-server-api-endpoint/create_post'),
//       body: postData,
//     );

//     if (response.statusCode == 200) {
//       print('Post created successfully');
//       // You can handle success as needed, such as navigating to a different screen
//     } else {
//       print('Failed to create post. Status code: ${response.statusCode}');
//       // Handle the failure scenario
//     }
//   } catch (e) {
//     print('Error creating post: $e');
//     // Handle the error scenario
//   }
// }
// }

import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'homepage.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  late Map<String, dynamic> userInfo;

  final TextEditingController locationController = TextEditingController();
  File? selectedImage;

  Future<void> pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;

    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  Future<void> pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickImageFromGallery,
              child: Text('Pick Image From Phone Gallery'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: pickImageFromCamera,
              child: Text('Pick Image From Phone Camera'),
            ),
            SizedBox(height: 16),
            selectedImage != null
                ? Image.file(
                    selectedImage!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : Container(),
            SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => createPost(context),
              child: Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createPost(BuildContext context) async {
    if (selectedImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please pick an image.'),
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
      return;
    }


    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:5000/create_post'),
    );

    // Add other fields to the request
    request.fields['location'] = locationController.text;
    request.fields['user_id'] = UserAuth.userId.toString();
    request.fields['likes'] = '0';
    request.fields['image_path'] = 'assets/pet26.png' ;

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Post created successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        print('Failed to create post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating post: $e');
    }
  }
}
