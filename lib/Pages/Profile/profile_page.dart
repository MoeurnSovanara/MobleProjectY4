import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Profile/other/bookmark_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/editProfile_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/newdevice_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/password_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/usedTicket_page.dart';
import 'package:mobile_assignment/Pages/landingpage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;

  File? _pickedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          width: double.infinity,
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Languages', style: AppComponent.boldTextStyle),
              SizedBox(height: 10),
              Text(
                'Please select a display language',
                style: AppComponent.labelTextStyle,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/img/other/khmer.png'),
                    SizedBox(width: 20),
                    Text('Khmer', style: AppComponent.labelTextStyle),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Image.asset('assets/img/other/english.png'),
                    SizedBox(width: 20),
                    Text('English', style: AppComponent.labelTextStyle),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {},
                style: AppComponent.elevatedButtonStyle,
                child: Text(
                  'Select',
                  style: AppComponent.elevatedButtonTextStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAppearanceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          width: double.infinity,
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Appearance', style: AppComponent.boldTextStyle),
              SizedBox(height: 10),
              Text(
                'Choose your preferred theme',
                style: AppComponent.labelTextStyle,
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.light_mode_outlined,
                      color: AdvertiseColor.primaryColor,
                    ),
                    SizedBox(width: 20),
                    Text('Light', style: AppComponent.labelTextStyle),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.dark_mode_outlined,
                      color: AdvertiseColor.primaryColor,
                    ),
                    SizedBox(width: 20),
                    Text('Dark', style: AppComponent.labelTextStyle),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {},
                style: AppComponent.elevatedButtonStyle,
                child: Text(
                  'Select',
                  style: AppComponent.elevatedButtonTextStyle,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: AppComponent.labelStyle.copyWith(fontSize: 25),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.settings_outlined),
            onSelected: (value) {
              if (value == 'edit') {
                // Navigate to Edit Profile
              } else if (value == 'logout') {
                // Handle logout
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditprofilePage()),
                ),
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: AdvertiseColor.primaryColor),
                    SizedBox(width: 8),
                    Text('Edit Profile'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Landingpage()),
                ),
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AdvertiseColor.dangerColor),
                    SizedBox(width: 8),
                    Text('Log out'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                ),
                width: double.infinity,
                height: 120,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AdvertiseColor.textColor,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: _pickedImage != null
                                ? Image.file(
                                    _pickedImage!,
                                    fit: BoxFit.cover,
                                    height: 95,
                                    width: 95,
                                  )
                                : Image.asset(
                                    'assets/img/other/avatar.png',
                                    fit: BoxFit.cover,
                                    height: 95,
                                    width: 95,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Yang Jungwon', style: AppComponent.labelStyle),
                        SizedBox(height: 10),
                        Text(
                          'jungwon@gmail.com',
                          style: AppComponent.sublabelStyle.copyWith(
                            color: AdvertiseColor.textColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              //Device
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                ),
                width: double.infinity,
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Devices',
                          style: AppComponent.detailTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewdevicePage(),
                            ),
                          ),
                          child: Text(
                            'ADD NEW DEVICES',
                            style: TextStyle(
                              fontFamily: 'KantumruyPro',
                              fontSize: 16,
                              color: AdvertiseColor.blueColor,
                              decoration: TextDecoration.underline,
                              decorationColor: AdvertiseColor.blueColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/img/sample/qr.png',
                          fit: BoxFit.fitHeight,
                          height: 70,
                          width: 70,
                        ),
                        SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Added on 13/June/2025',
                              style: AppComponent.labelStyle.copyWith(
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'RUPP',
                              style: AppComponent.detailTextStyle.copyWith(
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              'C5E9',
                              style: AppComponent.detailTextStyle.copyWith(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AdvertiseColor.textColor.withOpacity(
                                      0.5,
                                    ),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'Block',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'KantumruyPro',
                                    color: AdvertiseColor.textColor.withOpacity(
                                      0.5,
                                    ),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AdvertiseColor.blueColor,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  'Remove',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'KantumruyPro',
                                    color: AdvertiseColor.blueColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              //Used Ticket
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsedticketPage()),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                  ),
                  height: 70,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_copy_outlined,
                        color: AdvertiseColor.primaryColor,
                      ),
                      SizedBox(width: 5),
                      Text('Used Ticket', style: AppComponent.labelTextStyle),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),

              //Notifications
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                ),
                height: 70,
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: AdvertiseColor.primaryColor,
                    ),
                    SizedBox(width: 5),
                    Text('Notification', style: AppComponent.labelTextStyle),
                    Spacer(),
                    Switch(
                      value: _notificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                        // Save notification preference
                      },
                      activeColor: AdvertiseColor.primaryColor,
                      activeTrackColor: AdvertiseColor.primaryColor.withOpacity(
                        0.5,
                      ),
                      inactiveThumbColor: AdvertiseColor.textColor.withOpacity(
                        0.5,
                      ),
                      inactiveTrackColor: AdvertiseColor.backgroundColor,
                    ),
                  ],
                ),
              ),

              //Languages
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _showLanguageBottomSheet(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                  ),
                  height: 70,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(Icons.language, color: AdvertiseColor.primaryColor),
                      SizedBox(width: 5),
                      Text('Language', style: AppComponent.labelTextStyle),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),

              //Password
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordPage()),
                ),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                  ),
                  height: 70,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: AdvertiseColor.primaryColor,
                      ),
                      SizedBox(width: 5),
                      Text('Password', style: AppComponent.labelTextStyle),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),

              //appearance
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _showAppearanceBottomSheet(context);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                  ),
                  height: 70,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(
                        Icons.dark_mode_outlined,
                        color: AdvertiseColor.primaryColor,
                      ),
                      SizedBox(width: 5),
                      Text('Appearance', style: AppComponent.labelTextStyle),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
              // Bookmark
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookmarkPage()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                  ),
                  height: 70,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(
                        Icons.bookmark_outline,
                        color: AdvertiseColor.primaryColor,
                      ),
                      SizedBox(width: 5),
                      Text('Bookmark', style: AppComponent.labelTextStyle),
                      Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                    ],
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
