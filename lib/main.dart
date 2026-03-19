import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Navigator/changePage.dart';
import 'package:mobile_assignment/Pages/landingpage.dart';
import 'package:mobile_assignment/l10n/app_localizations.dart';
import 'package:mobile_assignment/providers/language_provider.dart';
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
      // Load organizer status if needed elsewhere
      // final bool? isOrganizer = await _usersharedpreferences.getUserOrganizer();

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
    return ChangeNotifierProvider(
      create: (context) {
        final provider = LanguageProvider();
        // Load saved language preference
        provider.loadSavedLanguage();
        return provider;
      },
      child: Consumer<LanguageProvider>(
        builder: (context, langProvider, child) {
          return MaterialApp(
            title: 'Advertise App',
            debugShowCheckedModeBanner: false,

            // Localization configuration
            locale: langProvider.locale,
            supportedLocales: const [
              Locale('en'), // English
              Locale('km'), // Khmer
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Improved locale resolution
            localeResolutionCallback: (locale, supportedLocales) {
              // If device locale is supported, use it
              if (locale != null) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale.languageCode) {
                    return supportedLocale;
                  }
                }
              }
              // Otherwise use the provider's locale (saved preference)
              return langProvider.locale;
            },

            // Theme configuration
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AdvertiseColor.backgroundColor,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              fontFamily: langProvider.locale.languageCode == 'km'
                  ? 'KantumruyPro' // Add this if you have Khmer font
                  : null,
            ),

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
