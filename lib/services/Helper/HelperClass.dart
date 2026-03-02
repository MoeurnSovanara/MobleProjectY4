import 'dart:math';
import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:mobile_assignment/Models/DTO/EventDto.dart';

class Helperclass {
  // Format date to show day and month
  String formatDate(DateTime? date) {
    if (date == null) return 'Date TBA';

    // You can customize this based on your date format
    return '${date.day} ${getMonthAbbreviation(date.month)}';
  }

  String getMonthAbbreviation(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month - 1];
  }

  // Helper function to format large numbers
  String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  // Calculate total likes/dislikes from eventEngagement
  static int getTotalLikes(Eventdto eventData) {
    // Check if eventEngagement is not null
    if (eventData.eventEngagement.isEmpty) {
      return 0;
    }

    return eventData.eventEngagement
        .where((engagement) => engagement.isLiked == true)
        .length;
  }

  static int getTotalDislikes(Eventdto eventData) {
    // Check if eventEngagement is not null
    if (eventData.eventEngagement.isEmpty) {
      return 0;
    }

    return eventData.eventEngagement
        .where((engagement) => engagement.isLiked == false)
        .length;
  }

  // Optional: Add a helper method to format full date
  static String formatFullDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Optional: Add a helper method to format time
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromRGBO(
      random.nextInt(256), // R
      random.nextInt(256), // G
      random.nextInt(256), // B
      1.0, // Opacity
    );
  }
}
