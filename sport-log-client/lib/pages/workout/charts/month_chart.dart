import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sport_log/helpers/extensions/iterable_extension.dart';
import 'package:sport_log/helpers/extensions/date_time_extension.dart';
import 'package:sport_log/pages/workout/charts/chart.dart';

/// needs to wrapped into something that constrains the size (e. g. an [AspectRatio])
class MonthChart extends StatelessWidget {
  const MonthChart({
    required this.chartValues,
    required this.yFromZero,
    required this.isTime,
    Key? key,
  }) : super(key: key);

  final List<ChartValue> chartValues;
  final bool yFromZero;
  final bool isTime;

  @override
  Widget build(BuildContext context) {
    if (chartValues.isEmpty) {
      return const CircularProgressIndicator();
    } else {
      double minY = yFromZero
          ? 0.0
          : chartValues.map((v) => v.value).min.floor().toDouble();
      double maxY = chartValues.map((v) => v.value).max.ceil().toDouble();
      if (maxY == minY) {
        maxY += 1;
        minY -= 1;
      }
      final start = chartValues.first.datetime.beginningOfMonth();

      return LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: chartValues
                  .map(
                    (v) => FlSpot(
                      v.datetime.difference(start).inDays + 1,
                      v.value,
                    ),
                  )
                  .toList(),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, _) => value % 2 == 0
                    ? Text(value.round().toString())
                    : const Text(""),
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: isTime ? 60 : 30,
                getTitlesWidget: isTime
                    ? (value, _) => Text(
                          Duration(milliseconds: value.round())
                              .formatTimeWithMillis,
                        )
                    : null,
              ),
            ),
          ),
          gridData: FlGridData(
            verticalInterval: 1,
            getDrawingHorizontalLine: gridLineDrawer(context),
            getDrawingVerticalLine: gridLineDrawer(context),
          ),
          minX: 1.0,
          maxX: start.numDaysInMonth.toDouble(),
          minY: minY,
          maxY: maxY,
          borderData: FlBorderData(show: false),
        ),
      );
    }
  }
}
