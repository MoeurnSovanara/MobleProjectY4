import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/UsedCardWidget.dart';
import 'package:mobile_assignment/Models/DTO/TicketDto.dart';
import 'package:mobile_assignment/services/API/TicketApi.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class UsedticketPage extends StatefulWidget {
  const UsedticketPage({super.key});

  @override
  State<UsedticketPage> createState() => _UsedticketPageState();
}

class _UsedticketPageState extends State<UsedticketPage> {
  Ticketapi ticketapi = Ticketapi();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  List<Ticketdto> usedTicket = [];
  @override
  void initState() {
    super.initState();
    firstTask();
  }

  void firstTask() async {
    var allTicket = await ticketapi.GetAllTicket();
    var uId = await usersharedpreferences.getUserId();
    if (!mounted) return;
    if (allTicket != null && uId != null) {
      var filterUsedTicket = allTicket
          .where((e) => e.userId == uId && e.status == "used")
          .toList();
      setState(() {
        usedTicket = filterUsedTicket;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Used Ticket',
          style: AppComponent.appBarTitleTextStyle.copyWith(
            color: AdvertiseColor.textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: usedTicket.isEmpty
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
                              Usedcardwidget(usedTicket: usedTicket[index]),
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
