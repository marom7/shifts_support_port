// ignore_for_file: constant_identifier_names, depend_on_referenced_packages

/*
 * דוגמת מסך Flutter המציגה טבלת משתמשים והרשאות בשפה העברית.
 * המסך מאפשר להוסיף, לערוך ולמחוק משתמשים בתוך טבלה מעוצבת
 * עם פינות מעוגלות וצבעים נעימים.  הטקסטים והכפתורים כולם
 * בעברית, והכיוון הכללי של הממשק הוא מימין לשמאל.
 *
 * כדי להריץ:
 *   1. ודאו ש‑Flutter מותקן.
 *   2. הוסיפו את הקובץ הזה לתיקיית `lib/` של הפרויקט.
 *   3. החליפו את תוכן `main.dart` בקוד זה או ייבאו את
 *      המחלקה `HebrewUserTableScreen` בתוך הפרויקט שלכם.
 *   4. הריצו `flutter run`.
 */

import 'package:flutter/material.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const HebrewUserTableApp());
}
enum UserRole { ADMIN, EDITOR, VIEWER }
/// וידג'ט שורש עבור האפליקציה בעברית.
class HebrewUserTableApp extends StatelessWidget {
  const HebrewUserTableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "טבלת הרשאות משתמשים",
      locale: const Locale('he'),
      localizationsDelegates: const[
        DefaultMaterialLocalizations.delegate,
        //GlobalWidgetsLocalizations.delegate,
        //GlobalCupertinoLocalizations.delegate,
      ],
      
      // מגדיר את הכיוון הכללי של הטקסטים והאלמנטים לעברית (מימין לשמאל)
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.purple.shade50,
        visualDensity: VisualDensity.adaptivePlatformDensity, 
        dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
      ),
      home: const HebrewUserTableScreen(),
    );
  }
}

/// מודל המייצג משתמש בודד עם שם והרשאה.
class User {
  String name;
  UserRole permission;

  User({required this.name, required this.permission});
}

/// וידג'ט מציג טבלה של משתמשים והרשאות בעברית.
class HebrewUserTableScreen extends StatefulWidget {
  const HebrewUserTableScreen({super.key});

  @override
  State<HebrewUserTableScreen> createState() => _HebrewUserTableScreenState();
}

class _HebrewUserTableScreenState extends State<HebrewUserTableScreen> {

  /// רשימת המשתמשים המוצגת בטבלה.
  final List<User> _users = <User>[
    User(name: "אליס", permission: UserRole.ADMIN),
    User(name: "בוב", permission: UserRole.EDITOR),
    User(name: "צארלי", permission: UserRole.VIEWER),
  ];

  /// מציג חלון הוספת משתמש חדש.
  Future<void> _addUserDialog() async {
    String newName = "";
    UserRole newPermission = UserRole.VIEWER;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text("הוסף משתמש"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: "שם",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) {
                    newName = value;
                  },
                ),
                const SizedBox(height: 12.0),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "הרשאה",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (String value) {
                    newPermission = UserRole.values.where((element) => element.toString().split('.')[1] == value).first; 
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("ביטול"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              child: const Text("הוסף"),
              onPressed: () {
                if (newName.isNotEmpty) {
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

  /// מציג חלון עריכת משתמש קיים.
  Future<void> _editUserDialog(int index) async {
    final User user = _users[index];
    String newName = user.name;
    UserRole newPermission = user.permission;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text("ערוך משתמש"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(
                    labelText: "שם",
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: newName),
                  onChanged: (String value) {
                    newName = value;
                  },
                ),
                const SizedBox(height: 12.0),
                DropdownButtonFormField<UserRole>(
                  value: newPermission,
                  decoration: const InputDecoration(
                    labelText: "הרשאה",
                    border: OutlineInputBorder(),
                  ),
                  items: UserRole.values.map((UserRole role) {
                    return DropdownMenuItem<UserRole>(
                      value: role,
                      child: Text(role.toString().split('.')[1]),
                    );
                  }).toList(),
                  onChanged: (UserRole? value) {
                    if (value != null) {
                      newPermission = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("ביטול"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple.shade300, // Updated to a lighter purple shade
              ),
              child: const Text("שמור"),
              onPressed: () {
                if (newName.isNotEmpty) {
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

  /// מבקש אישור לפני מחיקת משתמש.
  Future<void> _deleteUser(int index) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: const Text("מחק משתמש"),
          content: Text("האם אתה בטוח שברצונך למחוק את ${_users[index].name}?"),
          actions: <Widget>[
            TextButton(
              child: const Text("ביטול"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
              ),
              child: const Text("מחק"),
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
        title: const Text("הרשאות משתמשים"),
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
                  dataRowColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.purple.shade50;
                    }
                    return Colors.purple.shade50;
                  }),
                  columns: const <DataColumn>[
                    DataColumn(label: Text("שם")),
                    DataColumn(label: Text("הרשאה")),
                    DataColumn(label: Text("פעולות")),
                  ],
                  rows: List<DataRow>.generate(
                    _users.length,
                    (int index) => DataRow(
                      cells: <DataCell>[
                        DataCell(Text(_users[index].name)),
                        DataCell(Text(_users[index].permission.toString().split('.')[1])),
                        DataCell(Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Colors.blueAccent),
                              onPressed: () => _editUserDialog(index),
                              tooltip: "ערוך",
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () => _deleteUser(index),
                              tooltip: "מחק",
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
        label: const Text("הוסף משתמש"),
        backgroundColor: Colors.purple.shade300,
      ),
    );
  }
}