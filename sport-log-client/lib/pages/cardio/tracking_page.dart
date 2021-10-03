import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:flutter/material.dart';
import 'package:sport_log/data_provider/user_state.dart';
import 'dart:async';
import 'package:sport_log/helpers/id_generation.dart';
import 'package:sport_log/helpers/logger.dart';
import 'package:sport_log/helpers/secrets.dart';
import 'package:sport_log/helpers/theme.dart';
import 'package:sport_log/models/all.dart';
import 'package:sport_log/widgets/movement_picker.dart';

enum TrackingMode { notStarted, tracking, paused, stopped }

class CardioTrackingPage extends StatefulWidget {
  const CardioTrackingPage({Key? key}) : super(key: key);

  @override
  State<CardioTrackingPage> createState() => CardioTrackingPageState();
}

class StepTime {
  final int seconds;
  final int steps;

  StepTime(this.seconds, this.steps);
}

class CardioTrackingPageState extends State<CardioTrackingPage> {
  final _logger = Logger('CardioTrackingPage');

  final String _token = Secrets.mapboxAccessToken;
  final String _style = 'mapbox://styles/mapbox/outdoors-v11';

  final List<Position> _positions = [];
  double _ascent = 0;
  double _descent = 0;
  double? _lastElevation;

  final List<StepTime> _stepTimes = [];
  int _stepRate = 0;

  late DateTime _startTime;
  DateTime? _pauseStopTime;
  int _seconds = 0;
  String _time = "00:00:00";

  late Movement _movement;

  Line? _line;
  List<Circle>? _circles;

  TrackingMode _trackingMode = TrackingMode.notStarted;

  String _locationInfo = "null";
  String _stepInfo = "null";

  late MapboxMapController _mapController;

  void _updateData() {
    Duration duration = _trackingMode == TrackingMode.tracking
        ? Duration(seconds: _seconds) +
            DateTime.now().difference(_pauseStopTime!)
        : Duration(seconds: _seconds);
    setState(() {
      _time = duration.toString().split('.').first.padLeft(8, '0');

      _stepRate = duration.inSeconds > 0 && _stepTimes.isNotEmpty
          ? ((_stepTimes.last.steps - _stepTimes.first.steps) /
                  duration.inSeconds *
                  60)
              .round()
          : 0;
      _stepInfo =
          "steps: ${_stepTimes.last.steps - _stepTimes.first.steps}\ntime: ${_stepTimes.last.seconds}\nstep rate: $_stepRate";
    });
    _logger.i(_stepInfo);
  }

  void _saveCardioSession() {
    CardioSession(
      id: randomId(),
      userId: UserState.instance.currentUser!.id,
      movementId: _movement.id,
      cardioType: CardioType.training, //TODO
      datetime: _startTime,
      distance: 0, //TODO
      ascent: _ascent.round(),
      descent: _descent.round(),
      time: _seconds,
      calories: null,
      track: _positions,
      avgCadence: null, //TODO
      cadence: null, //TODO
      avgHeartRate: null,
      heartRate: null,
      routeId: null,
      comments: null, //TODO
      deleted: false,
    );
  }

  void _onStepCountUpdate(StepCount stepCountEvent) {
    // TODO ignore steps when paused or not started
    _stepTimes.add(StepTime(
        stepCountEvent.timeStamp.millisecondsSinceEpoch ~/ 1000,
        stepCountEvent.steps));
  }

  void _onStepCountError(Object error) {
    _logger.i(error);
  }

