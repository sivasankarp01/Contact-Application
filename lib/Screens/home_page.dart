import 'package:flutter/material.dart';

import '../Models/contact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'contact_detail.dart';

import 'add_edit_contact_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ContactListScreen();
  }
}



class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList('contacts') ?? [];
    setState(() {
      contacts = jsonList.map((json) => Contact.fromJson(jsonDecode(json))).toList();
    });
  }

  Future<void> saveContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = contacts.map((contact) => jsonEncode(contact.toJson())).toList();
    await prefs.setStringList('contacts', jsonList);
  }

  void deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
      saveContacts();
    });
  }

  void addContact(Contact contact) {
    setState(() {
      contacts.add(contact);
      saveContacts();
    });
  }

  void editContact(int index, Contact contact) {
    setState(() {
      contacts[index] = contact;
      saveContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          Contact contact = contacts[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(contact.name[0]), // Placeholder image using the first letter
            ),
            title: Text(contact.name),
            subtitle: Text(contact.phoneNumber),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEditContactScreen(
                          contact: contact,
                          onSave: (updatedContact) {
                            editContact(index, updatedContact);
                          },
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => deleteContact(index),
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactDetailsScreen(contact: contact),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditContactScreen(
                onSave: (newContact) => addContact(newContact),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}