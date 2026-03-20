import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/UserDto.dart';
import 'package:mobile_assignment/Pages/Profile/other/bookmark_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/editProfile_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/myTicket_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/newdevice_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/password_page.dart';
import 'package:mobile_assignment/Pages/Profile/other/usedTicket_page.dart';
import 'package:mobile_assignment/Pages/landingpage.dart';
import 'package:mobile_assignment/l10n/app_localizations.dart';
import 'package:mobile_assignment/providers/language_provider.dart';
import 'package:mobile_assignment/providers/theme_provider.dart';
import 'package:mobile_assignment/services/API/UserApi.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _notificationsEnabled = true;
  Userdto? userdto;
  bool? isOrganizer = false;
  bool _isLoading = true;
  String userName = "N/A";
  String userEmail = "N/A";
  String userPhone = "N/A";
  String userImage = "";

  Userapi userapi = Userapi();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      var organizerResult = await usersharedpreferences.getUserOrganizer();
      String? email = await usersharedpreferences.getUserEmail();
      String? name = await usersharedpreferences.getUserName();
      var userData = await userapi.getUserByEmail(email: email!);

      if (mounted) {
        setState(() {
          isOrganizer = organizerResult ?? false;
          userEmail = email;
          userName = name ?? "N/A";
          userPhone = userData!.phoneNumber.toString();
          userImage = userData.profilePicture ?? "";
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
    final t = AppLocalizations.of(context)!;
    final langProvider = Provider.of<LanguageProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AdvertiseColor
          .inputFieldColor, // Using inputFieldColor for background
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                t.pLanguage,
                style: AppComponent.boldTextStyle.copyWith(
                  color: AdvertiseColor.textColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                t.languageDetail,
                style: AppComponent.labelTextStyle.copyWith(
                  color: AdvertiseColor.textColor.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Khmer option
              _buildLanguageOption(
                context,
                flag: 'assets/img/other/khmer.png',
                name: t.khmerLabel,
                code: 'km',
                isSelected: langProvider.locale.languageCode == 'km',
              ),
              const SizedBox(height: 10),

              // English option
              _buildLanguageOption(
                context,
                flag: 'assets/img/other/english.png',
                name: t.englishLabel,
                code: 'en',
                isSelected: langProvider.locale.languageCode == 'en',
              ),
              const SizedBox(height: 30),

              // Select button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdvertiseColor.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    t.selectLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String flag,
    required String name,
    required String code,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () async {
        await Provider.of<LanguageProvider>(
          context,
          listen: false,
        ).changeLanguage(code);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AdvertiseColor.primaryColor
                : AdvertiseColor.textColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? AdvertiseColor.primaryColor.withOpacity(0.1)
              : AdvertiseColor.inputFieldColor,
        ),
        child: Row(
          children: [
            Image.asset(flag, width: 24, height: 24),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: AdvertiseColor.textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AdvertiseColor.primaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _showAppearanceBottomSheet(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AdvertiseColor.inputFieldColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    t.pAppearance,
                    style: AppComponent.boldTextStyle.copyWith(
                      color: AdvertiseColor.textColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.appearanceDetail,
                    style: AppComponent.labelTextStyle.copyWith(
                      color: AdvertiseColor.textColor.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Light theme option
                  GestureDetector(
                    onTap: () {
                      themeProvider.toggleTheme();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: !themeProvider.isDarkMode
                              ? AdvertiseColor.primaryColor
                              : AdvertiseColor.textColor.withOpacity(0.3),
                          width: !themeProvider.isDarkMode ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: !themeProvider.isDarkMode
                            ? AdvertiseColor.primaryColor.withOpacity(0.1)
                            : AdvertiseColor.inputFieldColor,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.light_mode_outlined,
                            color: !themeProvider.isDarkMode
                                ? AdvertiseColor.primaryColor
                                : AdvertiseColor.textColor.withOpacity(0.5),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            t.lightLable,
                            style: TextStyle(
                              color: AdvertiseColor.textColor,
                              fontWeight: !themeProvider.isDarkMode
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          const Spacer(),
                          if (!themeProvider.isDarkMode)
                            Icon(
                              Icons.check_circle,
                              color: AdvertiseColor.primaryColor,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Dark theme option
                  GestureDetector(
                    onTap: () {
                      themeProvider.toggleTheme();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: themeProvider.isDarkMode
                              ? AdvertiseColor.primaryColor
                              : AdvertiseColor.textColor.withOpacity(0.3),
                          width: themeProvider.isDarkMode ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: themeProvider.isDarkMode
                            ? AdvertiseColor.primaryColor.withOpacity(0.1)
                            : AdvertiseColor.inputFieldColor,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.dark_mode_outlined,
                            color: themeProvider.isDarkMode
                                ? AdvertiseColor.primaryColor
                                : AdvertiseColor.textColor.withOpacity(0.5),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            t.darkLabel,
                            style: TextStyle(
                              color: AdvertiseColor.textColor,
                              fontWeight: themeProvider.isDarkMode
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          const Spacer(),
                          if (themeProvider.isDarkMode)
                            Icon(
                              Icons.check_circle,
                              color: AdvertiseColor.primaryColor,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdvertiseColor.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        t.close,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
    final t = AppLocalizations.of(context)!;
    final langProvider = Provider.of<LanguageProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            t.profilePage,
            style: AppComponent.labelStyle.copyWith(
              fontSize: 25,
              color: AdvertiseColor.textColor,
            ),
          ),
          backgroundColor: AdvertiseColor.backgroundColor,
          elevation: 0,
        ),
        body: Center(
          child: CircularProgressIndicator(color: AdvertiseColor.primaryColor),
        ),
      );
    }

    var screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AdvertiseColor.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          t.profilePage,
          style: AppComponent.labelStyle.copyWith(
            fontSize: 25,
            color: AdvertiseColor.textColor,
          ),
        ),
        backgroundColor: AdvertiseColor.backgroundColor,
        elevation: 0,
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
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, color: AdvertiseColor.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      t.editProfile,
                      style: TextStyle(color: AdvertiseColor.textColor),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: AdvertiseColor.dangerColor),
                    const SizedBox(width: 8),
                    Text(
                      t.logout,
                      style: TextStyle(color: AdvertiseColor.textColor),
                    ),
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
          color: AdvertiseColor.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AdvertiseColor
                      .inputFieldColor, // Using inputFieldColor for card background
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.2),
                  ),
                ),
                width: double.infinity,
                height: isOrganizer == true ? 200 : 130,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AdvertiseColor.primaryColor,
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
                              Text(
                                userName,
                                style: AppComponent.labelStyle.copyWith(
                                  color: AdvertiseColor.textColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                userEmail,
                                style: AppComponent.sublabelStyle.copyWith(
                                  color: AdvertiseColor.textColor.withOpacity(
                                    0.7,
                                  ),
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
                              Icon(
                                Icons.phone_outlined,
                                size: 26,
                                color: AdvertiseColor.textColor,
                              ),
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
                                      color: AdvertiseColor.textColor
                                          .withOpacity(0.7),
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
                  color: AdvertiseColor.inputFieldColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.2),
                  ),
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          t.devices,
                          style: AppComponent.detailTextStyle.copyWith(
                            fontSize: screenwidth <= 402 ? 12 : 16,
                            color: AdvertiseColor.textColor,
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
                            t.newDevice,
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
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color:
                                Colors.white, // Keep QR code background white
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            'assets/img/sample/qr.png',
                            fit: BoxFit.fitHeight,
                            height: 70,
                            width: 70,
                          ),
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
                                  color: AdvertiseColor.textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                'RUPP',
                                style: AppComponent.detailTextStyle.copyWith(
                                  fontSize: 10,
                                  color: AdvertiseColor.textColor.withOpacity(
                                    0.7,
                                  ),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                'C5E9',
                                style: AppComponent.detailTextStyle.copyWith(
                                  fontSize: 10,
                                  color: AdvertiseColor.textColor.withOpacity(
                                    0.7,
                                  ),
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
                                          .withOpacity(0.3),
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

              const SizedBox(height: 10),

              // Used Ticket (if applicable)
              if (isOrganizer == false)
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UsedticketPage()),
                  ),
                  child: _buildMenuItem(
                    icon: Icons.file_copy_outlined,
                    title: t.usedTicket, // Add to ARB if needed
                  ),
                ),

              // My Ticket
              if (isOrganizer == true)
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyticketPage()),
                  ),
                  child: _buildMenuItem(
                    icon: Icons.file_copy_outlined,
                    title: t.pMyTicket,
                  ),
                ),

              const SizedBox(height: 10),

              // Notifications
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AdvertiseColor.inputFieldColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.2),
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
                    const SizedBox(width: 10),
                    Text(
                      t.pNotification,
                      style: TextStyle(
                        color: AdvertiseColor.textColor,
                        fontSize: 16,
                      ),
                    ),
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

              const SizedBox(height: 10),

              // Language
              GestureDetector(
                onTap: () => _showLanguageBottomSheet(context),
                child: _buildMenuItem(
                  icon: Icons.language,
                  title: t.pLanguage,
                  showValue: true,
                  value: langProvider.locale.languageCode == 'km'
                      ? t.khmerLabel
                      : t.englishLabel,
                ),
              ),

              const SizedBox(height: 10),

              // Password
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordPage()),
                ),
                child: _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: t.pPassword,
                ),
              ),

              const SizedBox(height: 10),

              // Appearance
              GestureDetector(
                onTap: () => _showAppearanceBottomSheet(context),
                child: _buildMenuItem(
                  icon: themeProvider.isDarkMode
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  title: t.pAppearance,
                  showValue: true,
                  value: themeProvider.isDarkMode ? t.darkLabel : t.lightLable,
                ),
              ),

              const SizedBox(height: 10),

              // Bookmark (Only for non-organizers)
              if (isOrganizer == false)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BookmarkPage()),
                    );
                  },
                  child: _buildMenuItem(
                    icon: Icons.bookmark_outline,
                    title: t.pBookmark,
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for consistent menu items
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool showValue = false,
    String? value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AdvertiseColor.inputFieldColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.2)),
      ),
      height: 70,
      width: double.infinity,
      child: Row(
        children: [
          Icon(icon, color: AdvertiseColor.primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: AdvertiseColor.textColor, fontSize: 16),
            ),
          ),
          if (showValue && value != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                value,
                style: TextStyle(
                  color: AdvertiseColor.textColor.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ),
          Icon(
            Icons.arrow_forward_ios,
            color: AdvertiseColor.textColor.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }
}
