import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../Models/contact.dart';

class ContactDetailsScreen extends StatelessWidget {
  final Contact contact;

  ContactDetailsScreen({required this.contact});

  // Launch dialer
  Future<void> _launchCaller(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await launchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  // Launch email client
  Future<void> _launchEmail(String email) async {
    final url = 'mailto:$email';
    if (await launchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format date of birth
    String formattedDOB = DateFormat('yyyy-MM-dd').format(contact.dob);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(contact.name.toUpperCase()),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
               
                backgroundColor: Colors.grey[300], // Background for placeholder
                child: contact.image != null && contact.image!.isNotEmpty
                    ? ClipOval(
                        child: Image.file(
                          File(contact.image!), // Load image from file
                          fit: BoxFit.cover,
                          width: 200,
                          height: 200,
                        ),
                      )
                    : Text(
                        contact.name[0]
                            .toUpperCase(), // Show initials if no image
                        style: TextStyle(fontSize: 40, color: Colors.purple),
                      ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
              color: Colors.purple,
            ),
            SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () => _launchCaller(contact.phoneNumber),
                      child: CircleAvatar(
                        radius: 25,
                        child: Icon(Icons.phone),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Call")
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () => _launchEmail(contact.email),
                      child: CircleAvatar(
                        radius: 25,
                        child: Icon(Icons.mail),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Mail")
                  ],
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              color: const Color.fromARGB(255, 245, 236, 247),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Conact info",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.call),
                    title: Text(contact.phoneNumber),
                    subtitle: Text("Mobile"),
                  ),
                  ListTile(
                    leading: Icon(Icons.calendar_month),
                    title: Text(formattedDOB),
                    subtitle: Text("Date of Birth"),
                  ),
                  ListTile(
                    leading: Icon(Icons.mail),
                    title: Text(contact.email),
                    subtitle: Text("E Mail"),
                  ),
                ],
              ),
            )
            // Text('Phone: ${contact.phoneNumber}', style: TextStyle(fontSize: 18)),
            // SizedBox(height: 8),
            // Text('Email: ${contact.email}', style: TextStyle(fontSize: 18)),
            // SizedBox(height: 8),
            // Text('Date of Birth: $formattedDOB', style: TextStyle(fontSize: 18)),
            // SizedBox(height: 8),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   onPressed: () => _launchCaller(contact.phoneNumber),
            //   child: Text('Call'),
            // ),
            // ElevatedButton(
            //   onPressed: () => _launchEmail(contact.email),
            //   child: Text('Send Email'),
            // ),
          ],
        ),
      ),
    );
  }
}
