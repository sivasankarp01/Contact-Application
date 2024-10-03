import 'dart:convert';

class Contact {
  String name;
  String phoneNumber;
  String email;
  DateTime dob;
  String? image; // Add image field

  Contact({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.dob,
    this.image,
  });


  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'email': email,
    'dob': dob,
    'image':image
  };

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      dob: DateTime.parse(json['dob']),
      image: json['image'],
    );
  }
}