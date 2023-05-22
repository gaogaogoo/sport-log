import 'package:flutter/material.dart';
import 'package:sport_log/data_provider/data_providers/diary_data_provider.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/extensions/date_time_extension.dart';
import 'package:sport_log/helpers/validation.dart';
import 'package:sport_log/models/diary/diary.dart';
import 'package:sport_log/theme.dart';
import 'package:sport_log/widgets/app_icons.dart';
import 'package:sport_log/widgets/dialogs/dialogs.dart';
import 'package:sport_log/widgets/input_fields/edit_tile.dart';
import 'package:sport_log/widgets/picker/datetime_picker.dart';
import 'package:sport_log/widgets/pop_scopes.dart';

class DiaryEditPage extends StatefulWidget {
  const DiaryEditPage({this.diary, super.key});

  final Diary? diary;
  bool get isNew => diary == null;

  @override
  State<DiaryEditPage> createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends State<DiaryEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _dataProvider = DiaryDataProvider();

  late final Diary _diary = widget.diary?.clone() ?? Diary.defaultValue();

  Future<void> _saveDiary() async {
    final result = widget.isNew
        ? await _dataProvider.createSingle(_diary)
        : await _dataProvider.updateSingle(_diary);
    if (mounted) {
      if (result.isSuccess) {
        Navigator.pop(context);
      } else {
        await showMessageDialog(
          context: context,
          text:
              "${widget.isNew ? 'Creating' : 'Updating'} Diary Entry failed:\n${result.failure}",
        );
      }
    }
  }

  Future<void> _deleteDiary() async {
    final delete = await showDeleteWarningDialog(context, "Diary Entry");
    if (!delete) {
      return;
    }
    if (!widget.isNew) {
      final result = await _dataProvider.deleteSingle(_diary);
      if (mounted) {
        if (result.isSuccess) {
          Navigator.pop(context);
        } else {
          await showMessageDialog(
            context: context,
            text: "Deleting Diary Entry failed:\n${result.failure}",
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
          title: Text("${widget.isNew ? 'Create' : 'Edit'} Diary Entry"),
          actions: [
            IconButton(
              onPressed: _deleteDiary,
              icon: const Icon(AppIcons.delete),
            ),
            IconButton(
              onPressed: _formKey.currentContext != null &&
                      _formKey.currentState!.validate() &&
                      _diary.isValid()
                  ? _saveDiary
                  : null,
              icon: const Icon(AppIcons.save),
            ),
          ],
        ),
        body: Padding(
          padding: Defaults.edgeInsets.normal,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                EditTile(
                  leading: AppIcons.calendar,
                  caption: "Date",
                  child: Text(_diary.date.toHumanDate()),
                  onTap: () async {
                    final date = await showDatePickerWithDefaults(
                      context: context,
                      initialDate: _diary.date,
                    );
                    if (mounted && date != null) {
                      setState(() {
                        _diary.date = date;
                      });
                    }
                  },
                ),
                TextFormField(
                  decoration:
                      Theme.of(context).textFormFieldDecoration.copyWith(
                            icon: const Icon(AppIcons.weight),
                            labelText: "Bodyweight",
                          ),
                  initialValue: _diary.bodyweight?.toStringAsFixed(1),
                  validator: (weight) => weight == null || weight.isEmpty
                      ? null
                      : Validator.validateDoubleGtZero(weight),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  onChanged: (bodyweight) => setState(() {
                    if (bodyweight.isEmpty) {
                      _diary.bodyweight = null;
                    } else if (Validator.validateDoubleGtZero(bodyweight) ==
                        null) {
                      _diary.bodyweight = double.parse(bodyweight);
                    }
                  }),
                ),
                TextFormField(
                  decoration:
                      Theme.of(context).textFormFieldDecoration.copyWith(
                            icon: const Icon(AppIcons.comment),
                            labelText: "Comments",
                          ),
                  initialValue: _diary.comments,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  onChanged: (comments) => setState(() {
                    _diary.comments = comments.isEmpty ? null : comments;
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
