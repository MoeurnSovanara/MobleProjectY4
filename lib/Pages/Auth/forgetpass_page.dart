import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Auth/signup_page.dart';
import 'package:mobile_assignment/Pages/Auth/verifyOTP_page.dart';
import 'package:mobile_assignment/services/UserApi.dart';
import 'package:mobile_assignment/services/sentEmailServices.dart';

class ForgetpassPage extends StatefulWidget {
  const ForgetpassPage({super.key});

  @override
  State<ForgetpassPage> createState() => _ForgetpassPageState();
}

class _ForgetpassPageState extends State<ForgetpassPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  Userapi userapi = Userapi();
  Sentemailservices sentemailservices = Sentemailservices();

  void sentEmail() async {
    var existEmail = await userapi.getUserByEmail(email: _emailController.text);
    if (existEmail != null) {
      setState(() {
        _isLoading = true;
      });
      Random random = Random();
      String verifyCode = (random.nextInt(900000) + 100000).toString();
      await sentemailservices.sendEmail(
        email: _emailController.text,
        subject: "Reset Password OTP",
        code: verifyCode,
      );
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyotpPage(
            email: _emailController.text,
            otp: verifyCode,
            password: "",
            statusCase: "reset",
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AdvertiseColor.dangerColor,
          content: Text(
            "Email not found",
            style: TextStyle(color: AdvertiseColor.backgroundColor),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AdvertiseColor.backgroundColor,
        elevation: 0,
        title: Text(
          "Forgot Password",
          style: AppComponent.appBarTitleTextStyle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AdvertiseColor.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AdvertiseColor.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/img/other/work.png",
                            width: double.infinity,
                            height: 300,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),

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
                        hintText: "Reset Password",
                        hintStyle: AppComponent.hintTextStyle,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Reset Password Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _isLoading ? null : sentEmail(),
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
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AdvertiseColor.backgroundColor,
                                  ),
                                ),
                              )
                            : Text(
                                "Reset Password", // Fixed button text
                                style: AppComponent.elevatedButtonTextStyle,
                              ),
                      ),
                    ),
                    SizedBox(height: 50),

                    // Sign Up Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Do you want to back? ",
                          style: AppComponent.labelTextStyle,
                        ),
                        GestureDetector(
                          onTap: _isLoading ? null : _navigateToSignup,
                          child: Text(
                            "Log In",
                            style: AppComponent.primaryThemeTextStyle,
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

  void _navigateToSignup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignupPage()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
