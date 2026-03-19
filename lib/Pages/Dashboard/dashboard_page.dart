import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/Global/global.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Pages/Dashboard/CreateEvent/createEventPage.dart';
import 'package:mobile_assignment/l10n/app_localizations.dart';
import 'package:mobile_assignment/services/API/CategoryApi.dart';
import 'package:mobile_assignment/services/API/TicketApi.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Usersharedpreferences _prefs = Usersharedpreferences();
  final Categoryapi _categoryApi = Categoryapi();
  final Ticketapi _ticketApi = Ticketapi();

  bool _isLoading = true;
  bool? isOrganizer = false;
  String? userName = "";
  String? userEmail = "";
  String? userImage = "";
  int? userId = 0;

  // Dynamic data
  List<Map<String, dynamic>> categoryBookingData = [];
  Map<String, dynamic> ticketSalesData = {
    'vip': 0,
    'regular': 0,
    'simple': 0,
    'total': 0,
  };
  List<Map<String, dynamic>> topEventsByRevenue = [];
  double completedProgress = 0.0;
  int totalTickets = 0;
  int purchasedTickets = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final organizer = await _prefs.getUserOrganizer();
      final name = await _prefs.getUserName();
      final email = await _prefs.getUserEmail();
      final id = await _prefs.getUserId();
      final image = await _prefs.getUserImage();

      if (mounted) {
        setState(() {
          isOrganizer = organizer;
          userId = id;
          userName = name;
          userEmail = email;
          userImage = image;
        });
      }

      await _loadDashboardData();
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadDashboardData() async {
    try {
      // Load categories and tickets in parallel
      final results = await Future.wait([
        _categoryApi.getAllCategory(),
        _ticketApi.GetAllTicket(),
      ]);

      final categories = results[0] as List? ?? [];
      final tickets = results[1] as List? ?? [];

      if (mounted) {
        setState(() {
          _processCategoryData(categories, tickets);
          _processTicketSalesData(tickets);
          _processTopEvents(tickets);
          _calculateProgress(tickets);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading dashboard data: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _processCategoryData(List categories, List tickets) {
    // Create a map to count tickets per category
    Map<int, int> categoryCount = {};
    Map<int, String> categoryNames = {};
    List<Color> categoryColors = [
      Colors.purple,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.blue,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];

    // Get category names
    for (var category in categories) {
      if (category.id != null) {
        categoryNames[category.id] = category.categoryName ?? 'Unknown';
      }
    }

    // Count tickets per category
    for (var ticket in tickets) {
      try {
        final event = ticket.ticketType?.events;
        if (event != null && event.categoryId != null) {
          final catId = event.categoryId;
          categoryCount[catId] = (categoryCount[catId] ?? 0) + 1;
        }
      } catch (e) {
        continue;
      }
    }

    // Convert to list format for display
    categoryBookingData = categoryCount.entries.map((entry) {
      final index = categoryBookingData.length % categoryColors.length;
      return {
        'label': categoryNames[entry.key] ?? 'Category ${entry.key}',
        'count': entry.value,
        'color': categoryColors[index],
      };
    }).toList();

    // Sort by count descending and take top 4
    categoryBookingData.sort((a, b) => b['count'].compareTo(a['count']));
    if (categoryBookingData.length > 4) {
      categoryBookingData = categoryBookingData.sublist(0, 4);
    }
  }

  void _processTicketSalesData(List tickets) {
    int vip = 0, regular = 0, simple = 0;

    for (var ticket in tickets) {
      try {
        final ticketType = ticket.ticketType;
        if (ticketType != null) {
          final typeName = ticketType.typeName?.toLowerCase() ?? '';
          if (typeName.contains('vip')) {
            vip++;
          } else if (typeName.contains('regular')) {
            regular++;
          } else {
            simple++;
          }
        }
      } catch (e) {
        continue;
      }
    }

    ticketSalesData = {
      'vip': vip,
      'regular': regular,
      'simple': simple,
      'total': vip + regular + simple,
    };
  }

  void _processTopEvents(List tickets) {
    Map<int, Map<String, dynamic>> eventRevenue = {};

    for (var ticket in tickets) {
      try {
        final ticketType = ticket.ticketType;
        final event = ticketType?.events;

        if (event != null && event.id != null) {
          final eventId = event.id;
          final revenue = ticketType?.price ?? 0.0;

          if (!eventRevenue.containsKey(eventId)) {
            eventRevenue[eventId!] = {
              'name': event.title ?? 'Unknown Event',
              'revenue': 0.0,
              'color': _getRandomColor(eventRevenue.length),
            };
          }

          eventRevenue[eventId!]!['revenue'] += revenue;
        }
      } catch (e) {
        continue;
      }
    }

    // Convert to list and sort by revenue
    topEventsByRevenue = eventRevenue.values.toList();
    topEventsByRevenue.sort((a, b) => b['revenue'].compareTo(a['revenue']));

    // Take top 3
    if (topEventsByRevenue.length > 3) {
      topEventsByRevenue = topEventsByRevenue.sublist(0, 3);
    }

    // Calculate max revenue for progress bars
    if (topEventsByRevenue.isNotEmpty) {
      final maxRevenue = topEventsByRevenue.first['revenue'];
      for (var event in topEventsByRevenue) {
        event['progress'] = maxRevenue > 0
            ? event['revenue'] / maxRevenue
            : 0.0;
      }
    }
  }

  Color _getRandomColor(int index) {
    List<Color> colors = [
      AdvertiseColor.primaryColor,
      AdvertiseColor.dangerColor,
      AdvertiseColor.warningColor,
      Colors.green,
      Colors.purple,
      Colors.orange,
    ];
    return colors[index % colors.length];
  }

  void _calculateProgress(List tickets) {
    totalTickets = 500; // Default or you can calculate from actual data
    purchasedTickets = tickets.length;
    completedProgress = totalTickets > 0
        ? purchasedTickets / totalTickets
        : 0.0;
  }

  List<PieChartSectionData> _createPieChartSections() {
    final total = ticketSalesData['total'].toDouble();
    if (total == 0) {
      return [
        PieChartSectionData(
          value: 1,
          title: '0%',
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

    return [
      PieChartSectionData(
        value: ticketSalesData['vip'].toDouble(),
        title:
            '${((ticketSalesData['vip'] / total) * 100).toStringAsFixed(1)}%',
        color: Colors.lightBlue,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: ticketSalesData['regular'].toDouble(),
        title:
            '${((ticketSalesData['regular'] / total) * 100).toStringAsFixed(1)}%',
        color: Colors.pinkAccent,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        value: ticketSalesData['simple'].toDouble(),
        title:
            '${((ticketSalesData['simple'] / total) * 100).toStringAsFixed(1)}%',
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
        _buildLegendItem(
          'VIP',
          Colors.lightBlue,
          ticketSalesData['vip'].toString(),
        ),
        _buildLegendItem(
          'Regular',
          Colors.pinkAccent,
          ticketSalesData['regular'].toString(),
        ),
        _buildLegendItem(
          'Simple',
          Colors.grey,
          ticketSalesData['simple'].toString(),
        ),
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
    if (_isLoading) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(),
              const SizedBox(height: 10),
              _buildCompletedSection(),

              if (isOrganizer == true) ...[
                const SizedBox(height: 20),
                Text(t.historyPostBooking, style: AppComponent.labelTextStyle),
                const SizedBox(height: 10),
                _buildCategoryBookingChart(),
              ],

              const SizedBox(height: 20),
              Text(t.historyBooking, style: AppComponent.labelTextStyle),
              const SizedBox(height: 10),
              _buildCategoryBookingChart(),

              if (isOrganizer == true && topEventsByRevenue.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildTopEventsSection(),
                const SizedBox(height: 20),
                _buildTicketTypeChart(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Image.asset('assets/img/other/logo2.png', height: 40),
      centerTitle: true,
      backgroundColor: AdvertiseColor.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Image.network(
            '${headUrl}lib/img/User/$userImage',
            errorBuilder: (context, error, stackTrace) => Image.asset(
              'assets/img/other/avatar.png',
              fit: BoxFit.cover,
              width: 50,
              height: 50,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName ?? 'Guest', style: AppComponent.labelStyle),
                const SizedBox(height: 5),
                Text(
                  userEmail ?? 'No email',
                  style: AppComponent.sublabelStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
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
              child: Icon(Icons.add, color: AdvertiseColor.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedSection() {
    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AdvertiseColor.blueColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.complete,
            style: AppComponent.labelStyle.copyWith(
              color: AdvertiseColor.backgroundColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  t.dComplete,
                  style: AppComponent.detailTextStyle.copyWith(
                    color: AdvertiseColor.backgroundColor,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '$purchasedTickets/$totalTickets ${t.tickets}',
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
              value: completedProgress.clamp(0.0, 1.0),
              minHeight: 10,
              backgroundColor: AdvertiseColor.backgroundColor,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBookingChart() {
    final data = categoryBookingData.isEmpty
        ? [
            {'label': 'No Data', 'count': 0, 'color': Colors.grey},
          ]
        : categoryBookingData;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      height: 250,
      width: double.infinity,
      child: Wrap(
        spacing: 30,
        runSpacing: 20,
        children: data.map((item) {
          final maxCount = data
              .map((e) => e['count'] as int)
              .fold(0, (prev, element) => prev > element ? prev : element);
          double percent = maxCount > 0 ? item['count'] / maxCount : 0.0;

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
                    Flexible(
                      child: Text(
                        item['label'],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          fontFamily: 'KantumruyPro',
                          color: item['color'],
                        ),
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
    );
  }

  Widget _buildTopEventsSection() {
    if (topEventsByRevenue.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(child: Text('No event data available')),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Top3 Events By Revenues",
            style: AppComponent.boldTextStyle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ...topEventsByRevenue
              .map(
                (event) => Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: LinearProgressIndicator(
                        value: event['progress'].clamp(0.0, 1.0),
                        minHeight: 20,
                        backgroundColor: AdvertiseColor.textColor.withOpacity(
                          0.1,
                        ),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          event['color'],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event['name'],
                            style: AppComponent.sublabelStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          "\$${event['revenue'].toStringAsFixed(0)}",
                          style: AppComponent.sublabelStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildTicketTypeChart() {
    if (ticketSalesData['total'] == 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Center(child: Text('No ticket sales data available')),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AdvertiseColor.textColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            "Most Sold Ticket Type",
            style: AppComponent.boldTextStyle.copyWith(fontSize: 16),
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
    );
  }
}
