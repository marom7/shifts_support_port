// ignore_for_file: deprecated_member_use

/*
 * A Flutter screen demonstrating a list‑based interface for managing users and
 * their permissions.  Each user entry appears in a card with a soft blue
 * background and rounded corners.  Users can be added, edited and deleted
 * through modal dialogs.  The overall colour scheme uses light blues for a
 * calming, professional feel.
 *
 * To run:
 *   1. Place this file in your Flutter project’s `lib/` directory.
 *   2. Replace `main.dart` with this content or import and use
 *      `UserPermissionsListScreen` as your home widget.
 *   3. Execute `flutter run`.
 */

import 'package:flutter/material.dart';

void main() {
  runApp(const UserPermissionsApp());
}

/// Entry point widget for the user permissions list demonstration.
class UserPermissionsApp extends StatelessWidget {
  const UserPermissionsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Permissions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue.shade50,
      ),
      home: const UserPermissionsListScreen(),
    );
  }
}

/// Model class representing a user with a name and permission level.
class User {
  String name;
  String permission;

  User({required this.name, required this.permission});
}

/// Main widget that displays the list of users and allows interactions.
class UserPermissionsListScreen extends StatefulWidget {
  const UserPermissionsListScreen({super.key});

  @override
  State<UserPermissionsListScreen> createState() => _UserPermissionsListScreenState();
}

class _UserPermissionsListScreenState extends State<UserPermissionsListScreen> {
  /// Internal list of users currently displayed.
  final List<User> _users = <User>[
    User(name: 'Alice', permission: 'Administrator'),
    User(name: 'Bob', permission: 'Editor'),
    User(name: 'Charlie', permission: 'Viewer'),
  ];

  /// Display a dialog to add a new user.
  Future<void> _addUserDialog() async {
    String newName = '';
    String newPermission = '';
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text('Add User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) => newName = value,
                ),
                const SizedBox(height: 12.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Permission',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) => newPermission = value,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Add'),
              onPressed: () {
                if (newName.isNotEmpty && newPermission.isNotEmpty) {
                  setState(() {
                    _users.add(User(name: newName, permission: newPermission));
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Display a dialog to edit an existing user.
  Future<void> _editUserDialog(int index) async {
    final User user = _users[index];
    String updatedName = user.name;
    String updatedPermission = user.permission;
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text('Edit User'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: updatedName),
                  onChanged: (String value) => updatedName = value,
                ),
                const SizedBox(height: 12.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Permission',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: updatedPermission),
                  onChanged: (String value) => updatedPermission = value,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Save'),
              onPressed: () {
                if (updatedName.isNotEmpty && updatedPermission.isNotEmpty) {
                  setState(() {
                    _users[index] = User(name: updatedName, permission: updatedPermission);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Prompt the user before deleting a user.
  Future<void> _deleteUser(int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text('Delete User'),
          content: Text('Delete ${_users[index].name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    if (confirm ?? false) {
      setState(() => _users.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users & Permissions'),
        elevation: 4.0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _users.length,
        itemBuilder: (BuildContext context, int index) {
          final User user = _users[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.blue.shade200.withOpacity(0.4),
                  offset: const Offset(0, 2),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(user.permission),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.indigo),
                    tooltip: 'Edit',
                    onPressed: () => _editUserDialog(index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    tooltip: 'Delete',
                    onPressed: () => _deleteUser(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addUserDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}