import 'package:sport_log/helpers/extensions/date_time_extension.dart';

abstract class DateFilterState {
  const DateFilterState();

  DateTime? get start;

  DateTime? get end;

  bool get goingForwardPossible =>
      end == null ? false : end!.isBefore(DateTime.now());

  DateFilterState get earlier;

  DateFilterState get later;

  /// returns String with human readable formatted date
  String get label;

  /// return static String with name of filter
  String get name;

  @override
  int get hashCode => Object.hash(runtimeType, start, end);

  @override
  bool operator ==(Object other) =>
      other is DateFilterState && other.start == start && other.end == end;

  static List<DateFilterState Function(DateFilterState)> all = [
    (DateFilterState dateFilterState) =>
        DayFilter(dateFilterState.start ?? DateTime.now()),
    (DateFilterState dateFilterState) =>
        WeekFilter(dateFilterState.start ?? DateTime.now()),
    (DateFilterState dateFilterState) =>
        MonthFilter(dateFilterState.start ?? DateTime.now()),
    (DateFilterState dateFilterState) =>
        YearFilter(dateFilterState.start ?? DateTime.now()),
    (DateFilterState dateFilterState) => const AllFilter()
  ];

  static DateFilterState get init => MonthFilter(DateTime.now());
}

class DayFilter extends DateFilterState {
  factory DayFilter(DateTime date) {
    return DayFilter._(date.beginningOfDay());
  }

  const DayFilter._(this.start);

  @override
  final DateTime start;

  @override
  DateTime get end => start.dayLater();

  @override
  DayFilter get earlier => DayFilter._(start.dayEarlier());

  @override
  DayFilter get later => DayFilter._(end);

  @override
  String get label => start.toHumanDay();

  @override
  String get name => 'Day';
}

class WeekFilter extends DateFilterState {
  factory WeekFilter(DateTime date) {
    return WeekFilter._(date.beginningOfWeek());
  }

  const WeekFilter._(this.start);

  @override
  final DateTime start;

  @override
  DateTime get end => start.weekLater();

  @override
  WeekFilter get earlier => WeekFilter._(start.weekEarlier());

  @override
  WeekFilter get later => WeekFilter._(end);

  @override
  String get label => start.toHumanWeek();

  @override
  String get name => 'Week';
}

class MonthFilter extends DateFilterState {
  factory MonthFilter(DateTime date) {
    return MonthFilter._(date.beginningOfMonth());
  }

  const MonthFilter._(this.start);

  @override
  final DateTime start;

  @override
  DateTime get end => start.monthLater();

  @override
  MonthFilter get earlier => MonthFilter._(start.monthEarlier());

  @override
  MonthFilter get later => MonthFilter._(end);

  @override
  String get label => start.toHumanMonth();

  @override
  String get name => 'Month';
}

class YearFilter extends DateFilterState {
  factory YearFilter(DateTime date) {
    return YearFilter._(date.beginningOfYear());
  }

  const YearFilter._(this.start);

  @override
  final DateTime start;

  @override
  DateTime get end => start.yearLater();

  @override
  YearFilter get earlier => YearFilter._(start.yearEarlier());

  @override
  YearFilter get later => YearFilter._(end);

  @override
  String get label => start.toHumanYear();

  @override
  String get name => 'Year';
}

class AllFilter extends DateFilterState {
  const AllFilter();

  @override
  String get label => 'All';

  @override
  DateFilterState get earlier => this;

  @override
  DateFilterState get later => this;

  @override
  String get name => 'All';

  @override
  DateTime? get end => null;

  @override
  DateTime? get start => null;
}
