import 'package:flutter/material.dart' hide Route;
import 'package:sport_log/helpers/extensions/navigator_extension.dart';
import 'package:sport_log/routes.dart';
import 'package:sport_log/widgets/app_icons.dart';

enum SessionsPageTab {
  timeline(Routes.timelineOverview, AppIcons.timeline, "Timeline", "entries"),
  strength(
    Routes.strengthOverview,
    AppIcons.dumbbell,
    "Strength",
    "strength sessions",
  ),
  metcon(
    Routes.metconSessionOverview,
    AppIcons.notes,
    "Metcon",
    "metcon sessions",
  ),
  cardio(
    Routes.cardioOverview,
    AppIcons.heartbeat,
    "Cardio",
    "cardio sessions",
  ),
  diary(Routes.diaryOverview, AppIcons.calendar, "Diary", "diary entries");

  const SessionsPageTab(this.route, this.icon, this.label, this.entryName);
  final String route;
  final IconData icon;
  final String label;
  final String entryName;

  Widget get noEntriesText => Center(
        child: Text(
          "looks like there are no $entryName there yet 😔 \nselect a different time range above ↑\nor press ＋ to create a new one",
          textAlign: TextAlign.center,
        ),
      );

  Widget get noEntriesWithoutAddText => Center(
        child: Text(
          "looks like there are no $entryName there yet 😔 \nselect a different time range above ↑",
          textAlign: TextAlign.center,
        ),
      );

  static BottomNavigationBar bottomNavigationBar({
    required BuildContext context,
    required SessionsPageTab sessionsPageTab,
  }) {
    return BottomNavigationBar(
      items: SessionsPageTab.values
          .map(
            (tab) => BottomNavigationBarItem(
              icon: Icon(tab.icon),
              label: tab.label,
            ),
          )
          .toList(),
      currentIndex: sessionsPageTab.index,
      onTap: (index) => Navigator.of(context).newBase(values[index].route),
      type: BottomNavigationBarType.fixed,
    );
  }
}
