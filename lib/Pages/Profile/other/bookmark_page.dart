import 'package:flutter/material.dart';
import 'package:mobile_assignment/Const/Component.dart';
import 'package:mobile_assignment/Const/themeColor.dart';
import 'package:mobile_assignment/Const/widget/BookmarkCardWidget.dart';
import 'package:mobile_assignment/Models/DTO/NotGetUserEventEngagementDto.dart';
import 'package:mobile_assignment/l10n/app_localizations.dart';
import 'package:mobile_assignment/services/API/userevent_engagement_api.dart';
import 'package:mobile_assignment/sharedpreferences/UserSharedPreferences.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  UsereventEngagementApi usereventEngagementApi = UsereventEngagementApi();
  Usersharedpreferences usersharedpreferences = Usersharedpreferences();
  List<Notgetusereventengagementdto>? bookedmarkedData;
  bool _isRefreshing = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _refreshBookmarks() async {
    // Prevent multiple simultaneous refreshes
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      var data = await usereventEngagementApi.getAllEventEngagement();
      var userId = await usersharedpreferences.getUserId();

      if (data != null && userId != null && mounted) {
        var filterData = data
            .where(
              (element) =>
                  element.isBookMarked == true && element.userId == userId,
            )
            .toList();

        setState(() {
          bookedmarkedData = filterData;
        });
      }
    } catch (e) {
      print('Error refreshing bookmarks: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh bookmarks'),
            backgroundColor: AdvertiseColor.dangerColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.pBookmark,
          style: AppComponent.appBarTitleTextStyle.copyWith(
            color: AdvertiseColor.textColor,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isRefreshing)
            Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => _refreshIndicatorKey.currentState?.show(),
            ),
        ],
      ),
      body: bookedmarkedData == null
          ? Center(child: CircularProgressIndicator())
          : bookedmarkedData!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    color: AdvertiseColor.textColor.withOpacity(0.5),
                    size: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "No Bookmarks Found!",
                    style: AppComponent.boldTextStyle,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _refreshBookmarks,
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: bookedmarkedData!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Bookmarkcardwidget(
                      key: ValueKey(
                        bookedmarkedData![index].eventId,
                      ), // Add a key
                      data: bookedmarkedData![index],
                      onBookmarkremoved: _refreshBookmarks,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
