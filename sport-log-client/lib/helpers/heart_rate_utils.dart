import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:polar/polar.dart';
import 'package:sport_log/helpers/location_utils.dart';
import 'package:sport_log/widgets/dialogs/system_settings_dialog.dart';

class HeartRateUtils extends ChangeNotifier {
  HeartRateUtils(void Function(PolarHeartRateEvent) onHeartRateEvent)
      : _onHeartRateEvent = onHeartRateEvent;

  HeartRateUtils.consumer();

  static final _polar = Polar();
  static final FlutterBlue _flutterBlue = FlutterBlue.instance;

  static const _searchDuration = Duration(seconds: 10);

  bool _isSearching = false;
  bool get isSearching => _isSearching;
  Map<String, String> _devices = {};
  Map<String, String> get devices => _devices;
  String? deviceId;
  void Function(PolarHeartRateEvent)? _onHeartRateEvent;

  StreamSubscription? _heartRateSubscription;
  StreamSubscription? _batterySubscription;

  int? _hr;
  int? get hr => _hr;
  int? _battery;
  int? get battery => _battery;

  @override
  void dispose() {
    stopHeartRateStream(dispose: true);
    super.dispose();
  }

  Future<void> searchDevices() async {
    _isSearching = true;
    notifyListeners();

    await stopHeartRateStream(dispose: false);

    while (!await _flutterBlue.isOn) {
      final ignore = await showSystemSettingsDialog(
        text:
            "In order to discover heart rate monitors bluetooth must be enabled.",
      );
      if (ignore) {
        return;
      }
      await AppSettings.openBluetoothSettings();
    }

    if (!await LocationUtils.enableLocation()) {
      return;
    }

    _devices = {
      //await for (final d in _polar.searchForDevice().timeout(
      //_searchDuration,
      //onTimeout: (sink) => sink.close(),
      //))
      //d.name: d.deviceId.toString()
      await for (final d in _flutterBlue
          .scan(timeout: _searchDuration)
          .where((d) => d.device.name.toLowerCase().contains("polar h")))
        d.device.name: d.device.id.toString()
    };

    deviceId = devices.values.firstOrNull;
    _isSearching = false;
    notifyListeners();
  }

  void reset() {
    _devices = {};
    deviceId = null;
    notifyListeners();
  }

  bool get canStartStream => deviceId != null;

  Future<bool> startHeartRateStream() async {
    if (deviceId == null) {
      return false;
    }

    if (_heartRateSubscription == null) {
      _heartRateSubscription = _polar.heartRateStream.listen((event) {
        _hr = event.data.hr;
        _onHeartRateEvent?.call(event);
        notifyListeners();
      });
      _batterySubscription = _polar.batteryLevelStream.listen((event) {
        _battery = event.level;
        notifyListeners();
      });
      await _polar.connectToDevice(deviceId!);
      notifyListeners();
    }
    return true;
  }

  Future<void> stopHeartRateStream({required bool dispose}) async {
    await _heartRateSubscription?.cancel();
    _heartRateSubscription = null;
    await _batterySubscription?.cancel();
    _batterySubscription = null;
    if (deviceId != null) {
      await _polar.disconnectFromDevice(deviceId!);
    }
    deviceId = null;
    _hr = null;
    _battery = null;
    if (!dispose) {
      notifyListeners();
    }
  }

  bool get isActive => _heartRateSubscription != null;
}
