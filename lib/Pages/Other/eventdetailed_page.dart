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
                  const _EventDetailInteractionRow(),
                  const SizedBox(height: 5),
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
                              Image.asset('assets/img/Icon/calendar.png', width: 24, height: 24),
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
                              Image.asset('assets/img/Icon/calendar.png', width: 24, height: 24),
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
                              Image.asset('assets/img/Icon/clock.png', width: 24, height: 24),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/img/Icon/location.png', width: 22, height: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location: Phnom Penh',
                                  style: TextStyle(
                                    fontFamily: 'KantumruyPro',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: AdvertiseColor.textColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Image.asset('assets/img/other/googlemap.png', height: 20),
                                    SizedBox(width: 6),
                                    Text(
                                      'Google Map',
                                      style: TextStyle(
                                        fontFamily: 'KantumruyPro',
                                        fontSize: 13,
                                        color: AdvertiseColor.textColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFFE8ECF5),
                          border: Border.all(
                            color: AdvertiseColor.primaryColor.withOpacity(0.4),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Stage',
                            style: TextStyle(
                              fontFamily: 'KantumruyPro',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AdvertiseColor.textColor,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: AdvertiseColor.primaryColor.withOpacity(0.12),
                                border: Border.all(
                                  color: AdvertiseColor.primaryColor.withOpacity(0.4),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Zone A',
                                    style: TextStyle(
                                      fontFamily: 'KantumruyPro',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AdvertiseColor.textColor,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'VIP',
                                    style: TextStyle(
                                      fontFamily: 'KantumruyPro',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AdvertiseColor.textColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFF9E6),
                                border: Border.all(
                                  color: AdvertiseColor.primaryColor.withOpacity(0.4),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Zone B',
                                    style: TextStyle(
                                      fontFamily: 'KantumruyPro',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AdvertiseColor.textColor,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Premium',
                                    style: TextStyle(
                                      fontFamily: 'KantumruyPro',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AdvertiseColor.textColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFF9E6),
                                border: Border.all(
                                  color: AdvertiseColor.primaryColor.withOpacity(0.4),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Zone C',
                                    style: TextStyle(
                                      fontFamily: 'KantumruyPro',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AdvertiseColor.textColor,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Standart',
                                    style: TextStyle(
                                      fontFamily: 'KantumruyPro',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AdvertiseColor.textColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: AdvertiseColor.primaryColor.withOpacity(0.12),
                                border: Border.all(
                                  color: AdvertiseColor.primaryColor.withOpacity(0.4),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Zone D',
                                    style: TextStyle(
                                      fontFamily: 'KantumruyPro',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AdvertiseColor.textColor,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'General',
                                    style: TextStyle(
                                      fontFamily: 'KantumruyPro',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AdvertiseColor.textColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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

class _EventDetailInteractionRow extends StatefulWidget {
  const _EventDetailInteractionRow();

  @override
  State<_EventDetailInteractionRow> createState() =>
      _EventDetailInteractionRowState();
}

class _EventDetailInteractionRowState extends State<_EventDetailInteractionRow> {
  static const int _initialBookmarkCount = 100;
  int _bookmarkCount = _initialBookmarkCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const LikeDislikeRow(
          likes: 1500,
          dislikes: 1000,
        ),
        const Spacer(),
        Text(
          '$_bookmarkCount',
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'KantumruyPro',
          ),
        ),
        const SizedBox(width: 6),
        BookmarkButton(
          size: 20,
          onChanged: (isBookmarked) {
            setState(() {
              _bookmarkCount =
                  _initialBookmarkCount + (isBookmarked ? 1 : 0);
            });
          },
        ),
      ],
    );
  }
}
