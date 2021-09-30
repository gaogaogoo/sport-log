import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sport_log/helpers/logger.dart';
import 'package:sport_log/helpers/secrets.dart';
import 'package:sport_log/helpers/theme.dart';

class RoutePlanningPage extends StatefulWidget {
  const RoutePlanningPage({Key? key}) : super(key: key);

  @override
  State<RoutePlanningPage> createState() => RoutePlanningPageState();
}

class RoutePlanningPageState extends State<RoutePlanningPage> {
  final _logger = Logger('RoutePlanningPage');

  final String _token = Secrets.mapboxAccessToken;
  final String _style = 'mapbox://styles/mapbox/outdoors-v11';

  List<LatLng> _locations = [];
  Line? _line;
  List<Circle> _circles = [];
  List<Symbol> _symbols = [];

  bool _listExpanded = false;

  late MapboxMapController _mapController;

  void _addPoint(LatLng latLng, int number) async {
    _symbols.add(await _mapController.addSymbol(SymbolOptions(
        textField: "$number",
        textOffset: const Offset(0, 1),
        geometry: latLng)));
    _circles.add(await _mapController.addCircle(
      CircleOptions(
        circleRadius: 8.0,
        circleColor: '#0060a0',
        circleOpacity: 0.5,
        geometry: latLng,
        draggable: false,
      ),
    ));
  }

  void _extendLine(LatLng location) async {
    setState(() {
      _locations.add(location);
    });
    _addPoint(location, _locations.length);
    _line ??= await _mapController.addLine(
        const LineOptions(lineColor: "red", lineWidth: 3, geometry: []));
    await _mapController.updateLine(_line, LineOptions(geometry: _locations));
  }

  void _removePoint(int index) async {
    setState(() {
      _locations.removeAt(index);
    });
    await _mapController.removeCircles(_circles);
    _circles = [];
    await _mapController.removeSymbols(_symbols);
    _symbols = [];
    _locations.asMap().forEach((index, latLng) {
      _addPoint(latLng, index + 1);
    });
    await _mapController.updateLine(_line, LineOptions(geometry: _locations));
  }

  void _switchPoints(int oldIndex, int newIndex) async {
    setState(() {
      _logger.i("old: $oldIndex, new: $newIndex");
      if (oldIndex < newIndex - 1) {
        LatLng location = _locations.removeAt(oldIndex);
        if (newIndex - 1 == _locations.length) {
          _locations.add(location);
        } else {
          _locations.insert(newIndex - 1, location);
        }
      } else if (oldIndex > newIndex) {
        _locations.insert(newIndex, _locations.removeAt(oldIndex));
      }
    });

    await _mapController.removeCircles(_circles);
    _circles = [];
    await _mapController.removeSymbols(_symbols);
    _symbols = [];
    _locations.asMap().forEach((index, latLng) {
      _addPoint(latLng, index + 1);
    });
    await _mapController.updateLine(_line, LineOptions(geometry: _locations));
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

  Widget _buildDraggableList() {
    List<Widget> listElements = [];

    Widget _buildDragTarget(int index) {
      return DragTarget(
          onWillAccept: (value) => true,
          onAccept: (value) => _switchPoints(value as int, index),
          builder: (context, candidates, reject) {
            if (candidates.isNotEmpty) {
              int index = candidates[0] as int;
              return ListTile(
                leading: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: const Icon(
                    Icons.add_rounded,
                  ),
                ),
                title: Text(
                  "${index + 1}",
                  style: const TextStyle(fontSize: 20),
                ),
                dense: true,
              );
            } else {
              return const Divider();
            }
          });
    }

    for (int index = 0; index < _locations.length; index++) {
      listElements.add(_buildDragTarget(index));

      var icon = const Icon(
        Icons.drag_handle,
      );
      Text title = Text(
        "${index + 1}",
        style: const TextStyle(fontSize: 20),
      );
      listElements.add(ListTile(
        leading: IconButton(
            onPressed: () => _removePoint(index),
            icon: const Icon(Icons.delete_rounded)),
        trailing: Draggable(
          axis: Axis.vertical,
          data: index,
          child: icon,
          childWhenDragging: Opacity(
            opacity: 0.4,
            child: icon,
          ),
          feedback: icon,
        ),
        title: title,
        dense: true,
      ));
    }

    listElements.add(_buildDragTarget(_locations.length));

    return ListView(children: listElements);
  }

  Widget _buildExpandableListContainer() {
    if (_listExpanded) {
      return Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          color: onPrimaryColorOf(context),
          height: 350,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => setState(() {
                    _listExpanded = false;
                  }),
                  child: const Text("hide List"),
                ),
              ),
              Expanded(
                child: _buildDraggableList(),
              ),
            ],
          ));
    } else {
      return Container(
        width: double.infinity,
        color: onPrimaryColorOf(context),
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: ElevatedButton(
          onPressed: () => setState(() {
            _listExpanded = true;
          }),
          child: const Text("show List"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Expanded(
          child: MapboxMap(
        accessToken: _token,
        styleString: _style,
        initialCameraPosition: const CameraPosition(
          zoom: 13.0,
          target: LatLng(47.27, 11.33),
        ),
        compassEnabled: true,
        compassViewPosition: CompassViewPosition.TopRight,
        onMapCreated: (MapboxMapController controller) =>
            _mapController = controller,
        onMapLongClick: (point, LatLng coordinates) => _extendLine(coordinates),
      )),
      _buildExpandableListContainer(),
      Container(
          padding: const EdgeInsets.all(5),
          color: onPrimaryColorOf(context),
          child: Table(
            children: [
              TableRow(children: [
                _buildCard("6.17 km", "distance"),
                _buildCard("???", "???"),
              ]),
              TableRow(children: [
                _buildCard("231 m", "ascent"),
                _buildCard("51 m", "descent"),
              ]),
            ],
          )),
      Container(
          color: onPrimaryColorOf(context),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              const Expanded(
                  child: TextField(
                decoration: InputDecoration(
                  labelText: "name",
                ),
              )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green[400]),
                  onPressed: null,
                  //onPressed: () => updateLocations(),
                  child: const Text("create")),
            ],
          ))
    ]));
  }
}
