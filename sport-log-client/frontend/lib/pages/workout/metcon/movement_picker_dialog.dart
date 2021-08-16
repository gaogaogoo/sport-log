
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport_log/models/movement/movement.dart';
import 'package:sport_log/repositories/movement_repository.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/widgets/wide_screen_frame.dart';

class MovementPickerDialog extends StatefulWidget {
  const MovementPickerDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MovementPickerDialogState();
}

class _MovementPickerDialogState extends State<MovementPickerDialog> {

  List<Movement> _movements = [];
  String _searchTerm = "";
  bool _anyFullMatches = false;

  bool get _canCreateNewMovement =>
      _searchTerm.isNotEmpty && _anyFullMatches == false;

  @override
  void initState() {
    setState(() {
      _movements = context.read<MovementRepository>().getAllMovements();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WideScreenFrame(
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: _searchTextField(),
              floating: true,
              snap: true,
              pinned: false,
              automaticallyImplyLeading: false,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (_canCreateNewMovement) {
                    return index == 0
                        ? _newMovementButton(context)
                        : _movementToWidget(_movements[index - 1]);
                  } else {
                    return _movementToWidget(_movements[index]);
                  }
                },
                childCount: _canCreateNewMovement
                    ? _movements.length + 1 : _movements.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchTextField() {
    return TextFormField(
      initialValue: _searchTerm,
      onChanged: (text) {
        setState(() {
          _movements = context.read<MovementRepository>().searchByName(text);
          _searchTerm = text;
          final search = _searchTerm.toLowerCase();
          _anyFullMatches = _movements.any((movement) =>
            movement.name.toLowerCase() == search);
        });
      },
      decoration: const InputDecoration(
        labelText: "Search",
        icon: Icon(Icons.search)
      ),
    );
  }

  Widget _newMovementButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add),
      title: Text("Create new movement '$_searchTerm'"),
      onTap: () async {
        dynamic payload = await Navigator.of(context).pushNamed(
          Routes.editMovement,
          arguments: _searchTerm,
        );
        if (payload is int) {
          Navigator.of(context).pop(payload);
        }
      },
    );
  }

  Widget _movementToWidget(Movement m) {
    return ListTile(
      title: Text(m.name),
      subtitle: (m.description != null && m.description!.isNotEmpty)
          ? Text(
        m.description!,
        overflow: TextOverflow.ellipsis,
      ) : null,
      onTap: () => Navigator.of(context).pop(m.id),
    );
  }
}