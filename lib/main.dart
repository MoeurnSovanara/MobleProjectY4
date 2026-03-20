import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Navigator/changePage.dart';
import 'package:mobile_assignment/Pages/landingpage.dart';
import 'package:mobile_assignment/l10n/app_localizations.dart';
import 'package:mobile_assignment/providers/language_provider.dart';
import 'package:mobile_assignment/providers/theme_provider.dart'; // Add this import
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  // runApp(DevicePreview(builder: (context) => MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Usersharedpreferences _usersharedpreferences = Usersharedpreferences();
  String _userEmail = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    try {
      final String? email = await _usersharedpreferences.getUserEmail();

      if (mounted) {
        setState(() {
          _userEmail = email ?? "";
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final provider = LanguageProvider();
            provider.loadSavedLanguage();
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (context, langProvider, themeProvider, child) {
          return MaterialApp(
            title: 'Advertise App',
            debugShowCheckedModeBanner: false,

            // Localization configuration
            locale: langProvider.locale,
            supportedLocales: const [Locale('en'), Locale('km')],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            localeResolutionCallback: (locale, supportedLocales) {
              if (locale != null) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              return langProvider.locale;
            },

            // Theme configuration - Using the colors from AdvertiseColor
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: AdvertiseColor.lightPrimaryColor,
              scaffoldBackgroundColor: AdvertiseColor.lightBackgroundColor,
              colorScheme: const ColorScheme.light(
                primary: AdvertiseColor.lightPrimaryColor,
                secondary: AdvertiseColor.lightBlueColor,
                error: AdvertiseColor.lightDangerColor,
                background: AdvertiseColor.lightBackgroundColor,
              ),
              useMaterial3: true,
              fontFamily: langProvider.locale.languageCode == 'km'
                  ? 'KantumruyPro'
                  : null,
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: AdvertiseColor.lightInputFieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: AdvertiseColor.lightTextColor),
                bodyMedium: TextStyle(color: AdvertiseColor.lightTextColor),
              ),
            ),

            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: AdvertiseColor.darkPrimaryColor,
              scaffoldBackgroundColor: AdvertiseColor.darkBackgroundColor,
              colorScheme: const ColorScheme.dark(
                primary: AdvertiseColor.darkPrimaryColor,
                secondary: AdvertiseColor.darkBlueColor,
                error: AdvertiseColor.darkDangerColor,
                background: AdvertiseColor.darkBackgroundColor,
              ),
              useMaterial3: true,
              fontFamily: langProvider.locale.languageCode == 'km'
                  ? 'KantumruyPro'
                  : null,
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: AdvertiseColor.darkInputFieldColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: AdvertiseColor.darkTextColor),
                bodyMedium: TextStyle(color: AdvertiseColor.darkTextColor),
              ),
            ),

            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,

            // Home screen with loading state
            home: _isLoading
                ? _buildLoadingScreen()
                : _userEmail.isEmpty
                ? const Landingpage()
                : const Changepage(),
          );
        },
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Consumer<LanguageProvider>(
      builder: (context, langProvider, child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  langProvider.locale.languageCode == 'km'
                      ? 'កំពុងផ្ទុក...'
                      : 'Loading...',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
