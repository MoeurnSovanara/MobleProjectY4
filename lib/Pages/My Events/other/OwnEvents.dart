import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/editEventWidget.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';
import 'package:mobile_assignment/Pages/Dashboard/CreateEvent/createEventPage.dart';
import 'package:mobile_assignment/l10n/app_localizations.dart';
import 'package:mobile_assignment/services/API/EventApi.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class Ownevents extends StatefulWidget {
  const Ownevents({super.key});

  @override
  State<Ownevents> createState() => _OwneventsState();
}

class _OwneventsState extends State<Ownevents> {
  Eventapi eventapi = Eventapi();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  List<Eventdto> event = [];

  @override
  void initState() {
    super.initState();
    _loadUserEvent();
  }

  void _loadUserEvent() async {
    if (mounted) {
      var userId = await usersharedpreferences.getUserId();
      if (userId != null) {
        var allEvent = await eventapi.getAllEvents();
        List<Eventdto> filterEvent = allEvent!
            .where((e) => e.userId == userId)
            .toList();
        setState(() {
          event = filterEvent;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.all(10),
        title: Text(
          t.eventLabel,
          style: AppComponent.appBarTitleTextStyle.copyWith(
            color: AdvertiseColor.textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Createeventpage()),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: event.length,
                itemBuilder: (BuildContext context, int index) {
                  return Editeventwidget(
                    eventData: event[index],
                    update: _loadUserEvent,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
