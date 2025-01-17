import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the DatabaseHelper class
import 'user.dart'; // Import the User class

void main() async {
  // Initialize the database and insert users
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  await DatabaseHelper.instance.initializeUsers();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      home: UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final userMaps = await DatabaseHelper.instance.queryAllUsers();
    setState(() {
      _users = userMaps.map((userMap) => User.fromMap(userMap)).toList();
    });
  }

  // Function to handle delete user action
  Future<void> _deleteUser(int userId) async {
    await DatabaseHelper.instance.deleteUser(userId);
    _fetchUsers(); // Refresh the user list
  }

  // Function to handle edit user action
  void _editUser(User user) {
    TextEditingController usernameController =
        TextEditingController(text: user.username);
    TextEditingController emailController =
        TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedUser = User(
                  id: user.id, // Keep the same id to update the correct record
                  username: usernameController.text,
                  email: emailController.text,
                );
                DatabaseHelper.instance.updateUser(updatedUser).then((value) {
                  _fetchUsers(); // Refresh the user list
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Close the dialog without saving
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addUser() {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New User'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newUser = User(
                  username: usernameController.text,
                  email: emailController.text,
                );
                DatabaseHelper.instance.insertUser(newUser).then((value) {
                  _fetchUsers(); // Refresh the user list
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Close the dialog without adding
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllUsers() async {
    await DatabaseHelper.instance.deleteAllUsers(); // ลบข้อมูลผู้ใช้ทั้งหมด
    _fetchUsers(); // อัปเดตข้อมูลใหม่
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GFG User List'),
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _deleteAllUsers, // ลบข้อมูลทั้งหมดเมื่อกด
            color: Colors.red,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Colors.cyan,
            ),
            title: Text(user.username),
            subtitle: Text(user.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editUser(user), // Edit action
                  color: Colors.blue,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteUser(user.id!), // Delete action
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
