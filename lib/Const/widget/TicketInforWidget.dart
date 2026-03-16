import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Models/DTO/TicketTypeDto.dart';

class TicketInfo_widget extends StatelessWidget {
  final bool status;
  final String image;
  final TicketTypeDto ticketTypeDto;
  const TicketInfo_widget({
    super.key,
    required this.status,
    required this.image,
    required this.ticketTypeDto,
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
        horizontal: screenWidth <= 393 ? 12 : 20,
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Image.asset(image, fit: BoxFit.fitWidth, width: 80),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150,
                child: Text(
                  ticketTypeDto.typeName,
                  style: AppComponent.boldTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 5),
              status
                  ? Row(
                      children: [
                        Text(
                          'Available: ',
                          style: AppComponent.detailTextStyle,
                        ),
                        Text(
                          ticketTypeDto.quantityAvailable.toString(),
                          style: AppComponent.primaryThemeTextStyle,
                        ),
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
            '\$ ${ticketTypeDto.price}',
            style: AppComponent.boldTextStyle.copyWith(
              fontSize: screenWidth <= 375 ? 12 : 18,
              color: AdvertiseColor.textColor.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
