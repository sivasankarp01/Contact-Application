// import 'package:contact/Models/contact.dart';
// import 'package:flutter/material.dart';


// class AddEditContactScreen extends StatefulWidget {
//   final Contact? contact;
//   final Function(Contact) onSave;

//   AddEditContactScreen({this.contact, required this.onSave});

//   @override
//   _AddEditContactScreenState createState() => _AddEditContactScreenState();
// }

// class _AddEditContactScreenState extends State<AddEditContactScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late String name;
//   late String phoneNumber;
//   late String email;
//   late DateTime dob;
//   late String location;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.contact != null) {
//       name = widget.contact!.name;
//       phoneNumber = widget.contact!.phoneNumber;
//       email = widget.contact!.email;
//       dob = widget.contact!.dob;
//       location = widget.contact!.location;
//     } else {
//       name = '';
//       phoneNumber = '';
//       email = '';
//       dob = DateTime.now();
//       location = '';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.contact != null ? 'Edit Contact' : 'Add Contact'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 initialValue: name,
//                 decoration: InputDecoration(labelText: 'Name'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a name';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => name = value!,
//               ),
//               TextFormField(
//                 initialValue: phoneNumber,
//                 decoration: InputDecoration(labelText: 'Phone Number'),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a phone number';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => phoneNumber = value!,
//               ),
//               TextFormField(
//                 initialValue: email,
//                 decoration: InputDecoration(labelText: 'Email'),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an email';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) => email = value!,
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     widget.onSave(
//                       Contact(
//                         name: name,
//                         phoneNumber: phoneNumber,
//                         email: email,
//                         dob: dob,
//                         location: location,
//                       ),
//                     );
//                     Navigator.pop(context);
//                   }
//                 },
//                 child: Text('Save Contact'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Google Maps

import 'package:contact/Models/contact.dart'; // Import your Contact model

class AddEditContactScreen extends StatefulWidget {
  final Contact? contact;
  final Function(Contact) onSave;

  AddEditContactScreen({this.contact, required this.onSave});

  @override
  _AddEditContactScreenState createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String phoneNumber;
  late String email;
  late DateTime dob;
  late LatLng location; // Using LatLng for Google Maps

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      name = widget.contact!.name;
      phoneNumber = widget.contact!.phoneNumber;
      email = widget.contact!.email;
      dob = widget.contact!.dob;
      location = _parseLocation(widget.contact!.location);
    } else {
      name = '';
      phoneNumber = '';
      email = '';
      dob = DateTime.now();
      location = LatLng(0, 0); // Default location
    }
  }

  LatLng _parseLocation(String locationString) {
    List<String> coords = locationString.split(',');
    return LatLng(double.parse(coords[0]), double.parse(coords[1]));
  }

  Future<void> _pickDOB() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != dob) {
      setState(() {
        dob = pickedDate;
      });
    }
  }

  Future<void> _pickLocation() async {
    // Normally, you'd launch a new screen with a Google Maps picker to choose the location.
    // For now, we'll simulate choosing a random location.

    LatLng pickedLocation = LatLng(37.7749, -122.4194); // Example: San Francisco coords.
    setState(() {
      location = pickedLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact != null ? 'Edit Contact' : 'Add Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Name field
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),

              // Phone number field
              TextFormField(
                initialValue: phoneNumber,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                onSaved: (value) => phoneNumber = value!,
              ),

              // Email field
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),

              // Date of Birth field
              ListTile(
                title: Text('Date of Birth'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(dob)),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDOB,
              ),

              // Location picker
              ListTile(
                title: Text('Location'),
                subtitle: Text('Latitude: ${location.latitude}, Longitude: ${location.longitude}'),
                trailing: Icon(Icons.location_on),
                onTap: _pickLocation, // Function to pick location
              ),

              // Save button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    widget.onSave(
                      Contact(
                        name: name,
                        phoneNumber: phoneNumber,
                        email: email,
                        dob: dob,
                        location: '${location.latitude},${location.longitude}',
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
