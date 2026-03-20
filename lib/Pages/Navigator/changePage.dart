import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Dashboard/dashboard_page.dart';
import 'package:mobile_assignment/Pages/Event/event_page.dart';
import 'package:mobile_assignment/Pages/Home/home_page.dart';
import 'package:mobile_assignment/Pages/My%20Events/MyEvents.dart';
import 'package:mobile_assignment/Pages/My%20Tickets/ticket_page.dart';
import 'package:mobile_assignment/Pages/Profile/profile_page.dart';
import 'package:mobile_assignment/l10n/app_localizations.dart';
import 'package:mobile_assignment/providers/theme_provider.dart'; // Add this import
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';
import 'package:provider/provider.dart'; // Add this import

class Changepage extends StatefulWidget {
  const Changepage({super.key});

  @override
  State<Changepage> createState() => _ChangepageState();
}

class _ChangepageState extends State<Changepage> {
  late List<Widget> pages;
  bool? isOrganizer = false;
  bool _isLoading = true;
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  int currentTabIndex = 0;

  // Declare pages lazily
  late HomePage homePage;
  late EventPage eventPage;
  late DashboardPage dashboardPage;
  late TicketPage ticketPage;
  late ProfilePage profilePage;
  late Myevents myevents;

  @override
  void initState() {
    super.initState();
    _initializePages();
  }

  void _initializePages() async {
    // Initialize all pages first
    homePage = const HomePage();
    eventPage = const EventPage();
    dashboardPage = const DashboardPage();
    ticketPage = const TicketPage();
    profilePage = const ProfilePage();
    myevents = const Myevents();

    // Load organizer status
    var result = await usersharedpreferences.getUserOrganizer();

    if (mounted) {
      setState(() {
        isOrganizer = result ?? false;

        // Set pages based on organizer status
        if (isOrganizer == true) {
          pages = [homePage, eventPage, dashboardPage, myevents, profilePage];
        } else {
          pages = [homePage, eventPage, dashboardPage, ticketPage, profilePage];
        }

        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    // Listen to theme changes using Consumer
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Show loading indicator while initializing
        if (_isLoading) {
          return Scaffold(
            backgroundColor:
                AdvertiseColor.backgroundColor, // This will update with theme
            body: Center(
              child: CircularProgressIndicator(
                color:
                    AdvertiseColor.primaryColor, // This will update with theme
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AdvertiseColor
              .backgroundColor, // This will update when theme changes
          body: pages[currentTabIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AdvertiseColor
                .backgroundColor, // This will update when theme changes
            currentIndex: currentTabIndex,
            onTap: _onItemTapped,
            selectedItemColor: AdvertiseColor
                .primaryColor, // This will update when theme changes
            unselectedItemColor: AdvertiseColor.textColor.withOpacity(
              0.4,
            ), // This will update when theme changes
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: t.homeLabel,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.event_outlined),
                label: t.eventLabel,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard_outlined),
                label: t.dashBoardLabel,
              ),
              isOrganizer == false
                  ? BottomNavigationBarItem(
                      icon: const Icon(Icons.confirmation_number_outlined),
                      label: t.tickets,
                    )
                  : BottomNavigationBarItem(
                      icon: const Icon(Icons.wallet),
                      label: t.eventLabel,
                    ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                label: t.profileLabel,
              ),
            ],
          ),
        );
      },
    );
  }
}
