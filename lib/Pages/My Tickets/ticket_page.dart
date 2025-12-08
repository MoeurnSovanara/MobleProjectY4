import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/CardWidget.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  var _searchFieldContorller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content - add your page content here
        Container(
          margin: EdgeInsets.only(top: 100), // Adjust based on appbar height
          color: AdvertiseColor.backgroundColor,
          child: SingleChildScrollView(
            // Your page content goes here
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 170 * 5,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [CardWidget(), SizedBox(height: 10)],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Fixed AppBar
        Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: AdvertiseColor.primaryColor,
          ),

          child: Row(
            children: [
              Image.asset('assets/img/other/logo2.png', height: 60),
              Spacer(),
              SizedBox(
                height: 40,
                width: 200,
                child: TextField(
                  controller: _searchFieldContorller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    hintText: "Search Tickets",
                    hintStyle: AppComponent.hintSearchStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AdvertiseColor.inputFieldColor,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AdvertiseColor.inputFieldColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
