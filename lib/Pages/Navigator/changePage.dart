import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Dashboard/dashboard_page.dart';
import 'package:mobile_assignment/Pages/Event/event_page.dart';
import 'package:mobile_assignment/Pages/Home/home_page.dart';
import 'package:mobile_assignment/Pages/My%20Events/MyEvents.dart';
import 'package:mobile_assignment/Pages/My%20Tickets/ticket_page.dart';
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
  late Myevents myevents;

  int currentTabIndex = 0;

  @override
  void initState() {
    homePage = HomePage();
    eventPage = EventPage();
    dashboardPage = DashboardPage();
    ticketPage = TicketPage();
    profilePage = ProfilePage();
    myevents = Myevents();
    if (isOrganizer) {
      pages = [homePage, eventPage, dashboardPage, myevents, profilePage];
    } else {
      pages = [homePage, eventPage, dashboardPage, ticketPage, profilePage];
    }

    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
      ),
    );
  }
}
