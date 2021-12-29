import 'package:flutter/material.dart' hide Route;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:sport_log/data_provider/user_state.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/id_generation.dart';
import 'package:sport_log/helpers/logger.dart';
import 'package:sport_log/helpers/state/page_return.dart';
import 'package:sport_log/pages/workout/session_tab_utils.dart';
import 'package:sport_log/secrets.dart';
import 'package:sport_log/models/cardio/position.dart';
import 'package:sport_log/models/cardio/route.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/widgets/custom_icons.dart';
import 'package:sport_log/widgets/main_drawer.dart';
import 'package:sport_log/widgets/value_unit_description.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({Key? key}) : super(key: key);

  @override
  State<RoutePage> createState() => RoutePageState();
}

class RoutePageState extends State<RoutePage> {
  final _logger = Logger('RoutePage');

  final SessionsPageTab sessionsPageTab = SessionsPageTab.cardio;
  final String route = Routes.cardio.routeOverview;
  final String defaultTitle = "Routes";

  final List<Route> _routes = [
    Route(
        id: randomId(),
        userId: UserState.instance.currentUser!.id,
        name: "my route 1",
        distance: 10951,
        ascent: 456,
        descent: 476,
        track: [
          Position(
              longitude: 11.33,
              latitude: 47.27,
              elevation: 600,
              distance: 0,
              time: 0),
          Position(
              longitude: 11.331,
              latitude: 47.27,
              elevation: 650,
              distance: 1000,
              time: 200),
          Position(
              longitude: 11.33,
              latitude: 47.272,
              elevation: 600,
              distance: 2000,
              time: 500)
        ],
        deleted: false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(defaultTitle),
          actions: [
            IconButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(Routes.cardio.overview),
                icon: const Icon(CustomIcons.heartbeat)),
          ],
        ),
        body: Scrollbar(
            child: ListView.builder(
          itemBuilder: _buildRouteCard,
          itemCount: _routes.length,
        )),
        bottomNavigationBar:
            SessionTabUtils.bottomNavigationBar(context, sessionsPageTab),
        drawer: MainDrawer(selectedRoute: route),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .pushNamed(Routes.cardio.routeEdit)
              .then(_handleNewRoute),
          child: const Icon(Icons.add),
        ));
  }

  void showDetails(BuildContext context, Route route) {
    Navigator.of(context).pushNamed(Routes.cardio.routeEdit, arguments: route);
  }

  Widget _buildRouteCard(BuildContext buildContext, int index) {
    final Route route = _routes[index];
    final distance = (route.distance / 1000).toStringAsFixed(3);

    late MapboxMapController _sessionMapController;

    return GestureDetector(
        onTap: () {
          _logger.i("click");
          showDetails(context, route);
        },
        child: Card(
          child: Column(children: [
            Defaults.sizedBox.vertical.small,
            Text(
              route.name,
              textAlign: TextAlign.center,
            ),
            Defaults.sizedBox.vertical.small,
            SizedBox(
                height: 150,
                child: MapboxMap(
                    accessToken: Secrets.mapboxAccessToken,
                    styleString: Defaults.mapbox.style.outdoor,
                    initialCameraPosition: CameraPosition(
                      zoom: 13.0,
                      target: route.track.first.latLng,
                    ),
                    onMapCreated: (MapboxMapController controller) =>
                        _sessionMapController = controller,
                    onStyleLoadedCallback: () {
                      _sessionMapController.addLine(LineOptions(
                          lineColor: "red",
                          geometry: route.track.map((c) => c.latLng).toList()));
                    },
                    onMapClick: (_, __) {
                      // TODO does not work
                      _logger.i("map click");
                      showDetails(context, route);
                    },
                    onMapLongClick: (_, __) {
                      _logger.i("map long click");
                      showDetails(context, route);
                    })),
            Defaults.sizedBox.vertical.small,
            Row(children: [
              Expanded(
                child: ValueUnitDescription(
                  value: distance,
                  unit: "km",
                  description: null,
                ),
              ),
              Expanded(
                child: ValueUnitDescription(
                  value: route.ascent.toString(),
                  unit: "m",
                  description: null,
                ),
              ),
              Expanded(
                child: ValueUnitDescription(
                  value: route.descent.toString(),
                  unit: "m",
                  description: null,
                ),
              ),
            ]),
            Defaults.sizedBox.vertical.small,
          ]),
        ));
  }

  void _handleNewRoute(dynamic object) {
    if (object is ReturnObject<Route>) {
      switch (object.action) {
        case ReturnAction.created:
          //setState(() {
          //_routes.add(object.payload);
          //_routes.sortBy((c) => c.datetime);
          //});
          break;
        case ReturnAction.updated:
          //setState(() {
          //_routes.update(object.payload, by: (o) => o.id);
          //_routes.sortBy((c) => c.datetime);
          //});
          break;
        case ReturnAction.deleted:
        //setState(() => _routes.delete(object.payload, by: (c) => c.id));
      }
    } else {
      _logger.i("poped item is not a ReturnObject");
    }
  }
}
