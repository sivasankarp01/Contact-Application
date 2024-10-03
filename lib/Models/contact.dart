import 'dart:convert';

class Contact {
  String name;
  String phoneNumber;
  String email;
  DateTime dob;
  String location;

  Contact({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.dob,
    required this.location,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phoneNumber': phoneNumber,
    'email': email,
    'dob': dob.toIso8601String(),
    'location': location,
  };

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      dob: DateTime.parse(json['dob']),
      location: json['location'],
    );
  }
}