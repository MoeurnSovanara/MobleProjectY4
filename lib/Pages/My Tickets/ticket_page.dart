import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/CardWidget.dart';
import 'package:mobile_assignment/services/API/TicketApi.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';
import 'package:mobile_assignment/Models/DTO/TicketDto.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final TextEditingController _searchController = TextEditingController();
  final Ticketapi _ticketApi = Ticketapi();
  final Usersharedpreferences _prefs = Usersharedpreferences();

  List<Ticketdto> _allTickets = [];
  List<Ticketdto> _filteredTickets = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserAndTickets();
    _searchController.addListener(_filterTickets);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTickets);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserAndTickets() async {
    try {
      // Get user ID first
      final userId = await _prefs.getUserId();

      if (mounted) {
        setState(() {
          _userId = userId;
        });
      }

      await _loadTickets();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error loading user data';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadTickets() async {
    try {
      final tickets = await _ticketApi.GetAllTicket();

      if (mounted) {
        List<Ticketdto> allT = [];
        if (tickets != null) {
          allT = tickets.where((e) => e.userId == _userId).toList();
        }
        setState(() {
          _allTickets = allT; // Use directly, no need to map
          _filteredTickets = allT;
          _errorMessage = _allTickets.isEmpty ? 'No tickets found' : null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load tickets';
          _isLoading = false;
        });
      }
    }
  }

  void _filterTickets() {
    final query = _searchController.text.toLowerCase();
    if (mounted) {
      setState(() {
        if (query.isEmpty) {
          _filteredTickets = _allTickets;
        } else {
          _filteredTickets = _allTickets.where((ticket) {
            final eventName = ticket.ticketType.events.title.toLowerCase();
            final eventLocation = ticket.ticketType.events.venues.venueLocation
                .toLowerCase();
            final ticketType = ticket.ticketType.typeName.toLowerCase();

            return eventName.contains(query) ||
                eventLocation.contains(query) ||
                ticketType.contains(query);
          }).toList();
        }
      });
    }
  }

  Future<void> _refreshTickets() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    await _loadTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content
        Container(
          margin: const EdgeInsets.only(top: 100),
          color: AdvertiseColor.backgroundColor,
          child: _buildBody(),
        ),

        // Fixed AppBar
        Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: AdvertiseColor.primaryColor,
          ),
          child: Row(
            children: [
              Image.asset('assets/img/other/logo2.png', height: 60),
              const Spacer(),
              SizedBox(
                height: 40,
                width: 190,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    hintText: "Search Tickets",
                    hintStyle: AppComponent.hintSearchStyle,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        color: AdvertiseColor.inputFieldColor,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AdvertiseColor.inputFieldColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: AdvertiseColor.dangerColor,
            ),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: AppComponent.labelStyle),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshTickets,
              style: ElevatedButton.styleFrom(
                backgroundColor: AdvertiseColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Try Again',
                style: AppComponent.elevatedButtonTextStyle,
              ),
            ),
          ],
        ),
      );
    }

    if (_filteredTickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.confirmation_number_outlined,
              size: 60,
              color: AdvertiseColor.textColor.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No tickets available'
                  : 'No tickets match your search',
              style: AppComponent.labelStyle.copyWith(
                color: AdvertiseColor.textColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshTickets,
      color: AdvertiseColor.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Show search result count
              if (_searchController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        'Found ${_filteredTickets.length} ticket(s)',
                        style: AppComponent.sublabelStyle.copyWith(
                          color: AdvertiseColor.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredTickets.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      CardWidget(
                        tickets: _filteredTickets[index],
                        userId: _userId,
                        onTicketUpdated: _refreshTickets,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
