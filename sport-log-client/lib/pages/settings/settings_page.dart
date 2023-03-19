import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport_log/data_provider/sync.dart';
import 'package:sport_log/database/db_interfaces.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/helpers/account.dart';
import 'package:sport_log/helpers/bool_toggle.dart';
import 'package:sport_log/helpers/extensions/navigator_extension.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/settings.dart';
import 'package:sport_log/theme.dart';
import 'package:sport_log/widgets/app_icons.dart';
import 'package:sport_log/widgets/dialogs/dialogs.dart';
import 'package:sport_log/widgets/input_fields/duration_input.dart';
import 'package:sport_log/widgets/input_fields/edit_tile.dart';
import 'package:sport_log/widgets/input_fields/int_input.dart';
import 'package:sport_log/widgets/input_fields/text_tile.dart';
import 'package:sport_log/widgets/main_drawer.dart';
import 'package:sport_log/widgets/pop_scopes.dart';
import 'package:sport_log/widgets/provider_consumer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> checkSync(BuildContext context) async {
    await Sync.instance.sync(
      onNoInternet: () => showMessageDialog(
        context: context,
        text:
            "The server could not be reached.\nPlease make sure you are connected to the internet and the server URL is right.",
      ),
    );
  }

  Future<void> _setSyncEnabled(BuildContext context, bool syncEnabled) async {
    await context.read<Settings>().setSyncEnabled(syncEnabled);
    if (context.mounted && syncEnabled) {
      await checkSync(context);
      await Sync.instance.startSync();
    } else {
      Sync.instance.stopSync();
    }
  }

  Future<void> _createAccount(BuildContext context) async {
    final settings = context.read<Settings>()
      ..setAccountCreated(true)
      ..setSyncEnabled(true);
    final result = await Account.register(
      settings.serverUrl,
      settings.user!,
    );
    if (result.isFailure) {
      settings
        ..setAccountCreated(false)
        ..setSyncEnabled(false);
      if (context.mounted) {
        await showMessageDialog(
          context: context,
          title: "An Error occurred:",
          text: result.failure.toString(),
        );
      }
    }
  }

  Future<void> _setServerUrl(BuildContext context, String serverUrl) async {
    final validated = Validator.validateUrl(serverUrl);
    if (validated == null) {
      await context.read<Settings>().setServerUrl(serverUrl);
      Sync.instance.stopSync();
      if (context.mounted) {
        await checkSync(context);
      }
      await Sync.instance.startSync();
    } else {
      await showMessageDialog(
        context: context,
        text: validated,
      );
    }
  }

  Future<void> _setUsername(BuildContext context, String username) async {
    final validated = Validator.validateUsername(username);
    if (validated == null) {
      final result = await Account.editUser(username: username);
      if (context.mounted && result.isFailure) {
        await showMessageDialog(
          context: context,
          title: "Changing Username Failed",
          text: result.failure.toString(),
        );
      }
    } else {
      await showMessageDialog(
        context: context,
        text: validated,
      );
    }
  }

  Future<void> _setPassword(BuildContext context, String password) async {
    final validated = Validator.validatePassword(password);
    if (validated == null) {
      final result = await Account.editUser(password: password);
      if (context.mounted && result.isFailure) {
        await showMessageDialog(
          context: context,
          title: "Changing Password Failed",
          text: result.failure.toString(),
        );
      }
    } else {
      await showMessageDialog(
        context: context,
        text: validated,
      );
    }
  }

  Future<void> _setEmail(BuildContext context, String email) async {
    final validated = Validator.validateEmail(email);
    if (validated == null) {
      final result = await Account.editUser(email: email);
      if (context.mounted && result.isFailure) {
        await showMessageDialog(
          context: context,
          title: "Changing Email Failed",
          text: result.failure.toString(),
        );
      }
    } else {
      await showMessageDialog(
        context: context,
        text: validated,
      );
    }
  }

  Future<void> _initSync(BuildContext context) async {
    final approved = await showApproveDialog(
      context: context,
      title: "Warning",
      text: "Conflicting entries will get lost.",
    );
    if (approved) {
      final result = await Account.newInitSync();
      if (context.mounted && result.isFailure) {
        await showMessageDialog(
          context: context,
          text: result.failure.toString(),
        );
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    final approved = await showApproveDialog(
      context: context,
      title: "Logout",
      text:
          "Make sure you know you credentials before logging out. Otherwise you will lose access to your account and all your data.",
    );
    if (approved) {
      await Account.logout();
      if (context.mounted) {
        await Navigator.of(context).newBase(Routes.landing);
      }
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final approved = await showApproveDialog(
      context: context,
      title: "Delete Account",
      text: "If you delete your account all data will be permanently lost.",
    );
    if (approved) {
      final result = await Account.delete();
      if (context.mounted) {
        if (result.isFailure) {
          await showMessageDialog(
            context: context,
            text:
                "An error occurred while deleting your account:\n${result.failure}",
          );
        } else {
          await Navigator.of(context).newBase(Routes.landing);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NeverPop(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Container(
          padding: Defaults.edgeInsets.normal,
          child: Consumer<Settings>(
            builder: (context, settings, _) => ListView(
              children: [
                const CaptionTile(caption: "Server Settings"),
                Defaults.sizedBox.vertical.small,
                EditTile(
                  caption: "Server Synchronization",
                  leading: AppIcons.sync,
                  child: settings.accountCreated
                      ? SizedBox(
                          height: 29, // make it fit into EditTile
                          width: 34, // remove left padding
                          child: Switch(
                            value: settings.syncEnabled,
                            onChanged: (enabled) =>
                                _setSyncEnabled(context, enabled),
                          ),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.errorContainer,
                            ),
                          ),
                          onPressed: () => _createAccount(context),
                          child: const Text('Create Account'),
                        ),
                ),
                TextFormField(
                  decoration:
                      Theme.of(context).textFormFieldDecoration.copyWith(
                            icon: const Icon(AppIcons.cloudUpload),
                            labelText: "Server URL",
                          ),
                  initialValue: settings.serverUrl,
                  validator: Validator.validateUrl,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: (serverUrl) =>
                      _setServerUrl(context, serverUrl),
                ),
                if (settings.syncEnabled)
                  EditTile(
                    leading: AppIcons.timeInterval,
                    caption: "Synchronization Interval (min)",
                    child: IntInput(
                      initialValue: settings.syncInterval.inMinutes,
                      minValue: 1,
                      maxValue: null,
                      onUpdate: (syncInterval) async {
                        await settings
                            .setSyncInterval(Duration(minutes: syncInterval));
                        Sync.instance.stopSync();
                        await Sync.instance.startSync();
                      },
                    ),
                  ),
                Defaults.sizedBox.vertical.small,
                const Divider(),
                const CaptionTile(caption: "Account"),
                TextFormField(
                  key: UniqueKey(),
                  decoration:
                      Theme.of(context).textFormFieldDecoration.copyWith(
                            icon: const Icon(AppIcons.account),
                            labelText: "Username",
                          ),
                  initialValue: settings.username,
                  validator: Validator.validateUsername,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: (username) =>
                      _setUsername(context, username),
                ),
                ProviderConsumer(
                  create: (_) => BoolToggle.on(),
                  builder: (context, obscure, _) {
                    return TextFormField(
                      key: UniqueKey(),
                      decoration:
                          Theme.of(context).textFormFieldDecoration.copyWith(
                                icon: const Icon(AppIcons.key),
                                labelText: "Password",
                                suffixIcon: IconButton(
                                  icon: obscure.isOn
                                      ? const Icon(AppIcons.visibility)
                                      : const Icon(AppIcons.visibilityOff),
                                  onPressed: obscure.toggle,
                                ),
                              ),
                      obscureText: obscure.isOn,
                      initialValue: settings.password,
                      validator: Validator.validatePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (password) =>
                          _setPassword(context, password),
                    );
                  },
                ),
                TextFormField(
                  key: UniqueKey(),
                  decoration:
                      Theme.of(context).textFormFieldDecoration.copyWith(
                            icon: const Icon(AppIcons.email),
                            labelText: "Email",
                          ),
                  initialValue: settings.email,
                  validator: Validator.validateEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (email) => _setEmail(context, email),
                ),
                Consumer<Sync>(
                  builder: (context, sync, _) => TextTile(
                    leading: AppIcons.logout,
                    child: Row(
                      children: [
                        if (settings.accountCreated) ...[
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.errorContainer,
                                ),
                              ),
                              onPressed: sync.isSyncing
                                  ? null
                                  : () => _initSync(context),
                              child: const Text('Init Sync'),
                            ),
                          ),
                          Defaults.sizedBox.horizontal.normal,
                        ],
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.error,
                              ),
                            ),
                            onPressed:
                                sync.isSyncing ? null : () => _logout(context),
                            child: const Text('Logout'),
                          ),
                        ),
                        if (settings.accountCreated) ...[
                          Defaults.sizedBox.horizontal.normal,
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.error,
                                ),
                              ),
                              onPressed: sync.isSyncing
                                  ? null
                                  : () => _deleteAccount(context),
                              child: const Text('Delete Account'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Defaults.sizedBox.vertical.small,
                const Divider(),
                const CaptionTile(caption: "Other Settings"),
                Defaults.sizedBox.vertical.small,
                //EditTile(
                //caption: "Units",
                //child: SizedBox(
                //height: 24,
                //child: DropdownButtonHideUnderline(
                //child: DropdownButton(
                //value: settings.units,
                //items: [
                //for (final unit in Units.values)
                //DropdownMenuItem(
                //value: unit,
                //child: Text(unit.name),
                //),
                //],
                //onChanged: (units) {
                //if (units != null && units is Units) {
                //settings.units = units;
                //}
                //},
                //),
                //),
                //),
                //leading: AppIcons.sync,
                //),
                TextFormField(
                  decoration:
                      Theme.of(context).textFormFieldDecoration.copyWith(
                            icon: const Icon(AppIcons.dumbbell),
                            labelText: "Weight Increment",
                          ),
                  keyboardType: TextInputType.number,
                  initialValue: settings.weightIncrement.toString(),
                  validator: Validator.validateDoubleGtZero,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onFieldSubmitted: (increment) async {
                    if (Validator.validateDoubleGtZero(increment) == null) {
                      await settings
                          .setWeightIncrement(double.parse(increment));
                    }
                  },
                ),
                Defaults.sizedBox.vertical.small,
                EditTile(
                  leading: AppIcons.timeInterval,
                  caption: "Duration Increment",
                  child: DurationInput(
                    initialDuration: settings.durationIncrement,
                    onUpdate: settings.setDurationIncrement,
                    durationIncrement: const Duration(minutes: 1),
                    minDuration: const Duration(seconds: 1),
                  ),
                ),
                Defaults.sizedBox.vertical.small,
                const Divider(),
                const CaptionTile(caption: "Developer Mode"),
                EditTile(
                  caption: "Developer Mode",
                  leading: AppIcons.developerMode,
                  child: SizedBox(
                    height: 29, // make it fit into EditTile
                    width: 34, // remove left padding
                    child: Switch(
                      value: settings.developerMode,
                      onChanged: settings.setDeveloperMode,
                    ),
                  ),
                ),
                const Divider(),
                const CaptionTile(caption: "About"),
                GestureDetector(
                  child: const TextTile(
                    leading: AppIcons.questionMark,
                    child: Text('About'),
                  ),
                  onTap: () => Navigator.pushNamed(context, Routes.about),
                ),
              ],
            ),
          ),
        ),
        drawer: const MainDrawer(selectedRoute: Routes.settings),
      ),
    );
  }
}
