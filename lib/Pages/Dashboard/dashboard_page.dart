import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Dashboard/CreateEvent/createEventPage.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';
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
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  bool? isOrganizer = false;
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadUserOrganizer(); // Call async method properly
  }

  // Fix: Move async operation to separate method
  void _loadUserOrganizer() async {
    var result = await usersharedpreferences.getUserOrganizer();
    if (mounted) {
      // Check if widget is still mounted
      setState(() {
        isOrganizer = result;
        _isLoading = false;
      });
    }
  }

  List<PieChartSectionData> _createPieChartSections() {
    final double total = 704620 + 303034 + 20221;

    return [
      PieChartSectionData(
        value: 704620,
        title: '${((704620 / total) * 100).toStringAsFixed(1)}%',
        color: Colors.lightBlue,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: 303034,
        title: '${((303034 / total) * 100).toStringAsFixed(1)}%',
        color: Colors.pinkAccent,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: 20221,
        title: '${((20221 / total) * 100).toStringAsFixed(1)}%',
        color: Colors.grey,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('VIP', Colors.lightBlue, '704,620'),
        _buildLegendItem('Regular', Colors.pinkAccent, '303,034'),
        _buildLegendItem('Simple', Colors.grey, '20,221'),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, String value) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            color: AdvertiseColor.textColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while checking organizer status
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/img/other/logo2.png'),
          centerTitle: true,
          backgroundColor: AdvertiseColor.primaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/img/other/logo2.png'),
        centerTitle: true,
        backgroundColor: AdvertiseColor.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Container(
                padding: const EdgeInsets.all(10),
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
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mut Tola', style: AppComponent.labelStyle),
                        const SizedBox(height: 5),
                        Text(
                          'mothTola@gmail.com',
                          style: AppComponent.sublabelStyle,
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Only show add button for organizers
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Createeventpage(),
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
              const SizedBox(height: 10),

              // Completed Section
              Container(
                padding: const EdgeInsets.all(20),
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
                    const SizedBox(height: 10),
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
                        const SizedBox(width: 5),
                        Text(
                          '55/500 tickets',
                          style: AppComponent.detailTextStyle.copyWith(
                            color: AdvertiseColor.backgroundColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: AdvertiseColor.backgroundColor,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // History Post Booking (Organizer only)
              if (isOrganizer == true) ...[
                const SizedBox(height: 20),
                Text(
                  'History Post booking',
                  style: AppComponent.labelTextStyle,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
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
                          const SizedBox(height: 8),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],

              // History Booking (All users)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text('History booking', style: AppComponent.labelTextStyle),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
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
                            const SizedBox(height: 8),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              // Top 3 Events By Revenues (Organizer only)
              if (isOrganizer == true) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Top3 Events By Revenues",
                        style: AppComponent.boldTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: LinearProgressIndicator(
                          value: 0.7,
                          minHeight: 20,
                          backgroundColor: AdvertiseColor.textColor.withOpacity(
                            0.1,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AdvertiseColor.primaryColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Siem Reap Marathon",
                            style: AppComponent.sublabelStyle,
                          ),
                          const Spacer(),
                          Text("1,000\$", style: AppComponent.sublabelStyle),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: LinearProgressIndicator(
                          value: 0.6,
                          minHeight: 20,
                          backgroundColor: AdvertiseColor.textColor.withOpacity(
                            0.1,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AdvertiseColor.dangerColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Esport Tournament",
                            style: AppComponent.sublabelStyle,
                          ),
                          const Spacer(),
                          Text("3,000\$", style: AppComponent.sublabelStyle),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: LinearProgressIndicator(
                          value: 0.3,
                          minHeight: 20,
                          backgroundColor: AdvertiseColor.textColor.withOpacity(
                            0.1,
                          ),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AdvertiseColor.warningColor,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Art Performance",
                            style: AppComponent.sublabelStyle,
                          ),
                          const Spacer(),
                          Text("20,000\$", style: AppComponent.sublabelStyle),
                        ],
                      ),
                    ],
                  ),
                ),

                // Pie Chart (Organizer only)
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AdvertiseColor.textColor.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Most Sold Ticket Type",
                        style: AppComponent.boldTextStyle.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 250,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: _createPieChartSections(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildLegend(),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
