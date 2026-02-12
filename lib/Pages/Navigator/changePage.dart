import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Dashboard/dashboard_page.dart';
import 'package:mobile_assignment/Pages/Event/event_page.dart';
import 'package:mobile_assignment/Pages/Home/home_page.dart';
import 'package:mobile_assignment/Pages/My%20Events/MyEvents.dart';
import 'package:mobile_assignment/Pages/My%20Tickets/ticket_page.dart';
import 'package:mobile_assignment/Pages/Profile/profile_page.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class Changepage extends StatefulWidget {
  const Changepage({super.key});

  @override
  State<Changepage> createState() => _ChangepageState();
}

class _ChangepageState extends State<Changepage> {
  late List<Widget> pages;
  bool? isOrganizer = false;
  bool _isLoading = true; // Add loading state
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
    _initializePages(); // Call async method properly
  }

  // Fix: Move async operation to separate method
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
    // Show loading indicator while initializing
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AdvertiseColor.backgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AdvertiseColor.backgroundColor,
      body: pages[currentTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AdvertiseColor.backgroundColor,
        currentIndex: currentTabIndex,
        onTap: _onItemTapped,
        selectedItemColor: AdvertiseColor.primaryColor,
        unselectedItemColor: AdvertiseColor.textColor.withOpacity(0.4),
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.event_outlined),
            label: 'Events',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          // Fix: Use proper condition check
          isOrganizer == false
              ? const BottomNavigationBarItem(
                  icon: Icon(Icons.confirmation_number_outlined),
                  label: 'Tickets',
                )
              : const BottomNavigationBarItem(
                  icon: Icon(Icons.wallet),
                  label: 'My Events',
                ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
