
import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/UserDto.dart';
import 'package:mobile_assignment/Pages/Profile/other/bookmark_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/editProfile_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/newdevice_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/password_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/usedTicket_page.dart';
import 'package:mobile_assignment/Pages/landingpage.dart';
import 'package:mobile_assignment/services/API/UserApi.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;
  Userdto? userdto;
  // Initialize variables
  bool? isOrganizer = false;
  bool _isLoading = true;
  String userName = "Yang Jungwon";
  String userEmail = "jungwon@gmail.com";
  String userPhone = "+855 123 456 789";
  String userImage = "";
  String userLocation = "Cambodia, Phnom Penh";
  String userJoinedDate = "18-June-2023";

  Userapi userapi = Userapi();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Add this method to load user data
  void _loadUserData() async {
    try {
      // Load organizer status
      var organizerResult = await usersharedpreferences.getUserOrganizer();

      // Load user email and name
      String? email = await usersharedpreferences.getUserEmail();
      String? name = await usersharedpreferences.getUserName();
      var userData = await userapi.getUserByEmail(email: email!);
      if (mounted) {
        setState(() {
          isOrganizer = organizerResult ?? false;
          userEmail = email;
          userName = name ?? "Yang Jungwon";
          userImage = userData!.profilePicture ?? "";
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
                    Image.asset('assets/img/other/english.png', width: 20),
                    SizedBox(width: 20),
                    Text('English', style: AppComponent.labelTextStyle),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
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
                onPressed: () {
                  Navigator.pop(context);
                },
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

  Future<void> _logout() async {
    await usersharedpreferences.clearUserData();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Landingpage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile Page",
            style: AppComponent.labelStyle.copyWith(fontSize: 25),
          ),
          backgroundColor: AdvertiseColor.backgroundColor,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: AppComponent.labelStyle.copyWith(fontSize: 25),
        ),
        backgroundColor: AdvertiseColor.backgroundColor,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.settings_outlined,
              color: AdvertiseColor.textColor,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditprofilePage()),
                ).then((value) {
                  _loadUserData();
                });
              } else if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: AdvertiseColor.primaryColor),
                    SizedBox(width: 8),
                    Text('Edit Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
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
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                ),
                width: double.infinity,
                height: isOrganizer == true ? 310 : 130,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                            child: Image.network(
                              '${headUrl}lib/img/user/$userImage',
                              fit: BoxFit.cover,
                              height: 95,
                              width: 95,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    "assets/img/other/errorImage.png",
                                    height: 95,
                                    width: 95,
                                    fit: BoxFit.cover,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userName, style: AppComponent.labelStyle),
                              const SizedBox(height: 10),
                              Text(
                                userEmail,
                                style: AppComponent.sublabelStyle.copyWith(
                                  color: AdvertiseColor.textColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isOrganizer == true)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.phone_outlined, size: 26),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Phone",
                                    style: AppComponent.sublabelStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AdvertiseColor.textColor,
                                    ),
                                  ),
                                  Text(
                                    userPhone,
                                    style: AppComponent.sublabelStyle.copyWith(
                                      color: AdvertiseColor.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.pin_drop_outlined, size: 26),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Location",
                                    style: AppComponent.sublabelStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AdvertiseColor.textColor,
                                    ),
                                  ),
                                  Text(
                                    userLocation,
                                    style: AppComponent.sublabelStyle.copyWith(
                                      color: AdvertiseColor.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month, size: 26),
                              const SizedBox(width: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Joined",
                                    style: AppComponent.sublabelStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AdvertiseColor.textColor,
                                    ),
                                  ),
                                  Text(
                                    userJoinedDate,
                                    style: AppComponent.sublabelStyle.copyWith(
                                      color: AdvertiseColor.textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Device Section
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                ),
                width: double.infinity,
                height: 125,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Devices',
                          style: AppComponent.detailTextStyle.copyWith(
                            fontSize: screenwidth <= 402 ? 12 : 16,
                          ),
                        ),
                        const Spacer(),
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
                              fontSize: screenwidth <= 402 ? 12 : 16,
                              color: AdvertiseColor.blueColor,
                              decoration: TextDecoration.underline,
                              decorationColor: AdvertiseColor.blueColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/img/sample/qr.png',
                          fit: BoxFit.fitHeight,
                          height: 70,
                          width: 70,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Added on 13/June/2025',
                                style: AppComponent.labelStyle.copyWith(
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                'RUPP',
                                style: AppComponent.detailTextStyle.copyWith(
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                'C5E9',
                                style: AppComponent.detailTextStyle.copyWith(
                                  fontSize: 10,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenwidth <= 402 ? 6 : 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AdvertiseColor.textColor
                                          .withOpacity(0.5),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Text(
                                    'Block',
                                    style: TextStyle(
                                      fontSize: screenwidth <= 402 ? 12 : 14,
                                      fontFamily: 'KantumruyPro',
                                      color: AdvertiseColor.textColor
                                          .withOpacity(0.5),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenwidth <= 402 ? 6 : 8,
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
                                      fontSize: screenwidth <= 402 ? 12 : 14,
                                      fontFamily: 'KantumruyPro',
                                      color: AdvertiseColor.blueColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Used Ticket
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsedticketPage()),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
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
                      const SizedBox(width: 5),
                      Text('Used Ticket', style: AppComponent.labelTextStyle),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),

              // Notifications
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
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
                    const SizedBox(width: 5),
                    Text('Notification', style: AppComponent.labelTextStyle),
                    const Spacer(),
                    Switch(
                      value: _notificationsEnabled,
                      onChanged: (bool value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
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

              // Languages
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _showLanguageBottomSheet(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
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
                      const SizedBox(width: 5),
                      Text('Language', style: AppComponent.labelTextStyle),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),

              // Password
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordPage()),
                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
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
                      const SizedBox(width: 5),
                      Text('Password', style: AppComponent.labelTextStyle),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),

              // Appearance
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _showAppearanceBottomSheet(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
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
                      const SizedBox(width: 5),
                      Text('Appearance', style: AppComponent.labelTextStyle),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AdvertiseColor.textColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),

              // Bookmark (Only for non-organizers)
              const SizedBox(height: 10),
              if (isOrganizer == false)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookmarkPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
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
                        const SizedBox(width: 5),
                        Text('Bookmark', style: AppComponent.labelTextStyle),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: AdvertiseColor.textColor.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
