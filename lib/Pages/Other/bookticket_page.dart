import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/TicketInforWidget.dart';
import 'package:mobile_assignment/Pages/Other/checkout_page.dart';

class BookticketPage extends StatefulWidget {
  const BookticketPage({super.key});

  @override
  State<BookticketPage> createState() => _BookticketPageState();
}

class _BookticketPageState extends State<BookticketPage> {
  final List<bool> data = [false, true, true, true];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket Information',
          style: AppComponent.boldTextStyle.copyWith(
            color: AdvertiseColor.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/img/other/ticket.png'),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Capacity tickets',
                            style: AppComponent.detailTextStyle,
                          ),
                          Row(
                            children: [
                              Text(
                                '500',
                                style: AppComponent.primaryThemeTextStyle
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                              ),
                              Text(
                                ' ticket',
                                style: AppComponent.detailTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 40),
                  Row(
                    children: [
                      Image.asset('assets/img/other/ticket.png'),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remaining tickets',
                            style: AppComponent.detailTextStyle,
                          ),
                          Row(
                            children: [
                              Text(
                                '70',
                                style: AppComponent.primaryThemeTextStyle
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                              ),
                              Text(
                                ' tickets',
                                style: AppComponent.detailTextStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: data.length * 90,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TicketInfo_widget(
                      image: 'assets/img/other/ticket.png',
                      status: data[index],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutPage()),
                ),
                style: AppComponent.elevatedButtonStyle,
                child: Text(
                  'Buy Now',
                  style: AppComponent.elevatedButtonTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
