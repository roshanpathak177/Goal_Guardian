import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideNavBar extends StatelessWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Roshan'), 
            accountEmail: Text('roshan@gmail.com'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'assets/images/apple.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                )
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            ),
          ListTile(
            leading: Icon(Icons.plus_one),
            title: Text("Points"),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.notification_add),
            title: Text("Reminders"),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.file_copy),
            title: Text("Resources"),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help and Support"),
            onTap: () => null,
          ),
          Divider(
            thickness: 2.0,
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Log Out", style: TextStyle(color: Colors.red, fontWeight:FontWeight.bold),),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      )
    );
  }
}