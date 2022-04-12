import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sport_log/config.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/logger.dart';
import 'package:sport_log/helpers/map_utils.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/settings.dart';
import 'package:sport_log/widgets/app_icons.dart';
import 'package:sport_log/widgets/main_drawer.dart';
import 'package:sport_log/widgets/dialogs/message_dialog.dart';
import 'package:sport_log/widgets/never_pop.dart';

class OfflineMapsPage extends StatefulWidget {
  const OfflineMapsPage({Key? key}) : super(key: key);

  @override
  State<OfflineMapsPage> createState() => OfflineMapsPageState();
}

class OfflineMapsPageState extends State<OfflineMapsPage> {
  final _logger = Logger('OfflineMapsPage');

  late MapboxMapController _mapController;

  LatLng? _point1;
  LatLng? _point2;
  Circle? _point1Marker;
  Circle? _point2Marker;
  Line? _boundingBoxLine;

  double? _progress;

  @override
  void dispose() {
    if (_mapController.cameraPosition != null) {
      Settings.lastMapPosition = _mapController.cameraPosition!;
    }
    super.dispose();
  }

  void _onMapDownload(DownloadRegionStatus status) {
    if (status.runtimeType == Success) {
      setState(() {
        _progress = null;
      });
      showMessageDialog(context: context, text: "Download Successful");
    } else if (status.runtimeType == InProgress) {
      setState(() {
        _progress = (status as InProgress).progress;
      });
    } else if (status.runtimeType == Error) {
      setState(() {
        _progress = null;
      });
      showMessageDialog(context: context, text: "Download Failed");
    }
  }

  void _downloadMap() {
    if (_point1 != null && _point2 != null) {
      LatLng northeast = LatLng(
        max(_point1!.latitude, _point2!.latitude),
        max(_point1!.longitude, _point2!.longitude),
      );
      LatLng southwest = LatLng(
        min(_point1!.latitude, _point2!.latitude),
        min(_point1!.longitude, _point2!.longitude),
      );
      _logger.i("northwest: $northeast\n southeast: $southwest");
      downloadOfflineRegion(
        OfflineRegionDefinition(
          bounds: LatLngBounds(
            northeast: northeast,
            southwest: southwest,
          ),
          minZoom: 0,
          maxZoom: 16,
          mapStyleUrl: Defaults.mapbox.style.outdoor,
        ),
        onEvent: _onMapDownload,
        accessToken: Config.instance.accessToken,
      );
    } else {
      showMessageDialog(
        context: context,
        text:
            "Please set two points to form a BoundingBox by long pressing on the map.",
      );
    }
  }

  Future<void> _updatePoint1(LatLng? latLng) async {
    setState(() {
      _point1 = latLng;
    });
    if (_point1Marker != null) {
      await _mapController.removeCircle(_point1Marker!);
      _point1Marker = null;
    }
    if (_point1 != null) {
      _point1Marker = await _mapController.addLocationMarker(_point1!);
    }
  }

  Future<void> _updatePoint2(LatLng? latLng) async {
    setState(() {
      _point2 = latLng;
    });
    if (_point2Marker != null) {
      await _mapController.removeCircle(_point2Marker!);
      _point2Marker = null;
    }
    if (_boundingBoxLine != null) {
      await _mapController.removeLine(_boundingBoxLine!);
      _boundingBoxLine = null;
    }
    if (_point2 != null) {
      _point2Marker = await _mapController.addLocationMarker(_point2!);
      _boundingBoxLine = await _mapController.addLine(
        LineOptions(
          lineColor: Defaults.mapbox.trackLineColor,
          lineWidth: 2,
          geometry: [
            LatLng(_point1!.latitude, _point1!.longitude),
            LatLng(_point1!.latitude, _point2!.longitude),
            LatLng(_point2!.latitude, _point2!.longitude),
            LatLng(_point2!.latitude, _point1!.longitude),
            LatLng(_point1!.latitude, _point1!.longitude)
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeverPop(
      child: Scaffold(
        appBar: AppBar(title: const Text("Offline Maps")),
        drawer: const MainDrawer(selectedRoute: Routes.offlineMaps),
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 400,
                  child: MapboxMap(
                    accessToken: Config.instance.accessToken,
                    styleString: Defaults.mapbox.style.outdoor,
                    initialCameraPosition: Settings.lastMapPosition,
                    trackCameraPosition: true,
                    onMapCreated: (MapboxMapController controller) =>
                        _mapController = controller,
                    onMapLongClick: (_, latLng) => _point1 == null
                        ? _updatePoint1(latLng)
                        : _updatePoint2(latLng),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton.small(
                    heroTag: null,
                    child: const Icon(AppIcons.undo),
                    onPressed: () => _point2 != null
                        ? _updatePoint2(null)
                        : _updatePoint1(null),
                  ),
                )
              ],
            ),
            Container(
              padding: Defaults.edgeInsets.normal,
              child: _progress == null
                  ? ElevatedButton(
                      onPressed: _downloadMap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(AppIcons.download),
                          Text("download")
                        ],
                      ),
                    )
                  : LinearProgressIndicator(
                      value: _progress ?? 0.3,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
