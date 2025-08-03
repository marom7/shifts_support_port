/*
 * A Flutter screen demonstrating a simple data table with edit, add and delete
 * capabilities for managing users and their permissions.  The table is styled
 * with rounded corners and playful colours to give it a light‑hearted feel.
 *
 * To run this example:
 *   1. Ensure you have Flutter installed.
 *   2. Create a new Flutter project or add this file to an existing one.
 *   3. Replace the contents of `lib/main.dart` with the code below, or
 *      import and use `UserTableScreen` from this file.
 *   4. Run `flutter run`.
 */

import 'package:flutter/material.dart';

void main() {
  runApp(const UserTableApp());
}

/// Root widget for the user table demonstration app.
class UserTableApp extends StatelessWidget {
  const UserTableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Permissions Table',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.purple.shade50,
        visualDensity: VisualDensity.adaptivePlatformDensity, 
        dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
      ),
      home: const UserTableScreen(),
    );
  }
}

/// Model representing a single user with a name and permission level.
class User {
  String name;
  String permission;

  User({required this.name, required this.permission});
}

/// Stateful widget hosting a table of users and their permissions.  Users can
/// be added, edited or removed via dialog modals.  The table sits inside a
/// rounded card for a softer look, and accent colours are used throughout.
class UserTableScreen extends StatefulWidget {
  const UserTableScreen({super.key});

  @override
  State<UserTableScreen> createState() => _UserTableScreenState();
}

class _UserTableScreenState extends State<UserTableScreen> {
  /// List of users displayed in the table.
  final List<User> _users = <User>[
    User(name: 'Alice', permission: 'Admin'),
    User(name: 'Bob', permission: 'Editor'),
    User(name: 'Charlie', permission: 'Viewer'),
  ];

  /// Display a dialog for adding a new user to the table.
  Future<void> _addUserDialog() async {
    String newName = '';
    String newPermission = '';
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text('Add User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) {
                    newName = value;
                  },
                ),
                const SizedBox(height: 12.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Permission',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) {
                    newPermission = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
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

  /// Display a dialog for editing an existing user at the given index.
  Future<void> _editUserDialog(int index) async {
    final User user = _users[index];
    String newName = user.name;
    String newPermission = user.permission;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text('Edit User'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: newName),
                  onChanged: (String value) {
                    newName = value;
                  },
                ),
                const SizedBox(height: 12.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Permission',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: newPermission),
                  onChanged: (String value) {
                    newPermission = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text('Save'),
              onPressed: () {
                if (newName.isNotEmpty && newPermission.isNotEmpty) {
                  setState(() {
                    _users[index] = User(name: newName, permission: newPermission);
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

  /// Prompt for confirmation before deleting a user at the given index.
  Future<void> _deleteUser(int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text('Delete User'),
          content: Text('Are you sure you want to delete ${_users[index].name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (confirm ?? false) {
      setState(() {
        _users.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Permissions'),
        elevation: 4.0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 8.0,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 32.0,
                  headingRowColor: WidgetStateProperty.all(Colors.purple.shade100),
                  dataRowColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.purple.shade50;
                    }
                    return Colors.purple.shade50;
                  }),
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Name')), 
                    DataColumn(label: Text('Permission')), 
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: List<DataRow>.generate(
                    _users.length,
                    (int index) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(_users[index].name)),
                        DataCell(Text(_users[index].permission)),
                        DataCell(Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent),
                              onPressed: () => _editUserDialog(index),
                              tooltip: 'Edit',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () => _deleteUser(index),
                              tooltip: 'Delete',
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addUserDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add User'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}