import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Auth/login_page.dart';
import 'package:mobile_assignment/Pages/Auth/verifyOTP_page.dart';
import 'package:mobile_assignment/services/API/UserApi.dart';
import 'package:mobile_assignment/services/sentEmailServices.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false; // Add loading state variable
  Sentemailservices sentemailservices = Sentemailservices();
  Userapi userapi = Userapi();

  void singUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        var data = await userapi.getUserByEmail(email: _emailController.text);
        if (data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Email already exists. Please use a different email.',
              ),
              backgroundColor: AdvertiseColor.dangerColor,
            ),
          );
          return; // Stop further execution
        }
        Random random = Random();
        int otp = random.nextInt(900000) + 100000; // Generate a 6-digit OTP
        var response = await sentemailservices.sendEmail(
          email: _emailController.text,
          subject: "Verify Account",
          code: otp.toString(),
        );

        if (response.statusCode == 200) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyotpPage(
                email: _emailController.text,
                otp: otp.toString(),
                password: _passwordController.text,
                statusCase: "signup",
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send OTP. Please try again.'),
              backgroundColor: AdvertiseColor.dangerColor,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: AdvertiseColor.dangerColor,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdvertiseColor.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50, left: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                    color: AdvertiseColor.primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create your account!",
                        style: TextStyle(
                          fontFamily: 'KantumruyPro',
                          fontSize: 16,
                          color: AdvertiseColor.backgroundColor,
                        ),
                      ),
                      Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: 'KantumruyPro',
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: AdvertiseColor.backgroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Email Field
                    Text("Email", style: AppComponent.labelTextStyle),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        filled: true,
                        fillColor: AdvertiseColor.inputFieldColor.withOpacity(
                          0.9,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Enter your email",
                        hintStyle: AppComponent.hintTextStyle,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Password Field
                    Text("Password", style: AppComponent.labelTextStyle),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        if (!RegExp(
                          r'^(?=.*[a-zA-Z])(?=.*\d)',
                        ).hasMatch(value)) {
                          return 'Password must contain letters and numbers';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        filled: true,
                        fillColor: AdvertiseColor.inputFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Enter your password",
                        hintStyle: AppComponent.hintTextStyle,
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AdvertiseColor.textColor.withOpacity(0.3),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Confirm Password Field
                    Text(
                      "Confirm Password",
                      style: AppComponent.labelTextStyle,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                        filled: true,
                        fillColor: AdvertiseColor.inputFieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        hintText: "Confirm your password",
                        hintStyle: AppComponent.hintTextStyle,
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 12),
                          child: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AdvertiseColor.textColor.withOpacity(0.3),
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Sign Up Button with Loading State
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => singUp(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdvertiseColor.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: AdvertiseColor.backgroundColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Processing...",
                                    style: TextStyle(
                                      fontFamily: 'KantumruyPro',
                                      fontSize: 18,
                                      color: AdvertiseColor.backgroundColor,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontFamily: 'KantumruyPro',
                                  fontSize: 18,
                                  color: AdvertiseColor.backgroundColor,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Divider with "or"
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: AdvertiseColor.textColor.withOpacity(0.3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "or",
                            style: TextStyle(
                              color: AdvertiseColor.textColor.withOpacity(0.3),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: AdvertiseColor.textColor.withOpacity(0.3),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Google Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signUpWithGoogle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdvertiseColor.backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(
                              color: AdvertiseColor.textColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/img/Icon/iconsax-google.png",
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Continue with Google",
                              style: AppComponent.primaryThemeTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 50),

                    // Login Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: AppComponent.labelTextStyle,
                        ),
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                ),
                          child: Text(
                            "Log In",
                            style: _isLoading
                                ? AppComponent.labelTextStyle.copyWith(
                                    color: AdvertiseColor.textColor.withOpacity(
                                      0.5,
                                    ),
                                  )
                                : AppComponent.primaryThemeTextStyle,
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

  void _signUpWithGoogle() {
    // Google signup logic
    print('Signing up with Google...');

    // Implement Google authentication here
    // You can use packages like: google_sign_in, firebase_auth

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Google signup clicked!'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
