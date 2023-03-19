import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sport_log/data_provider/data_providers/strength_data_provider.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/extensions/date_time_extension.dart';
import 'package:sport_log/helpers/extensions/formatting.dart';
import 'package:sport_log/helpers/page_return.dart';
import 'package:sport_log/models/movement/movement.dart';
import 'package:sport_log/models/strength/all.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/widgets/app_icons.dart';
import 'package:sport_log/widgets/input_fields/edit_tile.dart';

class StrengthSessionDetailsPage extends StatefulWidget {
  const StrengthSessionDetailsPage({
    required this.strengthSessionDescription,
    super.key,
  });

  final StrengthSessionDescription strengthSessionDescription;

  @override
  StrengthSessionDetailsPageState createState() =>
      StrengthSessionDetailsPageState();
}

class StrengthSessionDetailsPageState
    extends State<StrengthSessionDetailsPage> {
  final _dataProvider = StrengthSessionDescriptionDataProvider();
  late StrengthSessionDescription _strengthSessionDescription =
      widget.strengthSessionDescription.clone();

  Future<void> _deleteStrengthSession() async {
    await _dataProvider.deleteSingle(_strengthSessionDescription);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _pushEditPage() async {
    final returnObj = await Navigator.pushNamed(
      context,
      Routes.strengthEdit,
      arguments: _strengthSessionDescription,
    );
    if (returnObj is ReturnObject<StrengthSessionDescription> && mounted) {
      if (returnObj.action == ReturnAction.deleted) {
        Navigator.pop(context);
      } else {
        setState(() {
          _strengthSessionDescription = returnObj.payload;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_strengthSessionDescription.movement.name),
        actions: [
          IconButton(
            onPressed: _deleteStrengthSession,
            icon: const Icon(AppIcons.delete),
          ),
          IconButton(
            onPressed: _pushEditPage,
            icon: const Icon(AppIcons.edit),
          ),
        ],
      ),
      body: ListView(
        padding: Defaults.edgeInsets.normal,
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: Defaults.edgeInsets.normal,
              child: Column(
                children: [
                  EditTile(
                    leading: null,
                    caption: "Date",
                    child: Text(
                      _strengthSessionDescription.session.datetime
                          .toHumanDateTime(),
                    ),
                  ),
                  EditTile(
                    leading: null,
                    caption: "Sets",
                    child: Text(
                      '${_strengthSessionDescription.sets.length} sets',
                    ),
                  ),
                  if (widget.strengthSessionDescription.session.interval !=
                      null)
                    EditTile(
                      leading: null,
                      caption: "Interval",
                      child: Text(
                        _strengthSessionDescription
                            .session.interval!.formatTimeShort,
                      ),
                    ),
                  ..._bestValuesInfo(_strengthSessionDescription),
                ],
              ),
            ),
          ),
          if (_strengthSessionDescription.session.comments != null) ...[
            Defaults.sizedBox.vertical.small,
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: Defaults.edgeInsets.normal,
                child: EditTile(
                  leading: null,
                  caption: 'Comments',
                  child: Text(
                    _strengthSessionDescription.session.comments!,
                  ),
                ),
              ),
            ),
          ],
          Defaults.sizedBox.vertical.small,
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: Defaults.edgeInsets.normal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _strengthSessionDescription.sets
                    .mapIndexed(
                      (index, set) => EditTile(
                        leading: null,
                        caption: "Set ${index + 1}",
                        child: Text(
                          set.toDisplayName(
                            _strengthSessionDescription.movement.dimension,
                            withEorm: true,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: long-method
  List<Widget> _bestValuesInfo(StrengthSessionDescription session) {
    final stats = session.stats;
    switch (session.movement.dimension) {
      case MovementDimension.reps:
        final maxEorm = stats.maxEorm;
        final maxWeight = stats.maxWeight;
        final sumVolume = stats.sumVolume;
        return [
          if (maxEorm != null)
            EditTile(
              leading: null,
              caption: 'Max Eorm',
              child: Text(formatWeight(maxEorm)),
            ),
          if (sumVolume != null)
            EditTile(
              leading: null,
              caption: 'Volume',
              child: Text(formatWeight(sumVolume)),
            ),
          if (maxWeight != null)
            EditTile(
              leading: null,
              caption: 'Max Weight',
              child: Text(formatWeight(maxWeight)),
            ),
          EditTile(
            leading: null,
            caption: 'Avg Reps',
            child: Text(stats.avgCount.toStringAsFixed(1)),
          )
        ];
      case MovementDimension.time:
        return [
          EditTile(
            leading: null,
            caption: 'Best Time',
            child: Text(Duration(milliseconds: stats.minCount).formatMsMill),
          ),
        ];
      case MovementDimension.distance:
        return [
          EditTile(
            leading: null,
            caption: 'Best Distance',
            child: Text("${stats.maxCount} m"),
          ),
        ];
      case MovementDimension.energy:
        return [
          EditTile(
            leading: null,
            caption: 'Total Energy',
            child: Text('${stats.sumCount} cal'),
          ),
        ];
    }
  }
}
