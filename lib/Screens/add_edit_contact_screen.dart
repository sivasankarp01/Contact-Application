import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:contact/Models/contact.dart';
import 'package:image_picker/image_picker.dart'; 
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
  File? _image; // To store the image file

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      name = widget.contact!.name;
      phoneNumber = widget.contact!.phoneNumber;
      email = widget.contact!.email;
      dob = widget.contact!.dob;
      _image = widget.contact!.image != null ? File(widget.contact!.image!) : null;
    } else {
      name = '';
      phoneNumber = '';
      email = '';
      dob = DateTime.now();
    }
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


 Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _captureImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
               Center(
                child: _image == null
                    ? Text('No Image Selected')
                    : Image.file(
                        _image!,
                        height: 150,
                        width: 150,
                      ),
              ),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Select Image'),
                  ),
                  ElevatedButton(
                    onPressed: _captureImage,
                    child: Text('Capture Image'),
                  ),
                ],
              ),
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
              TextFormField(
                initialValue: phoneNumber,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  if (value.length != 10) {
                    return 'Contact must be 10 digit';
                  }
                  return null;
                },
                onSaved: (value) => phoneNumber = value!,
              ),
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  final RegExp emailRegExp = RegExp(
                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                  );
                  if (!emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => email = value!,
              ),

              ListTile(
                title: Text('Date of Birth'),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(dob)),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDOB,
              ),
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
                        image: _image?.path,
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
