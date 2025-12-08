import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Auth/login_page.dart';

class ResetsuccessPage extends StatefulWidget {
  const ResetsuccessPage({super.key});

  @override
  State<ResetsuccessPage> createState() => _ResetsuccessPageState();
}

class _ResetsuccessPageState extends State<ResetsuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AdvertiseColor.backgroundColor,
        elevation: 0,
        title: Text("Reset Success", style: AppComponent.appBarTitleTextStyle),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AdvertiseColor.textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AdvertiseColor.backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Image.asset('assets/img/other/resetsuccess.png'),
              SizedBox(height: 20),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdvertiseColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    "Go to Login", // Fixed button text
                    style: AppComponent.elevatedButtonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
