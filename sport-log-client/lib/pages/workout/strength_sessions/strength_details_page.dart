import 'package:flutter/material.dart';
import 'package:sport_log/data_provider/data_providers/all.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/extensions/date_time_extension.dart';
import 'package:sport_log/helpers/extensions/iterable_extension.dart';
import 'package:sport_log/helpers/formatting.dart';
import 'package:sport_log/helpers/page_return.dart';
import 'package:sport_log/models/movement/movement.dart';
import 'package:sport_log/models/strength/all.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/widgets/app_icons.dart';
import 'package:sport_log/widgets/form_widgets/text_tile.dart';

class StrengthSessionDetailsPage extends StatefulWidget {
  const StrengthSessionDetailsPage({
    Key? key,
    required this.strengthSessionDescription,
  }) : super(key: key);

  final StrengthSessionDescription strengthSessionDescription;

  @override
  _StrengthSessionDetailsPageState createState() =>
      _StrengthSessionDetailsPageState();
}

class _StrengthSessionDetailsPageState
    extends State<StrengthSessionDetailsPage> {
  final _dataProvider = StrengthSessionDescriptionDataProvider.instance;
  late StrengthSessionDescription _strengthSessionDescription;

  @override
  void initState() {
    _strengthSessionDescription = widget.strengthSessionDescription;
    super.initState();
  }

  Future<void> _deleteStrengthSession() async {
    await _dataProvider.deleteSingle(_strengthSessionDescription);
    Navigator.pop(context);
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
            onPressed: () async {
              final returnObj = await Navigator.pushNamed(
                context,
                Routes.strength.edit,
                arguments: _strengthSessionDescription,
              );
              if (returnObj is ReturnObject<StrengthSessionDescription>) {
                if (returnObj.action == ReturnAction.deleted) {
                  Navigator.pop(context);
                } else {
                  setState(() {
                    _strengthSessionDescription = returnObj.payload;
                  });
                }
              }
            },
            icon: const Icon(AppIcons.edit),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(5),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextTile(
                    caption: "Date",
                    child: Text(
                      widget.strengthSessionDescription.session.datetime
                          .toHumanWithTime(),
                    ),
                  ),
                  TextTile(
                    caption: "Sets",
                    child: Text(
                      [
                        '${widget.strengthSessionDescription.sets.length} sets',
                        if (widget
                                .strengthSessionDescription.session.interval !=
                            null)
                          widget.strengthSessionDescription.session.interval!
                              .formatTimeShort,
                      ].join(' • '),
                    ),
                  ),
                  ..._bestValuesInfo(widget.strengthSessionDescription),
                ],
              ),
            ),
          ),
          if (widget.strengthSessionDescription.session.comments != null) ...[
            Defaults.sizedBox.vertical.small,
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextTile(
                  caption: 'Comments',
                  child: Text(
                    widget.strengthSessionDescription.session.comments!,
                  ),
                ),
              ),
            ),
          ],
          Defaults.sizedBox.vertical.small,
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    widget.strengthSessionDescription.sets.mapToListIndexed(
                  (set, index) => TextTile(
                    caption: "Set ${index + 1}",
                    child: Text(
                      set.toDisplayName(
                        widget.strengthSessionDescription.movement.dimension,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _bestValuesInfo(StrengthSessionDescription session) {
    final stats = session.stats;
    switch (session.movement.dimension) {
      case MovementDimension.reps:
        final maxEorm = stats.maxEorm;
        final maxWeight = stats.maxWeight;
        final sumVolume = stats.sumVolume;
        return [
          if (maxEorm != null)
            TextTile(
              caption: 'Max Eorm',
              child: Text(roundedWeight(maxEorm)),
            ),
          if (sumVolume != null)
            TextTile(
              caption: 'Volume',
              child: Text(roundedWeight(sumVolume)),
            ),
          if (maxWeight != null)
            TextTile(
              caption: 'Max Weight',
              child: Text(roundedWeight(maxWeight)),
            ),
          TextTile(
            caption: 'Avg Reps',
            child: Text(stats.avgCount.toStringAsFixed(1)),
          )
        ];
      case MovementDimension.time:
        return [
          TextTile(
            caption: 'Best Time',
            child: Text(Duration(milliseconds: stats.minCount).formatTime),
          ),
        ];
      case MovementDimension.distance:
        return [
          TextTile(
            caption: 'Best Distance',
            child: Text(formatDistance(stats.maxCount)),
          ),
        ];
      case MovementDimension.energy:
        return [
          TextTile(
            caption: 'Total Energy',
            child: Text(stats.sumCount.toString() + 'cals'),
          ),
        ];
    }
  }
}
