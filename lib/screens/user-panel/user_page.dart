import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../auth-ui/forget-password.dart';
import '../auth-ui/signin.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // If no user is logged in, navigate to SignInScreen
    if (user == null) {
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignInScreen()),
        );
      });
      return const SizedBox(); // Return an empty widget while navigating
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header: User Info Section
          ListTile(
            title: Text('Hello, ${user.displayName ?? 'User'}'),
            subtitle: Text(user.email ?? 'No Email'),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  user.photoURL ?? 'https://via.placeholder.com/150'),
            ),
          ),

          // Settings Options
          const Divider(),
          ListTile(
            title: const Text('Update Profile'),
            onTap: () {
              // update logic
            },
          ),
          ListTile(
            title: const Text('Change Password'),
            onTap: () {
              Get.to(() => ForgotPasswordPage());
            },
          ),
          ListTile(
            title: const Text('My Orders'),
            onTap: () {
              // my orders page
            },
          ),
          ListTile(
            title: const Text('Privacy Settings'),
            onTap: () {
              // Implement Privacy Settings Logic here
            },
          ),
          ListTile(
            title: const Text('App Theme'),
            onTap: () {
              // Implement Theme Switcher Logic here (Light/Dark Mode)
              showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                  title: Text('Choose Theme'),
                  content: Text('Functionality to change app theme goes here.'),
                ),
              );
            },
          ),
          const Divider(),

          // Logout Option
          ListTile(
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignInScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
