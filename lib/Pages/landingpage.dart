import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Auth/login_page.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/other/login_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            // This spacer pushes everything to the bottom
            Spacer(),

            // Logo above the button
            Image.asset('assets/img/other/logo.png'),

            // Another spacer for spacing between logo and button
            Spacer(),

            // Button row aligned to bottom right
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Spacer(), // Pushes the button to the right
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
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
                    child: Text(
                      'Log In',
                      style: AppComponent.elevatedButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
