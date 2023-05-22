import 'package:flutter/material.dart';
import 'package:sport_log/data_provider/data_providers/movement_data_provider.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/validation.dart';
import 'package:sport_log/models/movement/all.dart';
import 'package:sport_log/theme.dart';
import 'package:sport_log/widgets/app_icons.dart';
import 'package:sport_log/widgets/dialogs/dialogs.dart';
import 'package:sport_log/widgets/pop_scopes.dart';

class MovementEditPage extends StatefulWidget {
  const MovementEditPage({
    required this.movementDescription,
    super.key,
  }) : name = null;

  const MovementEditPage.fromName({
    required String this.name,
    super.key,
  }) : movementDescription = null;

  final MovementDescription? movementDescription;
  final String? name;
  bool get isNew => movementDescription == null;

  @override
  State<StatefulWidget> createState() => _MovementEditPageState();
}

class _MovementEditPageState extends State<MovementEditPage> {
  final _dataProvider = MovementDataProvider();
  final _formKey = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  late final MovementDescription _movementDescription;

  @override
  void initState() {
    _movementDescription = widget.movementDescription?.clone() ??
        MovementDescription.defaultValue();
    if (widget.name != null) {
      _movementDescription.movement.name = widget.name!;
    }

    super.initState();
  }

  Future<void> _saveMovement() async {
    final result = widget.isNew
        ? await _dataProvider.createSingle(_movementDescription.movement)
        : await _dataProvider.updateSingle(_movementDescription.movement);
    if (result.isSuccess) {
      Movement.defaultMovement ??= _movementDescription.movement;
      if (mounted) {
        Navigator.pop(context);
      }
    } else if (mounted) {
      await showMessageDialog(
        context: context,
        text:
            "${widget.isNew ? 'Creating' : 'Updating'} Movement failed:\n${result.failure}",
      );
    }
  }

  Future<void> _deleteMovement() async {
    final delete = await showDeleteWarningDialog(context, "Movement");
    if (!delete) {
      return;
    }
    if (!widget.isNew) {
      assert(_movementDescription.movement.userId != null);
      assert(!_movementDescription.hasReference);
      final result =
          await _dataProvider.deleteSingle(_movementDescription.movement);
      if (mounted) {
        if (result.isSuccess) {
          Navigator.pop(context);
        } else {
          await showMessageDialog(
            context: context,
            text: "Deleting Movement failed:\n${result.failure}",
          );
        }
      }
    } else if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DiscardWarningOnPop(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.isNew ? 'Create' : 'Edit'} Movement"),
          actions: [
            if (!_movementDescription.hasReference)
              IconButton(
                onPressed: _deleteMovement,
                icon: const Icon(AppIcons.delete),
              ),
            IconButton(
              onPressed: _formKey.currentContext != null &&
                      _formKey.currentState!.validate() &&
                      _movementDescription.isValid()
                  ? _saveMovement
                  : null,
              icon: const Icon(AppIcons.save),
            )
          ],
        ),
        body: Padding(
          padding: Defaults.edgeInsets.normal,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _nameInput(context),
                ..._movementDescription.movement.description == null
                    ? [
                        Defaults.sizedBox.vertical.small,
                        ActionChip(
                          avatar: const Icon(AppIcons.add),
                          label: const Text("Add description"),
                          onPressed: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            setState(() {
                              _movementDescription.movement.description = "";
                            });
                            _descriptionFocusNode.requestFocus();
                          },
                        ),
                      ]
                    : [
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextFormField(
                            initialValue:
                                _movementDescription.movement.description,
                            focusNode: _descriptionFocusNode,
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            maxLines: 5,
                            onChanged: (description) => setState(
                              () => _movementDescription.movement.description =
                                  description,
                            ),
                            decoration: Theme.of(context)
                                .textFormFieldDecoration
                                .copyWith(
                                  labelText: "Description",
                                  suffixIcon: IconButton(
                                    icon: const Icon(AppIcons.close),
                                    onPressed: () => setState(
                                      () => _movementDescription
                                          .movement.description = null,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ],
                Defaults.sizedBox.vertical.small,
                _dimInput,
                _categoryInput(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameInput(BuildContext context) {
    return TextFormField(
      initialValue: _movementDescription.movement.name,
      onChanged: (name) {
        if (Validator.validateStringNotEmpty(name) == null) {
          setState(() => _movementDescription.movement.name = name);
        }
      },
      validator: Validator.validateStringNotEmpty,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: Theme.of(context).textTheme.titleLarge,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.text,
      decoration: Theme.of(context).textFormFieldDecoration.copyWith(
            labelText: "Name",
          ),
    );
  }

  Widget get _dimInput {
    return SegmentedButton(
      segments: MovementDimension.values
          .map(
            (md) => ButtonSegment(
              value: md,
              label: Text(md.name),
            ),
          )
          .toList(),
      selected: {_movementDescription.movement.dimension},
      showSelectedIcon: false,
      onSelectionChanged: (selected) => setState(
        () => _movementDescription.movement.dimension = selected.first,
      ),
    );
  }

  Widget _categoryInput(BuildContext context) {
    return CheckboxListTile(
      value: _movementDescription.movement.cardio,
      checkColor: Theme.of(context).colorScheme.onPrimary,
      onChanged: (bool? isCardio) {
        FocusManager.instance.primaryFocus?.unfocus();
        if (isCardio != null) {
          setState(() => _movementDescription.movement.cardio = isCardio);
        }
      },
      title: const Text('Is suitable for cardio sessions'),
    );
  }
}
