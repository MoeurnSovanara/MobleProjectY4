import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
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
              width: screenWidth <= 393 ? 135 : 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cambodian Tranditional Dance',
                    maxLines: 2,
                    style: AppComponent.labelStyle.copyWith(
                      fontSize: screenWidth <= 393 ? 14 : 16,
                    ),
                  ),
                  Text(
                    'Mon Nov at 1:45 PM',
                    style: AppComponent.detailTextStyle.copyWith(
                      fontSize: screenWidth <= 393 ? 12 : 14,
                    ),
                  ),
                  Text(
                    'Phnom Penh, Cambodia',
                    style: AppComponent.detailTextStyle.copyWith(
                      fontSize: screenWidth <= 393 ? 12 : 14,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AdvertiseColor.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Price \$108',
                      style: AppComponent.elevatedButtonTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Column(
              children: [
                IconButton.outlined(
                  onPressed: () {
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
                  style: IconButton.styleFrom(side: BorderSide.none),
                  icon: Icon(
                    Icons.qr_code_scanner,
                    color: AdvertiseColor.primaryColor,
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
