import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
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
        padding: EdgeInsets.all(10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('assets/img/other/lock.png')),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Input your old password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50),
                    Text('New Password', style: AppComponent.labelTextStyle),
                    TextFormField(
                      controller: _newPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Input your old password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Confirm New Password',
                      style: AppComponent.labelTextStyle,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Input your old password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
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
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AdvertiseColor.primaryColor,
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 40,
                            ),
                            side: BorderSide(
                              color: AdvertiseColor.primaryColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
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
