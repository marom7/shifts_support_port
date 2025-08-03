// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ניהול משתמשים בטבלה',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ComicNeue',
      ),
      home: const UserTableScreen(),
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

// UserTableScreen class for displaying user management in a table format
class UserTableScreen extends StatefulWidget {
  const UserTableScreen({super.key});

  @override
  State<UserTableScreen> createState() => _UserTableScreenState();
}

class _UserTableScreenState extends State<UserTableScreen> {
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
        title: const Text('ניהול משתמשים - טבלה'),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addUser,
            tooltip: 'הוסף משתמש',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // כותרת הטבלה
            _buildTableHeader(),
            const SizedBox(height: 8),
            // גוף הטבלה עם גלילה
            Expanded(
              child: ListView.separated(
                itemCount: _users.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return _buildUserRow(_users[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'שם משתמש',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'הרשאות',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'פעולות',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRow(User user) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: user.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        gradient: LinearGradient(
          colors: [user.color, user.color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // עמודת שם
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: Text(
                    user.name[0],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          
          // עמודת הרשאות
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
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
            ),
          ),
          
          // עמודת פעולות
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editUser(user),
                  tooltip: 'ערוך',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(user.id),
                  tooltip: 'מחק',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// UserEditDialog class for adding/editing users
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