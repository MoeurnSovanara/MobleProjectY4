import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/editEventWidget.dart';
import 'package:mobile_assignment/Pages/Dashboard/CreateEvent/createEventPage.dart';

class Ownevents extends StatelessWidget {
  const Ownevents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.all(10),
        title: Text(
          'My Events',
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
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Editeventwidget();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
