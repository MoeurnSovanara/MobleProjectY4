import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Dashboard/dashboard_page.dart';
import 'package:mobile_assignment/Pages/Event/event_page.dart';
import 'package:mobile_assignment/Pages/Home/home_page.dart';
import 'package:mobile_assignment/Pages/My Tickets/ticket_page.dart';
import 'package:mobile_assignment/Pages/Profile/profile_page.dart';

class Changepage extends StatefulWidget {
  const Changepage({super.key});

  @override
  State<Changepage> createState() => _ChangepageState();
}

class _ChangepageState extends State<Changepage> {
  late List<Widget> pages;

  late HomePage homePage;
  late EventPage eventPage;
  late DashboardPage dashboardPage;
  late TicketPage ticketPage;
  late ProfilePage profilePage;

  int currentTabIndex = 0;

  @override
  void initState() {
    homePage = HomePage();
    eventPage = EventPage();
    dashboardPage = DashboardPage();
    ticketPage = TicketPage();
    profilePage = ProfilePage();
    pages = [homePage, eventPage, dashboardPage, ticketPage, profilePage];
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double iconSize = size.width * 0.06; // ~6% of screen width
    final double topPadding = size.height * 0.006; // small responsive top padding

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
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Image.asset(
                'assets/img/Icon/homeTabar.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Image.asset(
                'assets/img/Icon/homeTabarActive.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Image.asset(
                'assets/img/Icon/eventTabar.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Image.asset(
                'assets/img/Icon/eventTabarActive.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Image.asset(
                'assets/img/Icon/dashboadTabar.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Image.asset(
                'assets/img/Icon/dashboardTabarActive.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Image.asset(
                'assets/img/Icon/myTicketTabar.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Image.asset(
                'assets/img/Icon/myTicketTabarActive.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Image.asset(
                'assets/img/Icon/profileTabar.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Image.asset(
                'assets/img/Icon/profileTabarActive.png',
                width: iconSize,
                height: iconSize,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
