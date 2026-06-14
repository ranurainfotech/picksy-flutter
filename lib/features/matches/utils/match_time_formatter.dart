/// Relative timestamps for match cards (e.g. "Yesterday", "2 days ago").
String formatMatchRelativeTime(DateTime? dateTime) {
  if (dateTime == null) {
    return 'Recently';
  }

  final now = DateTime.now();
  final local = dateTime.toLocal();
  final difference = now.difference(local);

  if (difference.inMinutes < 1) {
    return 'Just now';
  }
  if (difference.inHours < 1) {
    return '${difference.inMinutes}m ago';
  }

  final today = DateTime(now.year, now.month, now.day);
  final matchDay = DateTime(local.year, local.month, local.day);
  final dayDiff = today.difference(matchDay).inDays;

  if (dayDiff == 0) {
    return 'Today';
  }
  if (dayDiff == 1) {
    return 'Yesterday';
  }
  if (dayDiff < 7) {
    return '$dayDiff days ago';
  }
  if (dayDiff < 14) {
    return '1 week ago';
  }
  if (dayDiff < 30) {
    return '${(dayDiff / 7).floor()} weeks ago';
  }
  if (dayDiff < 60) {
    return '1 month ago';
  }
  return '${(dayDiff / 30).floor()} months ago';
}
