import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'ResetPasswordScreen';

  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  String newpasswordErrorText = ''; // State variable for phone number error text
  String newconfirmpasswordErrorText = ''; // State variable for phone number error text
  String oldpasswordErrorText = ''; // State variable for phone number error text

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _currentUserEmail;

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail();
  }

  Future<void> _getCurrentUserEmail() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentUserEmail = user.email!;
      });
    }
  }

  // void _resetPassword() async {
  //   String oldPassword = _oldPasswordController.text.trim();
  //   String newPassword = _newPasswordController.text.trim();
  //   String confirmNewPassword = _confirmNewPasswordController.text.trim();
  //
  //   try {
  //     User? user = _auth.currentUser;
  //     if (user != null) {
  //       // Re-authenticate the user with their current email and password
  //       AuthCredential credential = EmailAuthProvider.credential(email: _currentUserEmail, password: oldPassword);
  //       await user.reauthenticateWithCredential(credential);
  //
  //       // Reset error texts
  //       setState(() {
  //         oldpasswordErrorText = '';
  //         newpasswordErrorText = '';
  //         newconfirmpasswordErrorText = '';
  //       });
  //
  //       // Validate new password
  //       if (newPassword.isEmpty || newPassword.length < 8 || !newPassword.contains(RegExp(r'[A-Z]'))) {
  //         setState(() {
  //           if (newPassword.isEmpty) {
  //             newpasswordErrorText = 'Password cannot be empty';
  //           } else if (newPassword.length < 8) {
  //             newpasswordErrorText = 'Password must be at least 8 characters';
  //           } else if (!newPassword.contains(RegExp(r'[A-Z]'))) {
  //             newpasswordErrorText = 'Password must contain at least 1 uppercase letter';
  //           }
  //         });
  //       }
  //
  //       // Validate confirm new password
  //       if (confirmNewPassword.isEmpty || confirmNewPassword != newPassword) {
  //         setState(() {
  //           if (confirmNewPassword.isEmpty) {
  //             newconfirmpasswordErrorText = 'Confirm password cannot be empty';
  //           } else {
  //             newconfirmpasswordErrorText = 'Passwords do not match';
  //           }
  //         });
  //       }
  //
  //       if (oldpasswordErrorText.isEmpty && newpasswordErrorText.isEmpty && newconfirmpasswordErrorText.isEmpty) {
  //         // Update password in authentication
  //         await user.updatePassword(newPassword);
  //
  //         // Update password in Firestore database
  //         await _firestore.collection('TUGOPARTNERS').doc(user.uid).update({'password': newPassword});
  //
  //         // Password updated successfully
  //         print('Password updated successfully from authentication.');
  //
  //         // Show success message or navigate to a new screen
  //       }
  //     } else {
  //       // User is not signed in
  //       // Show error message or handle as needed
  //     }
  //   } catch (e) {
  //     // Error occurred during password reset
  //     // Show error message or alert dialog
  //     if (e is FirebaseAuthException) {
  //       setState(() {
  //         if (e.code == 'wrong-password') {
  //           oldpasswordErrorText = 'Old password is incorrect';
  //         } else {
  //           oldpasswordErrorText = 'Error resetting password';
  //         }
  //       });
  //     }
  //     print('Error resetting password: $e');
  //   }
  // }

  void _resetPassword() async {
    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String newconfirmNewPassword = _confirmNewPasswordController.text.trim();



    try {

      User? user = _auth.currentUser;
      if (newPassword.isEmpty) {
        setState(() {
          newpasswordErrorText = 'Password cannot be empty';
        });
      } else if (newPassword.length < 8 || !newPassword.contains(RegExp(r'[A-Z]'))) {
        setState(() {
          if (newPassword.length < 8) {
            newpasswordErrorText = 'Password must be at least 8 characters';
          }
          if (!newPassword.contains(RegExp(r'[A-Z]'))) {
            newpasswordErrorText = 'Password must contain at least 1 uppercase letter';
          }
        });
      }

      if (newconfirmNewPassword.isEmpty) {
        setState(() {
          newconfirmpasswordErrorText = 'Confirm password cannot be empty';
        });
      } else if (newconfirmNewPassword.length < 8 || !newconfirmNewPassword.contains(RegExp(r'[A-Z]'))) {
        setState(() {
          if (newconfirmNewPassword.length < 8) {
            newconfirmpasswordErrorText = 'Password must be at least 8 characters';
          }
          if (!newconfirmNewPassword.contains(RegExp(r'[A-Z]'))) {
            newconfirmpasswordErrorText = 'Password must contain at least 1 uppercase letter';
          }
        });
      }
      if (oldPassword.isEmpty) {
        setState(() {
          oldpasswordErrorText = 'Old password cannot be empty';
        });
      } else {
        try {
          // Re-authenticate the user with their current email and password
          AuthCredential credential = EmailAuthProvider.credential(email: _currentUserEmail, password: oldPassword);
          await user!.reauthenticateWithCredential(credential);

          // Clear old password error message if re-authentication succeeds
          setState(() {
            oldpasswordErrorText = '';
          });
        } catch (reauthError) {
          // Re-authentication failed, set error message for wrong password
          setState(() {
            oldpasswordErrorText = 'Incorrect old password';
          });
          return;
        }
      }
      if (newPassword != newconfirmNewPassword) {
        setState(() {
          newpasswordErrorText = 'Passwords do not match';
          newconfirmpasswordErrorText = 'Passwords do not match';

        });
      }

      if (newpasswordErrorText.isEmpty && oldpasswordErrorText.isEmpty &&
          newconfirmpasswordErrorText.isEmpty &&user != null) {
        // Re-authenticate the user with their current email and password
        AuthCredential credential = EmailAuthProvider.credential(email: _currentUserEmail, password: oldPassword);
        await user.reauthenticateWithCredential(credential);

        // Update password in authentication
        await user.updatePassword(newPassword);

        // Update password in Firestore database
        await _firestore.collection('TUGOPARTNERS').doc(user.uid).update({'password': newPassword});

        // Password updated successfully
        print('Password updated successfully from authentication.');

        // Show success message or navigate to a new screen
      } else {
        // User is not signed in
        // Show error message or handle as needed
      }
    } catch (e) {
      // Error occurred during password reset
      // Show error message or alert dialog
      print('Error resetting password: $e');
    }
  }
  bool _obscureText = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TextFormField(
              //   initialValue: _currentUserEmail,
              //   enabled: false,
              //   decoration: InputDecoration(labelText: 'Email'),
              // ),
              // TextFormField(
              //   controller: _oldPasswordController,
              //   obscureText: true,
              //   decoration: InputDecoration(labelText: 'Old Password'),
              // ),
              // TextFormField(
              //   controller: _newPasswordController,
              //   obscureText: true,
              //   decoration: InputDecoration(labelText: 'New Password'),
              // ),
              // TextFormField(
              //   controller: _confirmNewPasswordController,
              //   obscureText: true,
              //   decoration: InputDecoration(labelText: 'Confirm New Password'),
              // ),
              // SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _resetPassword,
              //   child: Text('Reset Password'),
              // ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'E-mail',
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0XFF808083),
                ),
              ),
              TextField(
                readOnly: true, // Set readOnly to true to make the TextField non-editable
                style: const TextStyle(fontSize: 18, fontFamily: 'Archivoblack'),
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(fontFamily: 'poppins', color: Color(0XFFBFBFBF), fontSize: 13),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.white),
                  ),
                  // suffixIcon: IconButton(
                  //   onPressed: () {
                  //     emailController.clear();
                  //   },
                  //   icon: const Icon(
                  //     Icons.cancel,
                  //     color: Color(0XFFBFBFBF),
                  //   ),
                  // ),
                ),
                // Set the initial value to widget.email
                // This value won't be editable due to readOnly property
                // You can customize the style further if needed
                controller: TextEditingController(text:_currentUserEmail),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Old Password',
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 16,
                  color: Color(0XFF808083),
                ),
              ),
              TextField(
                controller: _oldPasswordController,
                decoration: InputDecoration(
                  hintText: 'Enter your old password',
                  hintStyle: const TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0XFFBFBFBF),
                    fontSize: 13,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0XFFBFBFBF),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  errorText: oldpasswordErrorText.isNotEmpty ? oldpasswordErrorText : null,
          
                ),
                obscureText: _obscureText,
                onChanged: (value) {
                  setState(() {
                    // Reset error text when user edits the email field
                    oldpasswordErrorText = '';
                  });
                },
          
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'New Password',
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 16,
                  color: Color(0XFF808083),
                ),
              ),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  hintText: 'Enter your new password',
                  hintStyle: const TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0XFFBFBFBF),
                    fontSize: 13,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0XFFBFBFBF),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  errorText: newpasswordErrorText.isNotEmpty ? newpasswordErrorText : null,
          
                ),
                obscureText: _obscureText,
                onChanged: (value) {
                  setState(() {
                    // Reset error text when user edits the email field
                    newpasswordErrorText = '';
                  });
                },
          
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'Confirm New Password',
                style: TextStyle(
                  fontFamily: 'poppins',
                  fontSize: 16,
                  color: Color(0XFF808083),
                ),
              ),
              TextField(
                controller: _confirmNewPasswordController,
                decoration: InputDecoration(
                  hintText: 'Enter your New password',
                  hintStyle: const TextStyle(
                    fontFamily: 'poppins',
                    color: Color(0XFFBFBFBF),
                    fontSize: 13,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0XFFBFBFBF),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  errorText: newconfirmpasswordErrorText.isNotEmpty ? newconfirmpasswordErrorText : null,
          
                ),
                obscureText: _obscureText,
                onChanged: (value) {
                  setState(() {
                    // Reset error text when user edits the email field
                    newconfirmpasswordErrorText = '';
                  });
                },
          
              ),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: SizedBox(
                  width: 335,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF007AFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17),
                      ),
                    ),
                      onPressed: _resetPassword,
          
                    child: const Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'poppins',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
