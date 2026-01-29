import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';

class Usedcardwidget extends StatelessWidget {
  const Usedcardwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            Image.asset('assets/img/sample/ticket.png', height: 140),
            SizedBox(width: 5),
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cambodian Tranditional Dance',
                    maxLines: 2,
                    style: AppComponent.labelStyle.copyWith(fontSize: 14),
                  ),
                  Text(
                    'Mon Nov at 1:45 PM',
                    style: AppComponent.detailTextStyle,
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Image.asset('assets/img/Icon/location.png', width: 24, height: 24),
                      Expanded(
                        child: Text(
                          'Phnom Penh, Cambodia',
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
              children: [
                Row(
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
          ],
        ),
      ),
    );
  }
}
