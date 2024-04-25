import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart' hide Position;
import 'package:sport_log/data_provider/data_providers/cardio_data_provider.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/bool_toggle.dart';
import 'package:sport_log/helpers/extensions/date_time_extension.dart';
import 'package:sport_log/helpers/gpx.dart';
import 'package:sport_log/helpers/map_controller.dart';
import 'package:sport_log/helpers/page_return.dart';
import 'package:sport_log/helpers/pointer.dart';
import 'package:sport_log/helpers/search.dart';
import 'package:sport_log/models/cardio/cardio_session.dart';
import 'package:sport_log/models/cardio/cardio_session_description.dart';
import 'package:sport_log/models/cardio/position.dart';
import 'package:sport_log/pages/workout/cardio/cardio_value_unit_description_table.dart';
import 'package:sport_log/pages/workout/cardio/no_track.dart';
import 'package:sport_log/pages/workout/charts/chart_header.dart';
import 'package:sport_log/pages/workout/charts/duration_chart.dart';
import 'package:sport_log/pages/workout/comments_box.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/widgets/app_icons.dart';
import 'package:sport_log/widgets/dialogs/dialogs.dart';
import 'package:sport_log/widgets/map_widgets/mapbox_map_wrapper.dart';
import 'package:sport_log/widgets/provider_consumer.dart';
import 'package:sport_log/widgets/value_unit_description.dart';

class _SimilarSessionAnnotation {
  _SimilarSessionAnnotation({
    required this.trackLine,
    required this.color,
    required this.touchMarker,
  });

  final PolylineAnnotation trackLine;
  final Color color;
  final NullablePointer<CircleAnnotation> touchMarker;
}

class CardioDetailsPage extends StatefulWidget {
  const CardioDetailsPage({required this.cardioSessionDescription, super.key});

  final CardioSessionDescription cardioSessionDescription;

  @override
  State<CardioDetailsPage> createState() => _CardioDetailsPageState();
}

class Split {
  factory Split({
    required int startDistance,
    required int endDistance,
    required Duration startDuration,
    required Duration endDuration,
  }) {
    final distance = endDistance - startDistance;
    final duration = endDuration - startDuration;
    final speed = ((endDistance - startDistance) / 1000) /
        (duration.inMilliseconds / 1000 / 3600);
    final tempo = Duration(
      milliseconds:
          (duration.inMilliseconds / ((endDistance - startDistance) / 1000))
              .round(),
    );
    return Split._(
      startDistance: startDistance,
      endDistance: endDistance,
      startDuration: startDuration,
      endDuration: endDuration,
      distance: distance,
      duration: duration,
      speed: speed,
      tempo: tempo,
    );
  }

  Split._({
    required this.startDistance,
    required this.endDistance,
    required this.startDuration,
    required this.endDuration,
    required this.distance,
    required this.duration,
    required this.speed,
    required this.tempo,
  });

  // distance in m
  final int startDistance;
  // distance in m
  final int endDistance;
  // distance in m
  final int distance;
  final Duration startDuration;
  final Duration endDuration;
  final Duration duration;
  // speed in km/h
  final double speed;
  // tempo per km
  final Duration tempo;
}

