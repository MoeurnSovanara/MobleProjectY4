import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/UserDto.dart';
import 'package:mobile_assignment/services/API/UserApi.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  Userapi userapi = Userapi();
  bool isLoading = false;

  Future<void> _updatePassword() async {
    // Validate if new password and confirm password match
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showDialog(
        icon: Icons.warning,
        iconColor: Colors.yellow,
        message: 'New password and confirm password do not match!',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      var userEmail = await usersharedpreferences.getUserEmail();
      if (userEmail == null) {
        _showDialog(
          icon: Icons.error,
          iconColor: AdvertiseColor.dangerColor,
          message: 'User email not found!',
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      var userdto = await userapi.loginUser(
        email: userEmail,
        password: _oldPasswordController.text,
      );

      if (userdto != null) {
        var data = await userapi.updateUser(
          user: Userdto(
            id: userdto.id,
            fullname: userdto.fullname,
            email: userdto.email,
            gender: userdto.gender,
            password: _newPasswordController.text,
            phoneNumber: userdto.phoneNumber,
            dateOfBirth: userdto.dateOfBirth,
            organizer: userdto.organizer,
            verified: userdto.verified,
            createdAt: userdto.createdAt,
            google: userdto.google,
          ),
        );

        setState(() {
          isLoading = false;
        });

        if (data != null) {
          _showDialog(
            icon: Icons.verified,
            iconColor: Colors.green,
            message: 'Update Password Successfully!',
            isSuccess: true,
          );
        } else {
          _showDialog(
            icon: Icons.close_rounded,
            iconColor: AdvertiseColor.dangerColor,
            message: 'Failed to update!',
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        _showDialog(
          icon: Icons.warning,
          iconColor: Colors.yellow,
          message: 'Incorrect Old Password!',
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showDialog(
        icon: Icons.error,
        iconColor: AdvertiseColor.dangerColor,
        message: 'An error occurred. Please try again.',
      );
    }
  }

  void _showDialog({
    required IconData icon,
    required Color iconColor,
    required String message,
    bool isSuccess = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 50),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppComponent.boldTextStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          if (isSuccess)
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to previous page
              },
              child: const Text('OK'),
            )
          else
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: AppComponent.appBarTitleTextStyle.copyWith(
            color: AdvertiseColor.textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/img/other/lock.png')),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AdvertiseColor.textColor.withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Old Password', style: AppComponent.labelTextStyle),
                    TextFormField(
                      controller: _oldPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please input your old password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text('New Password', style: AppComponent.labelTextStyle),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please input your new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Confirm New Password',
                      style: AppComponent.labelTextStyle,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(
                              color: AdvertiseColor.primaryColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            'CANCEL',
                            style: AppComponent.elevatedButtonTextStyle
                                .copyWith(color: AdvertiseColor.primaryColor),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _updatePassword();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AdvertiseColor.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 40,
                            ),
                            side: BorderSide(
                              color: AdvertiseColor.primaryColor,
                              width: 1.5,
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'SAVE',
                                  style: AppComponent.elevatedButtonTextStyle,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
