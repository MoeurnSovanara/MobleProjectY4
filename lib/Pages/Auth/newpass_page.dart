import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/UserDto.dart';
import 'package:mobile_assignment/Pages/Auth/resetsuccess_page.dart';
import 'package:mobile_assignment/services/API/UserApi.dart';

class NewpassPage extends StatefulWidget {
  final String email;
  const NewpassPage({super.key, required this.email});

  @override
  State<NewpassPage> createState() => _NewpassPageState();
}

class _NewpassPageState extends State<NewpassPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  final Userapi _userApi = Userapi();

  void _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      var existingUser = await _userApi.getUserByEmail(email: widget.email);

      if (existingUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AdvertiseColor.dangerColor,
            content: Text(
              "User not found",
              style: TextStyle(color: AdvertiseColor.backgroundColor),
            ),
          ),
        );
        return;
      }

      Userdto updatedUser = Userdto(
        id: existingUser.id,
        fullname: existingUser.fullname,
        email: widget.email,
        gender: existingUser.gender,
        password: _newPasswordController.text.trim(),
        phoneNumber: existingUser.phoneNumber, // Fixed: was using password
        dateOfBirth: existingUser.dateOfBirth,
        organizer: existingUser.organizer,
        verified: existingUser.verified,
        createdAt: existingUser.createdAt,
        google: existingUser.google,
      );

      var response = await _userApi.updateUser(user: updatedUser);

      if (response != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResetsuccessPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AdvertiseColor.dangerColor,
            content: Text(
              "Failed to reset password",
              style: TextStyle(color: AdvertiseColor.backgroundColor),
            ),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AdvertiseColor.dangerColor,
          content: Text(
            "An error occurred: $error",
            style: TextStyle(color: AdvertiseColor.backgroundColor),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AdvertiseColor.backgroundColor,
        elevation: 0,
        title: Text("Reset Password", style: AppComponent.appBarTitleTextStyle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AdvertiseColor.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AdvertiseColor.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                // Instruction text
                Text(
                  "Create a new password for your account",
                  style: TextStyle(
                    color: AdvertiseColor.textColor.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),

                // New Password Field
                Text("New Password", style: AppComponent.labelTextStyle),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscurePassword,
                  validator: _validateNewPassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    filled: true,
                    fillColor: AdvertiseColor.inputFieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Enter your new password",
                    hintStyle: AppComponent.hintTextStyle,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Confirm Password Field
                Text(
                  "Confirm New Password",
                  style: AppComponent.labelTextStyle,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  validator: _validateConfirmPassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    filled: true,
                    fillColor: AdvertiseColor.inputFieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Confirm your new password",
                    hintStyle: AppComponent.hintTextStyle,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Password requirements
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password must contain:",
                        style: TextStyle(
                          color: AdvertiseColor.textColor.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "• At least 6 characters",
                        style: TextStyle(
                          color: AdvertiseColor.textColor.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Reset Password Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdvertiseColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AdvertiseColor.backgroundColor,
                              ),
                            ),
                          )
                        : Text(
                            "Reset Password",
                            style: AppComponent.elevatedButtonTextStyle,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
