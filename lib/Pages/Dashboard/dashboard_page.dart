import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Dashboard/CreateEvent/createEventPage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double progress = 55 / 500;
  final List<Map<String, dynamic>> bookingData = [
    {'label': 'Business', 'count': 10, 'color': Colors.purple},
    {'label': 'Sport', 'count': 18, 'color': Colors.green},
    {'label': 'Art', 'count': 2, 'color': Colors.red},
    {'label': 'Game', 'count': 25, 'color': Colors.orange},
  ];
  final int maxCount = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/img/other/logo2.png'),
        centerTitle: true,
        backgroundColor: AdvertiseColor.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/img/other/avatar.png',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Moth Tola', style: AppComponent.labelStyle),
                        SizedBox(height: 5),
                        Text(
                          'mothTola@gmail.com',
                          style: AppComponent.sublabelStyle,
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Createeventpage(),
                          ),
                        );
                      },
                      icon: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AdvertiseColor.primaryColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.add,
                          color: AdvertiseColor.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AdvertiseColor.blueColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Completed',
                      style: AppComponent.labelStyle.copyWith(
                        color: AdvertiseColor.backgroundColor,
                      ),
                    ),
                    SizedBox(height: 10), // Added spacing
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Purchase now to gain membership badge and chance to win many rewards.',
                            style: AppComponent.detailTextStyle.copyWith(
                              color: AdvertiseColor.backgroundColor,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          '55/500 tickets',
                          style: AppComponent.detailTextStyle.copyWith(
                            color: AdvertiseColor.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8), // Moved outside the Row
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: AdvertiseColor.backgroundColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('History booking', style: AppComponent.labelTextStyle),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 250,
                width: double.infinity,
                child: Wrap(
                  spacing: 30,
                  runSpacing: 20,
                  children: bookingData.map((item) {
                    double percent = item['count'] / maxCount;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularPercentIndicator(
                          radius: 50.0,
                          lineWidth: 10.0,
                          percent: percent.clamp(0.0, 1.0),
                          center: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${item['count']}',
                                style: TextStyle(
                                  fontFamily: 'KantumruyPro',
                                  fontWeight: FontWeight.bold,
                                  color: item['color'],
                                ),
                              ),
                              Text(
                                item['label'],
                                style: TextStyle(
                                  fontFamily: 'KantumruyPro',
                                  color: item['color'],
                                ),
                              ),
                            ],
                          ),
                          progressColor: item['color'],
                          backgroundColor: item['color'].withOpacity(0.2),
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                        SizedBox(height: 8),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
