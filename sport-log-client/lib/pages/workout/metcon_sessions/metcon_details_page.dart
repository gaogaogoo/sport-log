import 'package:flutter/material.dart' hide Route;
import 'package:sport_log/data_provider/data_providers/metcon_data_provider.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/page_return.dart';
import 'package:sport_log/models/all.dart';
import 'package:sport_log/pages/workout/metcon_sessions/metcon_description_card.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/widgets/app_icons.dart';

class MetconDetailsPage extends StatefulWidget {
  const MetconDetailsPage({
    Key? key,
    required this.metconDescription,
  }) : super(key: key);

  final MetconDescription metconDescription;

  @override
  State<MetconDetailsPage> createState() => MetconDetailsPageState();
}

class MetconDetailsPageState extends State<MetconDetailsPage> {
  final _dataProvider = MetconDescriptionDataProvider();
  late MetconDescription _metconDescription;

  @override
  void initState() {
    _metconDescription = widget.metconDescription.clone();
    super.initState();
  }

  Future<void> _deleteMetcon() async {
    await _dataProvider.deleteSingle(widget.metconDescription);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_metconDescription.metcon.name),
        actions: [
          if (!_metconDescription.hasReference &&
              widget.metconDescription.metcon.userId != null)
            IconButton(
              onPressed: _deleteMetcon,
              icon: const Icon(AppIcons.delete),
            ),
          if (widget.metconDescription.metcon.userId != null)
            IconButton(
              onPressed: () async {
                final returnObj = await Navigator.pushNamed(
                  context,
                  Routes.metcon.edit,
                  arguments: _metconDescription,
                );
                if (returnObj is ReturnObject<MetconDescription> && mounted) {
                  if (returnObj.action == ReturnAction.deleted) {
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      _metconDescription = returnObj.payload;
                    });
                  }
                }
              },
              icon: const Icon(AppIcons.edit),
            )
        ],
      ),
      body: Padding(
        padding: Defaults.edgeInsets.normal,
        child: MetconDescriptionCard(
          metconDescription: _metconDescription,
        ),
      ),
    );
  }
}
