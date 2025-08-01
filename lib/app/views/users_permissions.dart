import 'package:flutter/material.dart';

class UserPermission {
  String username;
  List<String> permissions;
  UserPermission({required this.username, required this.permissions});
}

class UserPermissionScreen extends StatefulWidget {
  @override
  State<UserPermissionScreen> createState() => _UserPermissionScreenState();
}

class _UserPermissionScreenState extends State<UserPermissionScreen> {
  List<UserPermission> userList = [
    UserPermission(username: 'User1', permissions: ['Read', 'Write']),
    UserPermission(username: 'User2', permissions: ['Read']),
    UserPermission(username: 'User3', permissions: ['Read', 'Write', 'Delete']),
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController permController = TextEditingController();

  void addUser() {
    showDialog(
      context: context,
      builder: (context) {
        nameController.clear();
        permController.clear();
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text('הוסף משתמש', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'שם')),
              TextField(controller: permController, decoration: InputDecoration(labelText: 'הרשאות (מופרד בפסיקים)')),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(shape: StadiumBorder(), backgroundColor: Colors.purple),
              child: Text('הוסף'),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    userList.add(
                      UserPermission(
                        username: nameController.text,
                        permissions: permController.text.split(',').map((e) => e.trim()).toList(),
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void editUser(int index) {
    nameController.text = userList[index].username;
    permController.text = userList[index].permissions.join(', ');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: Text('ערוך משתמש', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: 'שם')),
              TextField(controller: permController, decoration: InputDecoration(labelText: 'הרשאות (מופרד בפסיקים)')),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(shape: StadiumBorder(), backgroundColor: Colors.orange),
              child: Text('שמור שינויים'),
              onPressed: () {
                setState(() {
                  userList[index].username = nameController.text;
                  userList[index].permissions = permController.text.split(',').map((e) => e.trim()).toList();
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void deleteUser(int index) {
    setState(() {
      userList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('משתמשים והרשאות', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Icon(Icons.add, size: 33),
        onPressed: addUser,
        tooltip: 'הוסף משתמש',
      ),
      body: ListView.builder(
        itemCount: userList.length,
        itemBuilder: (context, index) {
          final user = userList[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.primaries[index % Colors.primaries.length].shade100,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(user.username[0].toUpperCase()),
                backgroundColor: Colors.primaries[(index + 2) % Colors.primaries.length].shade200,
              ),
              title: Text(user.username, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('הרשאות: ${user.permissions.join(' | ')}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.deepPurple),
                    onPressed: () => editUser(index),
                    tooltip: 'ערוך',
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteUser(index),
                    tooltip: 'מחק',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
