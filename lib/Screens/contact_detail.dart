// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../Models/contact.dart';

// class ContactDetailsScreen extends StatelessWidget {
//   final Contact contact;

//   ContactDetailsScreen({required this.contact});

//   Future<void> _launchCaller(String phoneNumber) async {
//     final url = 'tel:$phoneNumber';
//     if (await canLaunch(url)) {
//       await launch(url);
//     }
//   }

//   Future<void> _launchEmail(String email) async {
//     final url = 'mailto:$email';
//     if (await canLaunch(url)) {
//       await launch(url);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(contact.name),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Phone: ${contact.phoneNumber}', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 8),
//             Text('Email: ${contact.email}', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 8),
//             Text('Date of Birth: ${contact.dob.toLocal()}'.split(' ')[0], style: TextStyle(fontSize: 18)),
//             SizedBox(height: 8),
//             Text('Location: ${contact.location}', style: TextStyle(fontSize: 18)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => _launchCaller(contact.phoneNumber),
//               child: Text('Call'),
//             ),
//             ElevatedButton(
//               onPressed: () => _launchEmail(contact.email),
//               child: Text('Send Email'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:google_maps_flutter/google_maps_flutter.dart'; // For map display
import '../Models/contact.dart';

class ContactDetailsScreen extends StatelessWidget {
  final Contact contact;

  ContactDetailsScreen({required this.contact});

  // Launch dialer
  Future<void> _launchCaller(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  // Launch email client
  Future<void> _launchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  // Open Google Maps at the contact's location
  Future<void> _launchMap(String location) async {
    List<String> coords = location.split(',');
    final lat = coords[0];
    final lng = coords[1];
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format date of birth
    String formattedDOB = DateFormat('yyyy-MM-dd').format(contact.dob);

    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phone number
            Text('Phone: ${contact.phoneNumber}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            // Email address
            Text('Email: ${contact.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            // Date of birth
            Text('Date of Birth: $formattedDOB', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            // Location (latitude, longitude) with a button to open Google Maps
            Text('Location: Latitude: ${contact.location.split(',')[0]}, Longitude: ${contact.location.split(',')[1]}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _launchMap(contact.location),
              child: Text('View Location on Map'),
            ),
            SizedBox(height: 20),
            // Call button
            ElevatedButton(
              onPressed: () => _launchCaller(contact.phoneNumber),
              child: Text('Call'),
            ),
            // Send email button
            ElevatedButton(
              onPressed: () => _launchEmail(contact.email),
              child: Text('Send Email'),
            ),
          ],
        ),
      ),
    );
  }
}
