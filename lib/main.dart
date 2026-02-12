import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Navigator/changePage.dart';
import 'package:mobile_assignment/Pages/landingpage.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  // runApp(DevicePreview(builder: (context) => MyApp()));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  String userEmail = "";
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  void _loadUserEmail() async {
    String? email = await usersharedpreferences.getUserEmail();
    bool? isOrganizer = await usersharedpreferences.getUserOrganizer();
    setState(() {
      userEmail = email ?? "";
      _isLoading = false; // Set loading to false when done
      isOrganizer = isOrganizer ?? false; // Default to false if not set
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advertise App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AdvertiseColor.backgroundColor,
        ),
      ),
      home: _isLoading
          ? Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ) // Show loading indicator while checking
          : userEmail.isEmpty
          ? Landingpage() // Show landing page if not logged in
          : Changepage(), // Show homepage if already logged in
    );
  }
}
