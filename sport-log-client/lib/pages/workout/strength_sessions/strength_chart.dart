import 'package:flutter/material.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/logger.dart';
import 'package:sport_log/models/movement/movement.dart';
import 'package:sport_log/models/strength/strength_session_description.dart';
import 'package:sport_log/models/strength/strength_session_stats.dart';
import 'package:sport_log/pages/workout/charts/datetime_chart.dart';
import 'package:sport_log/pages/workout/date_filter/date_filter_state.dart';
import 'package:sport_log/widgets/input_fields/selection_bar.dart';

enum SeriesType {
  maxDistance, // m
  minTime, // mSecs
  sumCalories, // cal
  maxEorm, // reps
  maxWeight, // reps
  maxReps, // reps
  avgReps, // reps
  sumVolume; // reps

  @override
  String toString() {
    switch (this) {
      case SeriesType.maxDistance:
        return 'Best Distance';
      case SeriesType.minTime:
        return 'Best Time';
      case SeriesType.sumCalories:
        return 'Total Calories';
      case SeriesType.maxEorm:
        return 'Eorm';
      case SeriesType.maxWeight:
        return 'Max Weight';
      case SeriesType.maxReps:
        return 'Max Reps';
      case SeriesType.avgReps:
        return 'Avg Reps';
      case SeriesType.sumVolume:
        return 'Total Volume';
    }
  }

  double statValue(StrengthSessionStats stats) {
    switch (this) {
      case SeriesType.maxDistance:
        return stats.maxCount.toDouble();
      case SeriesType.minTime:
        return stats.minCount.toDouble();
      case SeriesType.sumCalories:
        return stats.sumCount.toDouble();
      case SeriesType.maxEorm:
        return stats.maxEorm ?? 0;
      case SeriesType.maxWeight:
        return stats.maxWeight ?? 0;
      case SeriesType.maxReps:
        return stats.maxCount.toDouble();
      case SeriesType.avgReps:
        return stats.avgCount;
      case SeriesType.sumVolume:
        return stats.sumVolume ?? 0;
    }
  }

  AggregatorType statAggregator() {
    switch (this) {
      case SeriesType.maxDistance:
        return AggregatorType.max;
      case SeriesType.minTime:
        return AggregatorType.min;
      case SeriesType.sumCalories:
        return AggregatorType.sum;
      case SeriesType.maxEorm:
        return AggregatorType.max;
      case SeriesType.maxWeight:
        return AggregatorType.max;
      case SeriesType.maxReps:
        return AggregatorType.max;
      case SeriesType.avgReps:
        return AggregatorType.avg;
      case SeriesType.sumVolume:
        return AggregatorType.sum;
    }
  }

  bool statYFromZero() => [
        SeriesType.maxDistance,
        SeriesType.maxReps,
        SeriesType.avgReps,
        SeriesType.sumVolume
      ].contains(this);
}

List<SeriesType> getAvailableSeries(MovementDimension dim) {
  switch (dim) {
    case MovementDimension.reps:
      return [
        SeriesType.maxEorm,
        SeriesType.maxWeight,
        SeriesType.maxReps,
        SeriesType.avgReps,
        SeriesType.sumVolume,
      ];
    case MovementDimension.energy:
      return [SeriesType.sumCalories];
    case MovementDimension.distance:
      return [SeriesType.maxDistance];
    case MovementDimension.time:
      return [SeriesType.minTime];
  }
}

class StrengthChart extends StatefulWidget {
  const StrengthChart({
    required this.strengthSessionDescriptions,
    required this.dateFilterState,
    super.key,
  });

  final List<StrengthSessionDescription> strengthSessionDescriptions;
  final DateFilterState dateFilterState;

  @override
  State<StrengthChart> createState() => _StrengthChartState();
}

class _StrengthChartState extends State<StrengthChart> {
  final _logger = Logger('StrengthChart');
  late final availableSeries = getAvailableSeries(movementDimension);
  MovementDimension get movementDimension =>
      widget.strengthSessionDescriptions.first.movement.dimension;
  bool get isTime => movementDimension == MovementDimension.time;

  late SeriesType _selectedSeries = availableSeries.first;
  late List<StrengthSessionStats> _strengthSessionStats;

  @override
  void initState() {
    calculateStats();
    _logger.i("date filter: ${widget.dateFilterState.name}");
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StrengthChart oldWidget) {
    calculateStats();
    super.didUpdateWidget(oldWidget);
  }

  void calculateStats() {
    _strengthSessionStats = widget.strengthSessionDescriptions
        .map(
          (e) => StrengthSessionStats.fromStrengthSets(
            e.session.datetime,
            movementDimension,
            e.sets,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Scrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectionBar(
              onChange: (SeriesType type) =>
                  setState(() => _selectedSeries = type),
              items: availableSeries,
              getLabel: (SeriesType type) => type.toString(),
              selectedItem: _selectedSeries,
            ),
          ),
        ),
        Defaults.sizedBox.vertical.small,
        DateTimeChart(
          chartValues: _strengthSessionStats
              .map(
                (s) => DateTimeChartValue(
                  datetime: s.datetime,
                  value: _selectedSeries.statValue(s),
                ),
              )
              .toList(),
          dateFilterState: widget.dateFilterState,
          yFromZero: _selectedSeries.statYFromZero(),
          aggregatorType: _selectedSeries.statAggregator(),
        ),
      ],
    );
  }
}
