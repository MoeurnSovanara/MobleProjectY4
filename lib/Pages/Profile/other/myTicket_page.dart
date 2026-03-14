import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/CardWidget.dart';
import 'package:mobile_assignment/Models/DTO/TicketDto.dart';
import 'package:mobile_assignment/services/API/TicketApi.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class MyticketPage extends StatefulWidget {
  const MyticketPage({super.key});

  @override
  State<MyticketPage> createState() => _MyticketPageState();
}

class _MyticketPageState extends State<MyticketPage> {
  Ticketapi ticketapi = Ticketapi();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  List<Ticketdto> usedTicket = [];
  int? userId;
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    firstTask();
  }

  void firstTask() async {
    setState(() {
      _loading = true;
    });
    var allTicket = await ticketapi.GetAllTicket();
    var uId = await usersharedpreferences.getUserId();
    if (!mounted) {
      setState(() {
        _loading = false;
        return;
      });
    }
    if (allTicket != null && uId != null) {
      var filterUsedTicket = allTicket
          .where((e) => e.userId == uId && e.status == "active")
          .toList();
      setState(() {
        _loading = false;
        usedTicket = filterUsedTicket;
        userId = uId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Tickets',
          style: AppComponent.appBarTitleTextStyle.copyWith(
            color: AdvertiseColor.textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : usedTicket.isEmpty
          ? Container(
              padding: EdgeInsets.all(10),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      color: AdvertiseColor.dangerColor,
                      size: 50,
                    ),
                    Text(
                      "No Tickets Found!",
                      style: AppComponent.boldTextStyle,
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 170 * usedTicket.length.toDouble(),
                      child: ListView.builder(
                        itemCount: usedTicket.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              CardWidget(
                                tickets: usedTicket[index],
                                userId: userId,
                                onTicketUpdated: () {},
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
