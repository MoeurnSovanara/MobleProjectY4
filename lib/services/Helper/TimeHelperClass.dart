class Timehelperclass {
    // ADD THESES HELPER METHODS INSIDE YOUR _EventdetailedPageState CLASS:

  String formatTime(Duration? time) {
    if (time == null) return 'TBD';

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hour = twoDigits(time.inHours);
    final minute = twoDigits(time.inMinutes.remainder(60));

    return '$hour:$minute';
  }

  String formatTimeRange(Duration? start, Duration? end) {
    if (start == null && end == null) return 'Time TBD';
    if (start == null) return 'Ends at ${formatTime(end)}';
    if (end == null) return 'Starts at ${formatTime(start)}';

    return '${formatTime(start)} - ${formatTime(end)}';
  }

  // Optional: AM/PM format if you prefer
  String formatTimeAMPM(Duration? time) {
    if (time == null) return 'TBD';

    int hour = time.inHours;
    int minute = time.inMinutes.remainder(60);
    String period = hour >= 12 ? 'PM' : 'AM';

    // Convert to 12-hour format
    hour = hour % 12;
    if (hour == 0) hour = 12;

    String minuteStr = minute.toString().padLeft(2, '0');
    return '$hour:$minuteStr $period';
  }

  String formatTimeRangeAMPM(Duration? start, Duration? end) {
    if (start == null && end == null) return 'Time TBD';
    if (start == null) return 'Ends at ${formatTimeAMPM(end)}';
    if (end == null) return 'Starts at ${formatTimeAMPM(start)}';

    return '${formatTimeAMPM(start)} - ${formatTimeAMPM(end)}';
  }
}