// ignore_for_file: deprecated_member_use, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ניהול משתמשים',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ComicNeue',
      ),
      home: const UserManagementScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class User {
  final String id;
  String name;
  List<String> permissions;
  Color color;

  User({
    required this.id,
    required this.name,
    required this.permissions,
    required this.color,
  });
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final List<User> _users = [
    User(
      id: '1',
      name: 'דני כהן',
      permissions: ['ניהול', 'עריכה'],
      color: const Color(0xFFFFD6E0),
    ),
    User(
      id: '2',
      name: 'שרית לוי',
      permissions: ['צפייה', 'הורדה'],
      color: const Color(0xFFC5E7FF),
    ),
    User(
      id: '3',
      name: 'מאיר יצחק',
      permissions: ['ניהול', 'מחיקה'],
      color: const Color(0xFFFFFFB5),
    ),
  ];

  void _addUser() {
    showDialog(
      context: context,
      builder: (context) => UserEditDialog(
        onSave: (name, permissions) {
          setState(() {
            _users.add(User(
              id: DateTime.now().toString(),
              name: name,
              permissions: permissions.split(','),
              color: Color((DateTime.now().millisecond * 0xFFFFFF).toInt()).withOpacity(0.2),
            ));
          });
        },
      ),
    );
  }

  void _editUser(User user) {
    showDialog(
      context: context,
      builder: (context) => UserEditDialog(
        name: user.name,
        permissions: user.permissions.join(','),
        onSave: (name, permissions) {
          setState(() {
            user.name = name;
            user.permissions = permissions.split(',');
          });
        },
      ),
    );
  }

  void _deleteUser(String id) {
    setState(() {
      _users.removeWhere((user) => user.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('המשתמש נמחק!'),
        backgroundColor: Colors.red[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ניהול משתמשים'),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            return _buildUserCard(user);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 6,
      shadowColor: user.color.withOpacity(0.8),
      child: Container(
        decoration: BoxDecoration(
          color: user.color,
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            colors: [user.color, user.color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          leading: CircleAvatar(
            backgroundColor: Colors.white70,
            child: Text(
              user.name[0],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            user.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Wrap(
            spacing: 8,
            children: user.permissions
                .map((perm) => Chip(
                      label: Text(perm),
                      backgroundColor: Colors.white70,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ))
                .toList(),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _editUser(user),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteUser(user.id),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserEditDialog extends StatefulWidget {
  final Function(String, String) onSave;
  final String? name;
  final String? permissions;

  const UserEditDialog({
    super.key,
    required this.onSave,
    this.name = '',
    this.permissions = '',
  });

  @override
  State<UserEditDialog> createState() => _UserEditDialogState();
}

class _UserEditDialogState extends State<UserEditDialog> {
  final _nameController = TextEditingController();
  final _permissionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name!;
    _permissionsController.text = widget.permissions!;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.name!.isEmpty ? 'הוספת משתמש' : 'עריכת משתמש'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'שם משתמש',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _permissionsController,
            decoration: InputDecoration(
              labelText: 'הרשאות (מופרדות בפסיק)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('ביטול'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSave(_nameController.text, _permissionsController.text);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text('שמור'),
        ),
      ],
    );
  }
}