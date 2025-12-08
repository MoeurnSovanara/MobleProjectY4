import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/UsedCardWidget.dart';

class UsedticketPage extends StatefulWidget {
  const UsedticketPage({super.key});

  @override
  State<UsedticketPage> createState() => _UsedticketPageState();
}

class _UsedticketPageState extends State<UsedticketPage> {
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 170 * 5,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [Usedcardwidget(), SizedBox(height: 10)],
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
