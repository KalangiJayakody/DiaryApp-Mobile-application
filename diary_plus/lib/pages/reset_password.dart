import 'package:diary_plus/components/navigation_bar.dart';
import 'package:diary_plus/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final newPassswordController = TextEditingController();
  final reNewPasswordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

// reset password function
  resetPassword() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    try {
      final email = FirebaseAuth.instance.currentUser?.email ?? 'No Email';

      if (auth.currentUser?.email != null) {
        await auth.sendPasswordResetEmail(email: email);
      }

      // Show success message or navigate to login screen
      Navigator.pop(context);
      final snackBar = SnackBar(
        content: Text(
          'Successful: Please check your email to reset password',
          style: TextStyle(color: black),
        ),
        backgroundColor: btnPurple,
        duration: const Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Future.delayed(const Duration(seconds: 6), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NavBar(),
          ),
        );
      });
    } catch (e) {
      // Show error message
      Navigator.pop(context);
      const snackBar = SnackBar(
        content: Text(
            'Error: Your device has poor internet connction. Try with good connection'),
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  // Building frontend
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('You can reset you password here.'),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'To change your password you have to click the below button. Then you will receive an email  to the email address you have provided when regitering to the app.',
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: 0.6,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnPurple, // Background color
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      resetPassword();
                    },
                    child: Text("Confirm Reset Password",
                        style: TextStyle(
                            color: black, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
