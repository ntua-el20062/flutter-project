// map.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'userpage.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(37.7749, -122.4194), // Set the initial map center
          zoom: 13.0, // Set the initial zoom level
        ),
        children: [
          MarkerLayer(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(37.7749, -122.4194), // Set marker position
                builder: (context) => PawMarker(), // Custom marker widget
              ),
              // Add more markers as needed
            ],
          ),
        ],
      ),
    );
  }
}

class PawMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle marker click here, navigate to user page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserProfilePage(userId: 1)),
        );
      },
      child: Image.asset(
        'assets/paw.png', // Replace with your paw emoji image asset
        width: 40.0,
        height: 40.0,
      ),
    );
  }
}
