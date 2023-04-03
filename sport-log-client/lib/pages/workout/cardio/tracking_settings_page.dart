import 'package:flutter/material.dart' hide Route;
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/heart_rate_utils.dart';
import 'package:sport_log/models/all.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/widgets/app_icons.dart';
import 'package:sport_log/widgets/input_fields/edit_tile.dart';
import 'package:sport_log/widgets/input_fields/int_input.dart';
import 'package:sport_log/widgets/picker/picker.dart';
import 'package:sport_log/widgets/provider_consumer.dart';
import 'package:sport_log/widgets/snackbar.dart';

class CardioTrackingSettingsPage extends StatefulWidget {
  const CardioTrackingSettingsPage({super.key});

  @override
  State<CardioTrackingSettingsPage> createState() =>
      CardioTrackingSettingsPageState();
}

class CardioTrackingSettingsPageState
    extends State<CardioTrackingSettingsPage> {
  Movement? _movement;
  CardioType _cardioType = CardioType.training;
  Route? _route;
  int? _routeAlarmDistance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracking Settings"),
      ),
      body: Container(
        padding: Defaults.edgeInsets.normal,
        child: ProviderConsumer<HeartRateUtils>(
          create: (_) => HeartRateUtils(),
          builder: (_, heartRateUtils, __) => Column(
            children: [
              EditTile(
                leading: AppIcons.exercise,
                caption: "Movement",
                child: Text(_movement?.name ?? ""),
                onTap: () async {
                  final movement = await showMovementPicker(
                    selectedMovement: _movement,
                    cardioOnly: true,
                    distanceOnly: true,
                    context: context,
                  );
                  if (mounted && movement != null) {
                    setState(() => _movement = movement);
                  }
                },
              ),
              EditTile(
                leading: AppIcons.sports,
                caption: "Cardio Type",
                child: Text(_cardioType.name),
                onTap: () async {
                  final cardioType = await showCardioTypePicker(
                    selectedCardioType: _cardioType,
                    context: context,
                  );
                  if (mounted && cardioType != null) {
                    setState(() => _cardioType = cardioType);
                  }
                },
              ),
              EditTile(
                leading: AppIcons.map,
                caption: "Route to follow",
                child: Text(_route?.name ?? "No Route"),
                onTap: () async {
                  final route = await showRoutePicker(
                    selectedRoute: _route,
                    context: context,
                  );
                  if (mounted) {
                    setState(() {
                      if (route == null) {
                        return;
                      } else if (route.id == _route?.id) {
                        _route = null;
                      } else {
                        _route = route;
                      }
                    });
                  }
                },
              ),
              if (_route != null)
                Row(
                  children: [
                    const SizedBox(width: 24 + 15), // 24 icon + 15 SizedBox
                    EditTile(
                      leading: null,
                      caption: "Alarm when off Route",
                      shrinkWidth: true,
                      child: SizedBox(
                        height: 29, // make it fit into EditTile
                        width: 34, // remove left padding
                        child: Switch(
                          value: _routeAlarmDistance != null,
                          onChanged: (alarm) {
                            setState(() {
                              _routeAlarmDistance = alarm ? 50 : null;
                            });
                          },
                        ),
                      ),
                    ),
                    Defaults.sizedBox.horizontal.big,
                    if (_routeAlarmDistance != null)
                      EditTile(
                        leading: null,
                        caption: "Maximal Distance",
                        shrinkWidth: true,
                        child: IntInput(
                          onUpdate: (alarm) => setState(() {
                            _routeAlarmDistance = alarm;
                          }),
                          initialValue: 50,
                          minValue: 20,
                          maxValue: null,
                        ),
                      ),
                  ],
                ),
              heartRateUtils.devices.isEmpty
                  ? EditTile(
                      leading: AppIcons.heartbeat,
                      caption: "Heart Rate Monitor",
                      child: Text(
                        heartRateUtils.isSearching
                            ? "Searching..."
                            : "No Device",
                      ),
                      onTap: () async {
                        await heartRateUtils.searchDevices();
                        if (mounted && heartRateUtils.devices.isEmpty) {
                          showSimpleToast(context, "No devices found.");
                        }
                      },
                    )
                  : EditTile(
                      leading: AppIcons.heartbeat,
                      caption: "Heart Rate Monitors",
                      onCancel: heartRateUtils.reset,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: heartRateUtils.deviceId,
                          items: heartRateUtils.devices.entries
                              .map(
                                (d) => DropdownMenuItem(
                                  value: d.value,
                                  child: Text(d.key),
                                ),
                              )
                              .toList(),
                          onChanged: (deviceId) {
                            if (deviceId != null) {
                              heartRateUtils.deviceId = deviceId;
                            }
                          },
                          isDense: true,
                        ),
                      ),
                    ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _movement != null
                      ? () => Navigator.pushNamed(
                            context,
                            Routes.tracking,
                            arguments: [
                              _movement,
                              _cardioType,
                              _route,
                              _routeAlarmDistance,
                              heartRateUtils.deviceId != null
                                  ? heartRateUtils
                                  : null,
                            ],
                          )
                      : null,
                  child: const Text("OK"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
