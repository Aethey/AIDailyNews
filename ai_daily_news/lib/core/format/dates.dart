const _weekdays = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const _monthShort = [
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

DateTime parseIssueDate(String ymd) => DateTime.parse(ymd);

String deskDateLabel(String ymd) {
  final date = parseIssueDate(ymd);
  return '${_weekdays[date.weekday - 1]}, ${_months[date.month - 1]} ${date.day}';
}

String coverMonthDay(String ymd) {
  final date = parseIssueDate(ymd);
  return '${_monthShort[date.month - 1]} ${date.day.toString().padLeft(2, '0')}';
}

String monthTitle(String ymd) {
  final date = parseIssueDate(ymd);
  return _months[date.month - 1];
}

String twoDigits(int value) => value.toString().padLeft(2, '0');
