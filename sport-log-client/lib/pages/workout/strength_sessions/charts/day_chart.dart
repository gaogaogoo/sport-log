import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sport_log/data_provider/data_providers/strength_data_provider.dart';
import 'package:sport_log/helpers/extensions/iterable_extension.dart';
import 'package:sport_log/helpers/formatting.dart';
import 'package:sport_log/helpers/theme.dart';
import 'package:sport_log/models/movement/movement.dart';
import 'package:sport_log/models/strength/all.dart';
import 'package:sport_log/helpers/extensions/date_time_extension.dart';

import 'helpers.dart';
import 'series_type.dart';

/// needs to wrapped into something that constrains the size (e. g. an [AspectRatio])
class DayChart extends StatefulWidget {
  DayChart({
    Key? key,
    required this.series,
    required DateTime date,
    required this.movement,
  })  : date = date.beginningOfDay(),
        super(key: key);

  final SeriesType series;
  final DateTime date;
  final Movement movement;

  @override
  State<DayChart> createState() => _DayChartState();
}

class _DayChartState extends State<DayChart> {
  final _dataProvider = StrengthSessionDescriptionDataProvider.instance;

  List<StrengthSet> _sets = [];

  @override
  void initState() {
    super.initState();
    _dataProvider.addListener(update);
    update();
  }

  void update() {
    _dataProvider
        .getSetsOnDay(
      movementId: widget.movement.id,
      date: widget.date,
    )
        .then((sets) {
      if (mounted) {
        setState(() => _sets = sets);
      }
    });
  }

  @override
  void didUpdateWidget(DayChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // ignore a change in series type
    if (oldWidget.movement != widget.movement ||
        oldWidget.date != widget.date) {
      update();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTime = widget.movement.dimension == MovementDimension.time;
    final getValue = setAccessor(widget.series);
    final color = primaryColorOf(context);
    return BarChart(BarChartData(
      barGroups: _sets
          .mapIndexed((set, index) => BarChartGroupData(x: index, barRods: [
                BarChartRodData(
                  y: getValue(set),
                  colors: [color],
                )
              ]))
          .toList(),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        leftTitles: SideTitles(
          interval: null,
          showTitles: true,
          reservedSize: isTime ? 60 : 40,
          getTitles: isTime
              ? (value) =>
                  formatDurationShort(Duration(milliseconds: value.round()))
              : null,
        ),
        bottomTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
      ),
      gridData: FlGridData(
        getDrawingHorizontalLine: gridLineDrawer(context),
        getDrawingVerticalLine: gridLineDrawer(context),
      ),
    ));
  }

  @override
  void dispose() {
    _dataProvider.removeListener(update);
    super.dispose();
  }
}
