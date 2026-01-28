import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/bookmark_button.dart';
import 'package:mobile_assignment/Const/widget/like_dislike_row.dart';
import 'package:mobile_assignment/Pages/Other/bookticket_page.dart';

class EventdetailedPage extends StatelessWidget {
  const EventdetailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sticky event image at the top
          Builder(
            builder: (context) {
              final paddingTop = MediaQuery.of(context).padding.top;

              return Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/img/sample/event.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12, paddingTop + 8, 12, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.35),
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(
                            'assets/img/Icon/arrowback.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Scrollable content below
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    children: [
                      const LikeDislikeRow(
                        likes: 1500,
                        dislikes: 1000,
                      ),
                      const Spacer(),
                      Text(
                        '100',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'KantumruyPro',
                        ),
                      ),
                      const SizedBox(width: 6),
                      const BookmarkButton(
                        size: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Symphony', style: AppComponent.boldTextStyle),
                      SizedBox(width: 5),
                      Text(
                        'ស៊ីមហ្វីនី',
                        style: TextStyle(
                          fontFamily: 'KantumruyPro',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AdvertiseColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'This is a longer piece of dummy text that spans multiple lines and can be used to test how your UI handles longer content. It helps ensure that text wrapping, overflow, and other text-related properties work correctly.',
                    style: AppComponent.detailTextStyle,
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_month_outlined),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start Date',
                                      style: AppComponent.labelStyle,
                                    ),
                                    Text(
                                      '16-March-2025',
                                      style: AppComponent.hintTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(Icons.calendar_month_outlined),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'End Date',
                                      style: AppComponent.labelStyle,
                                    ),
                                    Text(
                                      '23-March-2025',
                                      style: AppComponent.hintTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.timer_outlined),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Time',
                                      style: AppComponent.labelStyle,
                                    ),
                                    Text(
                                      '8:00AM-10:00AM',
                                      style: AppComponent.hintTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined),
                          SizedBox(width: 5),
                          Text(
                            'Location: Phnom Penh',
                            style: AppComponent.hintTextStyle.copyWith(
                              color: AdvertiseColor.textColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Image.asset('assets/img/other/googlemap.png'),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AdvertiseColor.primaryColor,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Stage',
                                  style: AppComponent.boldTextStyle,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AdvertiseColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Zone A',
                                        style: AppComponent.boldTextStyle,
                                      ),
                                      Text(
                                        'VIP',
                                        style: AppComponent.sublabelStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AdvertiseColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Zone B',
                                        style: AppComponent.boldTextStyle,
                                      ),
                                      Text(
                                        'Premium',
                                        style: AppComponent.sublabelStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AdvertiseColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Zone C',
                                        style: AppComponent.boldTextStyle,
                                      ),
                                      Text(
                                        'Standard',
                                        style: AppComponent.sublabelStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AdvertiseColor.primaryColor,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Zone D',
                                        style: AppComponent.boldTextStyle,
                                      ),
                                      Text(
                                        'General',
                                        style: AppComponent.sublabelStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BookticketPage(),
                ),
              ),
              style: AppComponent.elevatedButtonStyle,
              child: Text(
                'Booking Ticket',
                style: AppComponent.elevatedButtonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
