import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';

class Bookmarkcardwidget extends StatelessWidget {
  const Bookmarkcardwidget({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: Icon(
                      Icons.bookmark,
                      color: AdvertiseColor.warningColor,
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
