import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sport_log/helpers/extensions/date_time_extension.dart';
import 'package:sport_log/helpers/extensions/iterable_extension.dart';
import 'package:sport_log/pages/workout/date_filter/date_filter_state.dart';
import 'package:sport_log/pages/workout/charts/all.dart';

class ChartValue {
  final DateTime datetime;
  final double value;

  ChartValue({required this.datetime, required this.value});

  @override
  String toString() => "$datetime: $value";
}

enum AggregatorType {
  min,
  max,
  sum,
  avg,
  none,
}

extension on AggregatorType {
  /// list must not be empty
  double compute(List<double> list) {
    switch (this) {
      case AggregatorType.min:
        return list.min;
      case AggregatorType.max:
        return list.max;
      case AggregatorType.sum:
        return list.sum;
      case AggregatorType.avg:
        return list.avg;
      case AggregatorType.none:
        return list.first;
    }
  }
}

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
    required this.chartValues,
    required this.desc,
    required this.dateFilterState,
    required this.yFromZero,
    required this.aggregatorType,
  }) : super(key: key);

  final List<ChartValue> chartValues;
  final bool desc;
  final DateFilterState dateFilterState;
  final bool yFromZero;
  final AggregatorType aggregatorType;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: _chart(),
    );
  }

  Widget _chart() {
    final _chartValues = chartValues
        .groupBy((v) => _groupFunction(v.datetime), (v) => v.value)
        .entries
        .map(
          (entry) => ChartValue(
            datetime: entry.key,
            value: aggregatorType.compute(entry.value),
          ),
        )
        .toList()
      ..sort((v1, v2) => v1.datetime.compareTo(v2.datetime));
    switch (dateFilterState.runtimeType) {
      case DayFilter:
        return DayChart(
          chartValues: _chartValues,
          isTime: false,
        );
      case WeekFilter:
        return WeekChart(
          chartValues: _chartValues,
          isTime: false,
        );
      case MonthFilter:
        return MonthChart(
          chartValues: _chartValues,
          yFromZero: yFromZero,
          isTime: false,
        );
      case YearFilter:
        return YearChart(
          chartValues: _chartValues,
          yFromZero: yFromZero,
          isTime: false,
        );
      default:
        return AllChart(
          chartValues: _chartValues,
          yFromZero: yFromZero,
          isTime: false,
        );
    }
  }

  DateTime _groupFunction(DateTime dateTime) {
    switch (dateFilterState.runtimeType) {
      case DayFilter:
        return dateTime;
      case WeekFilter:
        return dateTime.beginningOfDay();
      case MonthFilter:
        return dateTime.beginningOfDay();
      case YearFilter:
        return dateTime.beginningOfMonth().add(const Duration(days: 15));
      default:
        return dateTime.beginningOfMonth().add(const Duration(days: 15));
    }
  }
}

FlLine Function(double value) gridLineDrawer(BuildContext context) {
  return (value) => FlLine(
        color: Theme.of(context).colorScheme.primary,
        strokeWidth: 0.3,
        dashArray: [4, 4],
      );
}
