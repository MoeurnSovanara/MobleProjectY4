import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';

class TicketInfo_widget extends StatelessWidget {
  final bool status;
  final String image;
  const TicketInfo_widget({
    super.key,
    required this.status,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(color: AdvertiseColor.textColor),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: screenWidth <= 375 ? 18 : 20,
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Image.asset(image, fit: BoxFit.fitWidth, width: 80),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('VIP', style: AppComponent.boldTextStyle),
              SizedBox(height: 5),
              status
                  ? Row(
                      children: [
                        Text('Available:', style: AppComponent.detailTextStyle),
                        Text(' 20', style: AppComponent.primaryThemeTextStyle),
                        Text(' ticket', style: AppComponent.detailTextStyle),
                      ],
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AdvertiseColor.dangerColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      height: 20,
                      child: Text(
                        'Ticket sold Out',
                        style: AppComponent.elevatedButtonTextStyle.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ),
            ],
          ),
          Spacer(),
          Expanded(child: VerticalDivider(thickness: 1)),
          Text(
            '\$ 120',
            style: AppComponent.boldTextStyle.copyWith(
              fontSize: screenWidth <= 375 ? 18 : 24,
              color: AdvertiseColor.textColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
