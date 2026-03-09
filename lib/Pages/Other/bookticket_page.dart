import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/TicketInforWidget.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';
import 'package:mobile_assignment/Pages/Other/checkout_page.dart';

class BookticketPage extends StatefulWidget {
  final Eventdto eventdto;
  const BookticketPage({super.key, required this.eventdto});

  @override
  State<BookticketPage> createState() => _BookticketPageState();
}

class _BookticketPageState extends State<BookticketPage> {
  bool isloading = false;
  int totalTicket = 0;
  int remainingTicket = 0;
  late List<bool> ticketStatus;
  void firstJob() {
    int tTicket = 0;
    int rTicket = 0;
    setState(() {
      isloading = true;
    });
    var data = widget.eventdto.ticketTypes;
    for (var round in data) {
      tTicket += round.totalTickets;
      rTicket += round.quantityAvailable;
    }
    ticketStatus = List.generate(
      widget.eventdto.ticketTypes.length,
      (index) => widget.eventdto.ticketTypes[index].quantityAvailable > 0,
    );
    setState(() {
      totalTicket = tTicket;
      remainingTicket = rTicket;
      isloading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    firstJob();
  }

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
      body: isloading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [CircularProgressIndicator()],
            )
          : SingleChildScrollView(
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
                                      totalTicket.toString(),
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
                                      remainingTicket.toString(),
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
                      height: ticketStatus.length * 90,
                      child: ListView.builder(
                        itemCount: widget.eventdto.ticketTypes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return TicketInfo_widget(
                            image: 'assets/img/other/ticket.png',
                            status: ticketStatus[index],
                            ticketTypeDto: widget.eventdto.ticketTypes[index],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CheckoutPage(eventdto: widget.eventdto),
                        ),
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
