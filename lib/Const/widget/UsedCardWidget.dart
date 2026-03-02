import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/TicketDto.dart';
import 'package:mobile_assignment/services/Helper/HelperClass.dart';
import 'package:mobile_assignment/services/Helper/TimeHelperClass.dart';

class Usedcardwidget extends StatelessWidget {
  final Ticketdto usedTicket;
  const Usedcardwidget({super.key, required this.usedTicket});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    final helperclass = Helperclass();
    final timerhelper = Timehelperclass();
    return Container(
      height: screenWidth <= 402 ? 140 : 160,
      decoration: BoxDecoration(
        border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Image.network(
              '${headUrl}img/${usedTicket.ticketType.events.image}',
              height: 140,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset("assets/img/other/errorImage.png", height: 140),
            ),
            SizedBox(width: 5),
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    usedTicket.ticketType.events.title,
                    maxLines: 2,
                    style: AppComponent.labelStyle.copyWith(fontSize: 14),
                  ),
                  Text(
                    '${helperclass.formatDate(usedTicket.ticketType.events.eventStart)} at ${timerhelper.formatTimeAMPM(usedTicket.ticketType.events.startTime)}',
                    style: AppComponent.detailTextStyle,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      Expanded(
                        child: Text(
                          usedTicket.ticketType.events.venues.venueLocation,
                          style: AppComponent.detailTextStyle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,

                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.all(20),

                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/img/sample/qr.png'),
                              SizedBox(height: 10),
                              Text(
                                'Scan this QR code at the entrance',
                                style: AppComponent.labelStyle.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.qr_code,
                      color: AdvertiseColor.primaryColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,

                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.all(20),

                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/img/sample/qr.png'),
                              SizedBox(height: 10),
                              Text(
                                'Scan this QR code at the entrance',
                                style: AppComponent.labelStyle.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.delete_outline,
                      color: AdvertiseColor.dangerColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