class _CardioDetailsPageState extends State<CardioDetailsPage>
    with SingleTickerProviderStateMixin {
  final _dataProvider = CardioSessionDescriptionDataProvider();
  final _sessionDataProvider = CardioSessionDataProvider();

  late CardioSessionDescription _cardioSessionDescription =
      widget.cardioSessionDescription.clone();

  late DurationChartLine _speedLine = _getSpeedLine();
  DurationChartLine _getSpeedLine() => DurationChartLine.fromValues<Position>(
        values: _cardioSessionDescription.cardioSession.track,
        getDuration: (position) => position.time,
        getGroupValue: (positions, _) {
          final km =
              (positions.last.distance - positions.first.distance) / 1000;
          final hour =
              (positions.last.time - positions.first.time).inHourFractions;
          return km / hour;
        },
        lineColor: _speedColor,
        absolute: true,
      );

  late DurationChartLine _elevationLine = _getElevationLine();
  DurationChartLine _getElevationLine() =>
      DurationChartLine.fromValues<Position>(
        values: _cardioSessionDescription.cardioSession.track,
        getDuration: (position) => position.time,
        getGroupValue: (positions, _) =>
            positions.map((p) => p.elevation).average,
        lineColor: _elevationColor,
        absolute: false,
      );

  late DurationChartLine _cadenceLine = _getCadenceLine();
  DurationChartLine _getCadenceLine() => DurationChartLine.fromDurationList(
        durations: _cardioSessionDescription.cardioSession.cadence,
        lineColor: _cadenceColor,
        absolute: true,
      );

  late DurationChartLine _heartRateLine = _getHeartRateLine();
  DurationChartLine _getHeartRateLine() => DurationChartLine.fromDurationList(
        durations: _cardioSessionDescription.cardioSession.heartRate,
        lineColor: _heartRateColor,
        absolute: true,
      );

  List<CardioSession>? _similarSessions;

  List<Split>? _splits;

  MapController? _mapController;
  late final TabController _tabController =
      TabController(length: 4, vsync: this)..addListener(() => setState(() {}));

  final NullablePointer<PolylineAnnotation> _trackLine =
      NullablePointer.nullPointer();
  final NullablePointer<PolylineAnnotation> _routeLine =
      NullablePointer.nullPointer();
  final NullablePointer<CircleAnnotation> _touchMarker =
      NullablePointer.nullPointer();
  final Map<CardioSession, _SimilarSessionAnnotation>
      _similarSessionAnnotations = {};

  Duration? _time;
  double? _speed;
  int? _elevation;
  int? _heartRate;
  int? _cadence;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static const _timeColor = Colors.white;
  static const _speedColor = Colors.blue;
  static const _elevationColor = Color.fromARGB(255, 170, 130, 100);
  static const _heartRateColor = Colors.red;
  static const _cadenceColor = Colors.green;

  Future<void> _onMapCreated(MapController mapController) async {
    _mapController = mapController;
    await _setBoundsAndLines();
  }

  Future<void> _setBoundsAndLines() async {
    await _mapController?.setBoundsFromTracks(
      _cardioSessionDescription.cardioSession.track,
      _cardioSessionDescription.route?.track,
      padded: true,
    );
    await _mapController?.updateRouteLine(
      _routeLine,
      _cardioSessionDescription.route?.track,
    );
    await _mapController?.updateTrackLine(
      _trackLine,
      _cardioSessionDescription.cardioSession.track,
    );
  }

  Future<void> _deleteCardioSession() async {
    final delete = await showDeleteWarningDialog(context, "Cardio Session");
    if (!delete) {
      return;
    }
    final result = await _dataProvider.deleteSingle(_cardioSessionDescription);
    if (mounted) {
      if (result.isSuccess) {
        Navigator.pop(context);
      } else {
        await showMessageDialog(
          context: context,
          title: "Deleting Cardio Session Failed",
          text: result.failure.toString(),
        );
      }
    }
  }

  Future<void> _pushEditPage() async {
    final returnObj = await Navigator.pushNamed(
      context,
      Routes.cardioEdit,
      arguments: _cardioSessionDescription,
    );
    if (returnObj is ReturnObject<CardioSessionDescription> && mounted) {
      if (returnObj.action == ReturnAction.deleted) {
        Navigator.pop(context);
      } else {
        setState(() {
          _cardioSessionDescription = returnObj.payload;
          _similarSessions = null;
          _elevationLine = _getElevationLine();
          _speedLine = _getSpeedLine();
          _cadenceLine = _getCadenceLine();
          _heartRateLine = _getHeartRateLine();
        });
        await _setBoundsAndLines();
      }
    }
  }

  Future<void> _findSimilarSessions() async {
    final similarSessions = await _sessionDataProvider
        .getSimilarCardioSessions(_cardioSessionDescription);
    setState(() {
      _similarSessions = similarSessions;
    });
  }

  void _computeSplits() {
    final track = _cardioSessionDescription.cardioSession.track;
    if (track == null) {
      setState(() {
        _splits = [];
      });
      return;
    }

    const splitDistance = 1000; // m
    final splits = <Split>[];
    var lastDistance = 0;
    var lastTime = Duration.zero;

    for (var i = 0; i < track.length - 1; i++) {
      if ((track[i].distance / splitDistance).floor() <
          (track[i + 1].distance / splitDistance).floor()) {
        final pos1 = track[i];
        final pos2 = track[i + 1];
        final newDistance =
            (pos2.distance / splitDistance).floor() * splitDistance;
        final distanceDiff = pos2.distance - pos1.distance;
        final weight1 = (newDistance - pos1.distance) / distanceDiff;
        final weight2 = (pos2.distance - newDistance) / distanceDiff;
        final newTime = pos1.time * weight1 + pos2.time * weight2;

        splits.add(
          Split(
            startDistance: lastDistance,
            endDistance: newDistance,
            startDuration: lastTime,
            endDuration: newTime,
          ),
        );
        lastDistance = newDistance;
        lastTime = newTime;
      }
    }
    splits.add(
      Split(
        startDistance: lastDistance,
        endDistance: track[track.length - 1].distance.round(),
        startDuration: lastTime,
        endDuration: track[track.length - 1].time,
      ),
    );

    setState(() {
      _splits = splits;
    });
  }

  Future<void> _showSession(CardioSession session) async {
    final color =
        Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1);
    final line = await _mapController?.addLine(session.track!, color);
    if (line != null) {
      _similarSessionAnnotations.putIfAbsent(
        session,
        () => _SimilarSessionAnnotation(
          trackLine: line,
          color: color,
          touchMarker: NullablePointer.nullPointer(),
        ),
      );
      setState(() {});
    }
  }

  void _hideSession(CardioSession session) {
    final line = _similarSessionAnnotations.remove(session)!.trackLine;
    _mapController?.removeLine(line);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_cardioSessionDescription.movement.name),
        actions: [
          if (_cardioSessionDescription.cardioSession.track != null &&
              _cardioSessionDescription.cardioSession.track!.isNotEmpty)
            IconButton(
              onPressed: _exportFile,
              icon: const Icon(AppIcons.download),
            ),
          IconButton(
            onPressed: _deleteCardioSession,
            icon: const Icon(AppIcons.delete),
          ),
          IconButton(
            onPressed: _pushEditPage,
            icon: const Icon(AppIcons.edit),
          ),
        ],
      ),
      body: ProviderConsumer(
        create: (_) => BoolToggle.off(),
        builder: (context, fullscreen, _) => Column(
          children: [
            Expanded(
              child: _cardioSessionDescription.cardioSession.track != null &&
                          _cardioSessionDescription
                              .cardioSession.track!.isNotEmpty ||
                      _cardioSessionDescription.route?.track != null &&
                          _cardioSessionDescription.route!.track!.isNotEmpty
                  ? MapboxMapWrapper(
                      showFullscreenButton: true,
                      showMapStylesButton: true,
                      showSelectRouteButton: false,
                      showSetNorthButton: true,
                      showCurrentLocationButton: false,
                      showCenterLocationButton: false,
                      scaleAtTop: fullscreen.isOff,
                      onFullscreenToggle: fullscreen.setState,
                      onMapCreated: _onMapCreated,
                    )
                  : const NoTrackPlaceholder(),
            ),
            if (fullscreen.isOff)
              TabBar(
                controller: _tabController,
                indicatorColor: Theme.of(context).colorScheme.primary,
                tabs: const [
                  Tab(text: "Stats", icon: Icon(AppIcons.bulletedList)),
                  Tab(text: "Splits", icon: Icon(AppIcons.numberedList)),
                  Tab(text: "Chart", icon: Icon(AppIcons.chart)),
                  Tab(text: "Compare", icon: Icon(AppIcons.compare)),
                ],
              ),
            // TabBarView needs bounded height so different heights for tabs does not work
            if (fullscreen.isOff && _tabController.index == 0)
              Padding(
                padding: Defaults.edgeInsets.normal,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CardioValueUnitDescriptionTable(
                      cardioSessionDescription: _cardioSessionDescription,
                      currentDuration: null,
                    ),
                    if (_cardioSessionDescription.cardioSession.comments !=
                        null) ...[
                      Defaults.sizedBox.vertical.normal,
                      CommentsBox(
                        comments:
                            _cardioSessionDescription.cardioSession.comments!,
                      ),
                    ],
                  ],
                ),
              ),
            if (fullscreen.isOff && _tabController.index == 1)
              Container(
                height: 250,
                padding: Defaults.edgeInsets.normal,
                child: Builder(
                  builder: (context) {
                    // load when compare tab opened for first time
                    if (_splits == null) {
                      // delay until build finished because setState can not be called during build
                      Future.delayed(Duration.zero, _computeSplits);
                    }
                    return _splits == null
                        ? Center(child: CircularProgressIndicator())
                        : _splits!.isEmpty
                            ? Center(
                                child: Text(
                                  "No Splits available.",
                                  style: TextStyle(fontSize: 20),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Table(
                                columnWidths: {
                                  0: IntrinsicColumnWidth(),
                                  1: FlexColumnWidth(),
                                  2: IntrinsicColumnWidth(),
                                  3: FlexColumnWidth(),
                                  4: IntrinsicColumnWidth(),
                                  5: FlexColumnWidth(),
                                  6: IntrinsicColumnWidth(),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text("Distance"),
                                      ),
                                      Container(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text("Duration"),
                                      ),
                                      Container(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text("Speed"),
                                      ),
                                      Container(),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text("Tempo"),
                                      ),
                                    ],
                                  ),
                                  for (final split in _splits!)
                                    TableRow(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "${split.startDistance / 1000} - ${split.endDistance / 1000} km",
                                          ),
                                        ),
                                        Container(),
                                        Text(
                                          "${split.duration.formatM99S} min",
                                        ),
                                        Container(),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "${split.speed.toStringAsFixed(1)} km/h",
                                          ),
                                        ),
                                        Container(),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "${split.tempo.formatM99S} min/km",
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ));
                  },
                ),
              ),
            if (fullscreen.isOff && _tabController.index == 2)
              SizedBox(
                height: 250,
                child: _cardioSessionDescription.cardioSession.track != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChartHeader(
                            fields: [
                              (
                                _time != null ? _time!.formatHms : "Time",
                                _timeColor
                              ),
                              (
                                _speed != null
                                    ? "${_speed?.toStringAsFixed(1)} km/h"
                                    : "Speed",
                                _speedColor
                              ),
                              (
                                _elevation != null
                                    ? "$_elevation m"
                                    : "Elevation",
                                _elevationColor
                              ),
                              (
                                _heartRate != null
                                    ? "$_heartRate bpm"
                                    : "Heart Rate",
                                _heartRateColor
                              ),
                              (
                                _cadence != null ? "$_cadence rpm" : "Cadence",
                                _cadenceColor
                              ),
                            ],
                          ),
                          Expanded(
                            child: DurationChart(
                              chartLines: [
                                _speedLine,
                                _elevationLine,
                                _cadenceLine,
                                _heartRateLine,
                              ],
                              touchCallback: _touchCallback,
                            ),
                          ),
                        ],
                      )
                    : const NoTrackPlaceholder(),
              ),
            if (fullscreen.isOff && _tabController.index == 3)
              Container(
                height: 250,
                padding: Defaults.edgeInsets.normal,
                child: CustomScrollView(
                  slivers: [
                    SliverList.list(
                      children: [
                        _SimilarCardioSessionCard.current(
                          session: _cardioSessionDescription.cardioSession,
                        ),
                        Defaults.sizedBox.vertical.normal,
                      ],
                    ),
                    Builder(
                      builder: (context) {
                        // load when compare tab opened for first time
                        if (_similarSessions == null) {
                          _findSimilarSessions();
                        }
                        return _similarSessions == null
                            ? const SliverToBoxAdapter(
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : _similarSessions!.isEmpty
                                ? const SliverToBoxAdapter(
                                    child: Center(
                                      child: Text(
                                        "No similar Cardio Sessions found.",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  )
                                : SliverList.separated(
                                    itemCount: _similarSessions!.length,
                                    itemBuilder: (_, index) {
                                      final session = _similarSessions![index];
                                      return _SimilarCardioSessionCard(
                                        session: session,
                                        sessionAnnotation:
                                            _similarSessionAnnotations[session],
                                        onShow: () => _showSession(session),
                                        onHide: () => _hideSession(session),
                                      );
                                    },
                                    separatorBuilder: (_, __) =>
                                        Defaults.sizedBox.vertical.normal,
                                  );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportFile() async {
    final file = await saveTrackAsGpx(
      _cardioSessionDescription.cardioSession.track ?? [],
      startTime: _cardioSessionDescription.cardioSession.datetime,
    );
    if (mounted && file != null) {
      await showMessageDialog(
        context: context,
        title: "Track Exported",
        text: "file: $file",
      );
    }
  }

  // ignore: long-method
  Future<void> _touchCallback(Duration? touchDuration) async {
    if (touchDuration != null) {
      final session = _cardioSessionDescription.cardioSession;
      final track = session.track;

      final totalDuration = [
        track?.lastOrNull?.time,
        session.heartRate?.lastOrNull,
        session.cadence?.lastOrNull,
      ].whereNotNull().maxOrNull;
      if (totalDuration == null) {
        // this should not happen because if there is no data the chart is also not shown
        return;
      }
      final startDuration =
          DurationChartLine.groupFunction(touchDuration, totalDuration);

      final Position? pos;
      if (track != null) {
        final index = binarySearchClosest(
          track,
          (Position pos) => pos.time.inMilliseconds,
          touchDuration.inMilliseconds,
        );
        pos = index != null ? track[index] : null;
      } else {
        pos = null;
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _time = touchDuration;
        _speed = _speedLine.chartValues
            .firstWhereOrNull((dcv) => dcv.duration == startDuration)
            ?.rawValue;
        _elevation = _elevationLine.chartValues
            .firstWhereOrNull((dcv) => dcv.duration == startDuration)
            ?.rawValue
            .round();
        _cadence = _cadenceLine.chartValues
            .firstWhereOrNull((dcv) => dcv.duration == startDuration)
            ?.rawValue
            .round();
        _heartRate = _heartRateLine.chartValues
            .firstWhereOrNull((dcv) => dcv.duration == startDuration)
            ?.rawValue
            .round();
      });
      await _mapController?.updateTrackMarker(_touchMarker, pos?.latLng);
      for (final sessionTouchMarker in _similarSessionAnnotations.entries) {
        final session = sessionTouchMarker.key;
        final sessionAnnotation = sessionTouchMarker.value;
        final Position? pos;
        if (session.track != null) {
          final index = binarySearchLargestLE(
            session.track!,
            (Position pos) => pos.time,
            touchDuration,
          );
          pos = index != null ? session.track![index] : null;
        } else {
          pos = null;
        }
        await _mapController?.updateMarker(
          sessionAnnotation.touchMarker,
          pos?.latLng,
          sessionAnnotation.color,
        );
      }
    } else {
      setState(() {
        _time = null;
        _speed = null;
        _elevation = null;
        _heartRate = null;
        _cadence = null;
      });
      await _mapController?.updateTrackMarker(_touchMarker, null);
      for (final sessionTouchMarker in _similarSessionAnnotations.entries) {
        final sessionAnnotation = sessionTouchMarker.value;
        await _mapController?.updateMarker(
          sessionAnnotation.touchMarker,
          null,
          sessionAnnotation.color,
        );
      }
    }
  }
}

class _SimilarCardioSessionCard extends StatelessWidget {
  const _SimilarCardioSessionCard({
    required this.session,
    required this.sessionAnnotation,
    required void Function() this.onShow,
    required void Function() this.onHide,
  }) : isCurrent = false;

  const _SimilarCardioSessionCard.current({
    required this.session,
  })  : sessionAnnotation = null,
        onShow = null,
        onHide = null,
        isCurrent = true;

  final CardioSession session;
  final _SimilarSessionAnnotation? sessionAnnotation;
  final void Function()? onShow;
  final void Function()? onHide;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: Defaults.edgeInsets.normal,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.datetime.humanDateTime,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ValueUnitDescription.timeSmall(session.time),
                      ValueUnitDescription.distanceSmall(session.distance),
                      ValueUnitDescription.speedSmall(session.speed),
                    ],
                  ),
                ],
              ),
            ),
            Defaults.sizedBox.horizontal.big,
            ...isCurrent
                ? [
                    Icon(AppIcons.route, color: Defaults.mapbox.trackLineColor),
                    const SizedBox(width: 48),
                  ]
                : sessionAnnotation != null
                    ? [
                        Icon(AppIcons.route, color: sessionAnnotation!.color),
                        IconButton(
                          onPressed: onHide,
                          icon: const Icon(AppIcons.remove),
                        ),
                      ]
                    : [
                        const SizedBox(width: 24),
                        IconButton(
                          onPressed: onShow,
                          icon: const Icon(AppIcons.add),
                        ),
                      ],
          ],
        ),
      ),
    );
  }
}
