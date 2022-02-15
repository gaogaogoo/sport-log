import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport_log/data_provider/sync.dart';
import 'package:sport_log/helpers/account.dart';
import 'package:sport_log/helpers/extensions/date_time_extension.dart';
import 'package:sport_log/helpers/extensions/navigator_extension.dart';
import 'package:sport_log/helpers/snackbar.dart';
import 'package:sport_log/helpers/theme.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/settings.dart';
import 'package:sport_log/widgets/custom_icons.dart';

import 'spinning_sync.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    Key? key,
    required this.selectedRoute,
  }) : super(key: key);

  final String selectedRoute;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(Settings.username!),
            accountEmail: Text(Settings.email!),
          ),
          ListTile(
            title: const Text('Workout Tracking'),
            leading: const Icon(CustomIcons.dumbbellRotated),
            onTap: () {
              Nav.changeNamed(context, Routes.timeline.overview);
            },
            selected: selectedRoute == Routes.timeline.overview,
          ),
          ListTile(
            leading: const Icon(Icons.play_circle_rounded),
            title: const Text('Server Actions'),
            onTap: () => Nav.changeNamed(context, Routes.action.overview),
            selected: selectedRoute == Routes.action.overview,
          ),
          ListTile(
            leading: const Icon(CustomIcons.stopwatch),
            title: const Text('Timer'),
            onTap: () => Nav.changeNamed(context, Routes.timer),
            selected: selectedRoute == Routes.timer,
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Map'),
            onTap: () => Nav.changeNamed(context, Routes.map),
            selected: selectedRoute == Routes.map,
          ),
          ListTile(
            leading: const Icon(Icons.file_download),
            title: const Text('Offline Maps'),
            onTap: () => Nav.changeNamed(context, Routes.offlineMaps),
            selected: selectedRoute == Routes.offlineMaps,
          ),
          ExpansionTile(
            title: const Text('Primitives'),
            initiallyExpanded: true,
            children: [
              ListTile(
                title: const Text('Movements'),
                leading: const Icon(CustomIcons.trendingUp),
                onTap: () => Nav.changeNamed(context, Routes.movement.overview),
                selected: selectedRoute == Routes.movement.overview,
              ),
            ],
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Nav.changeNamed(context, Routes.settings),
            selected: selectedRoute == Routes.settings,
          ),
          Consumer<Sync>(
            builder: (context, sync, _) {
              String title;
              if (sync.isSyncing) {
                title = 'Syncing...';
              } else if (Settings.lastSync == null) {
                title = 'No syncs yet';
              } else {
                title = 'Last sync: ' + Settings.lastSync!.toHumanWithTime();
              }
              return ListTile(
                title: Text(title),
                trailing: SpinningSync(
                  color: secondaryVariantOf(context),
                  onPressed: sync.isSyncing
                      ? null
                      : () => Sync.instance.sync(
                            onNoInternet: () {
                              showSimpleToast(
                                  context, 'No Internet connection.');
                            },
                          ),
                  isSpinning: sync.isSyncing,
                ),
              );
            },
          ),
          Consumer<Sync>(
            builder: (context, sync, _) => ListTile(
              title: const Text('Logout'),
              trailing: IconButton(
                color: secondaryVariantOf(context),
                icon: const Icon(Icons.logout_sharp),
                onPressed: sync.isSyncing
                    ? null
                    : () async {
                        await Account.logout();
                        Nav.changeNamed(context, Routes.landing);
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
