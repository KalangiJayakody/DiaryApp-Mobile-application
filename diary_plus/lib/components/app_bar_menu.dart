import 'package:diary_plus/constant.dart';
import 'package:diary_plus/pages/reset_password.dart';
import 'package:diary_plus/pages/spalsh_screen.dart';
import 'package:diary_plus/service/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppBarPopupMenu extends StatefulWidget {
  const AppBarPopupMenu({super.key});

  @override
  State<AppBarPopupMenu> createState() => _AppBarPopupMenuState();
}

// This is the frontend for the app bar displaying in each main pages
class _AppBarPopupMenuState extends State<AppBarPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.menu_sharp, size: 30, color: purple),
      onSelected: (item) => onSelected(context, item),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: ListTile(
            iconColor: purple,
            textColor: purple,
            leading: const Icon(Icons.edit_sharp),
            title: const Text(
              'Reset Password',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: ListTile(
            iconColor: purple,
            textColor: purple,
            leading: const Icon(Icons.logout_sharp),
            title: const Text('Logout', style: TextStyle(fontSize: 16)),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 2,
          child: ListTile(
            iconColor: purple,
            textColor: purple,
            leading: const Icon(Icons.delete_outline_outlined),
            title: const Text('Delete Account', style: TextStyle(fontSize: 16)),
          ),
        )
      ],
    );
  }
}

onSelected(BuildContext context, int item) {
//delete function
  showDelete() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: TextStyle(color: purple),
          ),
          content: Container(
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You are going to delete your diary+ account. Confirm you delete.',
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  String email = user?.email ?? 'string';
                  FirestoreService firestoreService = FirestoreService();
                  if (user?.email != null) {
                    await firestoreService.deleteUser(email);
                    await firestoreService.deleteAllDay(email);
                    await firestoreService.deleteAllTips(email);
                  }
                  await user?.delete();
                  final snackBar = SnackBar(
                    content: Text(
                      'Successful: You have deleted your account.',
                      style: TextStyle(color: black),
                    ),
                    backgroundColor: btnPurple,
                    duration: const Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Future.delayed(const Duration(seconds: 3), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OnboardScreen(),
                      ),
                    );
                  });
                  // Show success message or navigate to login screen
                  Navigator.pop(context);
                } catch (e) {
                  // Show error message
                  Navigator.pop(context);
                  const snackBar = SnackBar(
                    content: Text(
                        'Error: Your device has poor internet connction. Try with good connection'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text('Yes, delete my account'),
            ),
          ],
        );
      },
    );
  }

  showLogOut() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: TextStyle(color: purple),
          ),
          content: Container(
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'You are going to logout from your diary+ account. Confirm you logout.',
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (
                        context,
                      ) =>
                              const OnboardScreen()));
                } catch (e) {
                  // Show error message
                  Navigator.pop(context);
                  const snackBar = SnackBar(
                    content: Text(
                        'Error: Your device has poor internet connction. Try with good connection'),
                    duration: Duration(seconds: 3),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: const Text('Yes, logout'),
            ),
          ],
        );
      },
    );
  }

// tasks for each items in app bar
  switch (item) {
    case 0:
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ResetPassword()),
      );
      break;
    case 1:
      showLogOut();
      break;
    case 2:
      showDelete();
      break;
  }
}