  void _startStepCountStream() {
    Stream<StepCount> _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCountUpdate).onError(_onStepCountError);
  }

  Future<void> _startLocationStream() async {
    Location location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.changeSettings(accuracy: LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen(_onLocationUpdate);
  }

  void _onLocationUpdate(LocationData location) async {
    setState(() {
      _locationInfo = """location provider: ${location.provider}
accuracy: ${location.accuracy?.toInt()} m
time: ${location.time! ~/ 1000} s
satelites: ${location.satelliteNumber}""";
    });

    _logger.i(_locationInfo);

    LatLng latLng = LatLng(location.latitude, location.longitude);

    await _mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );

    if (_circles != null) {
      await _mapController.removeCircles(_circles);
    }
    _circles = await _mapController.addCircles([
      CircleOptions(
        circleRadius: 8.0,
        circleColor: '#0060a0',
        circleOpacity: 0.5,
        geometry: latLng,
        draggable: false,
      ),
      CircleOptions(
        circleRadius: 20.0,
        circleColor: '#0060a0',
        circleOpacity: 0.3,
        geometry: latLng,
        draggable: false,
      ),
    ]);

    if (_trackingMode == TrackingMode.tracking) {
      setState(() {
        _lastElevation ??= location.altitude;
        double elevationDifference = location.altitude! - _lastElevation!;
        if (elevationDifference > 0) {
          _ascent += elevationDifference;
        } else {
          _descent -= elevationDifference;
        }
        _lastElevation = location.altitude;
      });

      _positions.add(Position(
          latitude: location.latitude!,
          longitude: location.longitude!,
          elevation: location.altitude!.toInt(),
          distance: 0,
          time: DateTime.now()
              .difference(
                  DateTime.fromMicrosecondsSinceEpoch(location.time!.toInt()))
              .inSeconds));
      _extendLine(_mapController, latLng);
    }
  }

  void _extendLine(MapboxMapController controller, LatLng location) async {
    _line ??= await controller.addLine(
        const LineOptions(lineColor: "red", lineWidth: 3, geometry: []));
    await controller.updateLine(
        _line,
        LineOptions(
            geometry: _positions
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList()));
  }

  Widget _buildCard(String title, String subtitle) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.only(top: 2),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 25),
        ),
        subtitle: Text(
          subtitle,
          textAlign: TextAlign.center,
        ),
        dense: true,
      ),
    );
  }

  List<Widget> _buildButtons() {
    if (_trackingMode == TrackingMode.tracking) {
      return [
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red[400]),
                onPressed: () {
                  setState(() {
                    _trackingMode = TrackingMode.paused;
                  });
                  _seconds +=
                      DateTime.now().difference(_pauseStopTime!).inSeconds;
                },
                child: const Text("pause"))),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red[400]),
                onPressed: () {
                  setState(() {
                    _trackingMode = TrackingMode.stopped;
                  });
                  _saveCardioSession();
                },
                child: const Text("stop"))),
      ];
    } else if (_trackingMode == TrackingMode.paused) {
      return [
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green[400]),
                onPressed: () {
                  setState(() {
                    _trackingMode = TrackingMode.tracking;
                  });
                  _pauseStopTime = DateTime.now();
                },
                child: const Text("continue"))),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red[400]),
                onPressed: () {
                  setState(() {
                    _trackingMode = TrackingMode.stopped;
                  });
                  _saveCardioSession();
                  _seconds +=
                      DateTime.now().difference(_pauseStopTime!).inSeconds;
                },
                child: const Text("stop"))),
      ];
    } else {
      return [
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.green[400]),
                onPressed: () {
                  setState(() {
                    _trackingMode = TrackingMode.tracking;
                  });
                  _startTime = DateTime.now();
                  _pauseStopTime = DateTime.now();
                },
                child: const Text("start"))),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.red[400]),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("cancel"))),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [
          Card(
              margin: const EdgeInsets.only(top: 25, bottom: 5),
              child: Text(_locationInfo)),
          Card(
              margin: const EdgeInsets.only(top: 25, bottom: 5),
              child: Text(_stepInfo)),
        ],
      ),
      Expanded(
          child: MapboxMap(
        accessToken: _token,
        styleString: _style,
        initialCameraPosition: const CameraPosition(
          zoom: 14.0,
          target: LatLng(47.27, 11.33),
        ),
        compassEnabled: true,
        compassViewPosition: CompassViewPosition.TopRight,
        onMapCreated: (MapboxMapController controller) =>
            _mapController = controller,
        onStyleLoadedCallback: () async {
          await _startLocationStream();
          _startStepCountStream();
        },
      )),
      Container(
          padding: const EdgeInsets.only(top: 5),
          color: onPrimaryColorOf(context),
          child: Table(
            children: [
              TableRow(children: [
                _buildCard(_time, "time"),
                _buildCard("6.17 km", "distance"),
              ]),
              TableRow(children: [
                _buildCard("10.7 km/h", "speed"),
                _buildCard("$_stepRate", "step rate"),
              ]),
              TableRow(children: [
                _buildCard("${_ascent.round()} m", "ascent"),
                _buildCard("${_descent.round()} m", "descent"),
              ]),
            ],
          )),
      Container(
          color: onPrimaryColorOf(context),
          padding: const EdgeInsets.all(5),
          child: Row(
            children: _buildButtons(),
          ))
    ]);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      _movement = await showMovementPickerDialog(context,
          dismissable: false, cardioOnly: true) as Movement;
    });
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateData());
  }
}
