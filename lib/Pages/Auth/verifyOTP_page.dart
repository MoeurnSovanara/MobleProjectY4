// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Auth/createprofile_page.dart';
import 'package:mobile_assignment/Pages/Auth/newpass_page.dart';
import 'package:mobile_assignment/Pages/Navigator/changePage.dart';
import 'package:mobile_assignment/services/API/UserApi.dart';
import 'package:mobile_assignment/services/sentEmailServices.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class VerifyotpPage extends StatefulWidget {
  final String email;
  String otp;
  final String password;
  final String statusCase;
  VerifyotpPage({
    super.key,
    required this.email,
    required this.otp,
    required this.password,
    required this.statusCase,
  });

  @override
  State<VerifyotpPage> createState() => _VerifyotpPageState();
}

class _VerifyotpPageState extends State<VerifyotpPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _codeControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  Userapi userapi = Userapi();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  Sentemailservices sentemailservices = Sentemailservices();

  // Add timer variables
  int _resendCooldown = 60;
  bool _canResend = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Set up focus nodes to move to next field automatically
    for (int i = 0; i < _focusNodes.length; i++) {
      _focusNodes[i].addListener(() {
        if (!_focusNodes[i].hasFocus &&
            _codeControllers[i].text.isNotEmpty &&
            i < _focusNodes.length - 1) {
          FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
        }
      });
    }
    // Start cooldown timer
    startCooldown();
  }

  void startCooldown() {
    _canResend = false;
    _timer?.cancel(); // Cancel any existing timer first
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCooldown > 0) {
          _resendCooldown--;
        } else {
          _canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    // Dispose all controllers and focus nodes to prevent memory leaks
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel(); // Use ?. to safely call cancel
    _timer = null; // Optional: set to null
    super.dispose();
  }

  bool _isLoading = false;

  // Method to verify OTP
  void _verifyOtp() async {
    if (_isLoading) return;

    // Get the complete OTP code
    String otpCode = _getOtpCode();

    // Validate if all fields are filled
    if (otpCode.length != 6) {
      _showErrorDialog("Please enter the complete 6-digit OTP code.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      switch (widget.statusCase) {
        case "signup":
          // For example:
          // bool isVerified = await AuthService.verifyOtp(widget.email, otpCode);
          if (otpCode != widget.otp) {
            await Future.delayed(Duration(seconds: 2));
            _showErrorDialog("Invalid OTP. Please try again.");
            return;
          } else {
            // Simulate successful verification for demo purposes
            await Future.delayed(Duration(seconds: 2));
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateprofilePage(
                  email: widget.email,
                  password: widget.password,
                ),
              ),
            );
          }
        case "reset":
          if (otpCode != widget.otp) {
            await Future.delayed(Duration(seconds: 2));
            _showErrorDialog("Invalid OTP. Please try again.");
            return;
          } else {
            // Simulate successful verification for demo purposes
            await Future.delayed(Duration(seconds: 2));
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewpassPage(email: widget.email),
              ),
            );
          }
        case "login":
          if (otpCode != widget.otp) {
            await Future.delayed(Duration(seconds: 2));
            _showErrorDialog("Invalid OTP. Please try again.");
            return;
          } else {
            // Simulate successful verification for demo purposes
            await Future.delayed(Duration(seconds: 2));
            var userData = await userapi.getUserByEmail(email: widget.email);
            if (userData != null) {
              await usersharedpreferences.saveUserEmail(widget.email);
              await usersharedpreferences.saveUserOrganizer(userData.organizer);
              await usersharedpreferences.saveUserName(userData.fullname);
              await usersharedpreferences.saveUserId(userData.id);
            }
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Changepage()),
            );
            // Navigate to home page or dashboard after successful login
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          }
          break;
      }
    } catch (e) {
      _showErrorDialog("An error occurred. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resendOtp() async {
    if (_isLoading || !_canResend) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Generate a new 6-digit OTP
      Random random = Random();
      String newOtp = (random.nextInt(900000) + 100000).toString();

      // Determine subject based on statusCase
      String subject = "";
      switch (widget.statusCase) {
        case "signup":
          subject = "Verify Your Email for Sign Up";
          break;
        case "reset":
          subject = "Reset Your Password OTP";
          break;
        case "login":
          subject = "Login Verification OTP";
          break;
        default:
          subject = "Your OTP Code";
      }

      // Call your resend OTP API here
      var response = await sentemailservices.sendEmail(
        email: widget.email,
        subject: subject,
        code: newOtp,
      );

      if (response.statusCode == 200) {
        setState(() {
          // Update the OTP in the widget to the new OTP
          widget.otp = newOtp;
          // Reset cooldown
          _resendCooldown = 60;
          _canResend = false;
        });

        // Clear all OTP fields
        for (var controller in _codeControllers) {
          controller.clear();
        }

        // Start cooldown timer
        startCooldown();

        // Focus on first field
        FocusScope.of(context).requestFocus(_focusNodes[0]);

        // Handle successful resend (e.g., show a success message)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("OTP has been resent to your email."),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Handle failure (e.g., show an error message)
        _showErrorDialog("Failed to resend OTP. Please try again.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getOtpCode() {
    return _codeControllers.map((controller) => controller.text).join();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error", style: TextStyle(color: Colors.red)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "OK",
                style: TextStyle(color: AdvertiseColor.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AdvertiseColor.backgroundColor,
        elevation: 0,
        title: Text("Verify OTP", style: AppComponent.appBarTitleTextStyle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AdvertiseColor.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AdvertiseColor.backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60),

              // Header Section
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/img/Icon/Mail Icon.png",
                      width: 120,
                      height: 120,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Check your Email",
                      style: TextStyle(
                        fontFamily: 'KantumruyPro',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AdvertiseColor.textColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "We sent the verification code to:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'KantumruyPro',
                        fontSize: 14,
                        color: AdvertiseColor.textColor.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'KantumruyPro',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AdvertiseColor.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // OTP Input Section
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 45,
                          height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _codeControllers[index].text.isNotEmpty
                                  ? AdvertiseColor
                                        .primaryColor // Color when field has content
                                  : Colors.grey.withOpacity(
                                      0.5,
                                    ), // Color when empty
                              width: 2,
                            ),
                            color: AdvertiseColor.inputFieldColor,
                          ),
                          child: TextFormField(
                            controller: _codeControllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AdvertiseColor.primaryColor,
                            ),
                            decoration: InputDecoration(
                              counterText: "",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                            ),
                            onChanged: (value) {
                              // This triggers a UI rebuild when text changes
                              setState(() {});

                              if (value.length == 1 && index < 5) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_focusNodes[index + 1]);
                              } else if (value.isEmpty && index > 0) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(_focusNodes[index - 1]);
                              }

                              // Auto-submit when all fields are filled
                              if (value.length == 1 && index == 5) {
                                String otp = _getOtpCode();
                                if (otp.length == 6) {
                                  _verifyOtp();
                                }
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // Verify OTP Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdvertiseColor.primaryColor,
                    foregroundColor: AdvertiseColor.backgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
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
                          "Verify OTP", // Fixed button text to match functionality
                          style: TextStyle(
                            fontFamily: 'KantumruyPro',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 30),

              // Resend OTP Section
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      _canResend
                          ? "Didn't receive the code? "
                          : "Resend OTP in $_resendCooldown seconds",
                      style: AppComponent.hintTextStyle,
                    ),
                  ),
                  GestureDetector(
                    onTap: (_isLoading || !_canResend) ? null : _resendOtp,
                    child: Center(
                      child: Text(
                        _canResend ? "Resend OTP" : "",
                        style: AppComponent.primaryThemeTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
