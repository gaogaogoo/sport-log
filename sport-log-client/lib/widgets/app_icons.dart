import 'package:flutter/material.dart';
import 'package:sport_log/widgets/custom_icons.dart';

class AppIcons {
  AppIcons._();
  // This Class has 3 purposes:
  // - combine Icons and CustomIcons in one class
  // - give Icons more intuitive names
  // - make sure that always the same kind of icon (outlined, rounded, ...) is used

  // custom icons
  static const IconData dumbbell = CustomIcons.dumbbell_not_rotated;
  static const IconData dumbbellRotated = CustomIcons.dumbbell_rotated;
  static const IconData plan = CustomIcons.plan;
  static const IconData repeat = CustomIcons.cw;
  static const IconData syncClockwise = CustomIcons.arrows_cw;
  static const IconData timeInterval = CustomIcons.time_interval;
  static const IconData github = CustomIcons.github;
  static const IconData gauge = CustomIcons.gauge;
  static const IconData food = CustomIcons.food;
  static const IconData heartbeat = CustomIcons.heartbeat;
  static const IconData weight = CustomIcons.weight;
  static const IconData route = CustomIcons.route;
  static const IconData ruler = CustomIcons.ruler_horizontal;
  //static const IconData medal = CustomIcons.medal;

  // actions
  static const IconData add = Icons.add_rounded;
  static const IconData addBox = Icons.add_box_rounded;
  static const IconData subtractBox = Icons.indeterminate_check_box_rounded;
  static const IconData delete = Icons.delete_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData save = Icons.save_rounded;
  static const IconData cancel = Icons.cancel_rounded;
  static const IconData close = Icons.close;
  static const IconData check = Icons.check_rounded;
  static const IconData checkBox = Icons.check_box_outlined;
  static const IconData checkCircle = Icons.check_circle_outline_rounded;
  static const IconData undo = Icons.undo_rounded;
  static const IconData restore = Icons.settings_backup_restore_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData logout = Icons.logout_rounded;
  static const IconData download = Icons.download_rounded;
  static const IconData sync = Icons.sync;
  static const IconData openInBrowser = Icons.open_in_browser_outlined;
  static const IconData fileDownload = Icons.file_download;
  static const IconData dragHandle = Icons.drag_handle;

  // arrows
  static const IconData arrowBack = Icons.arrow_back_rounded;
  static const IconData arrowBackOpen = Icons.arrow_back_ios_rounded;
  static const IconData arrowForwardOpen = Icons.arrow_forward_ios_rounded;
  static const IconData arrowDropDown = Icons.arrow_drop_down_rounded;
  static const IconData trendingUp = Icons.trending_up_rounded;
  static const IconData trendingDown = Icons.trending_down_rounded;

  static const IconData filterFilled = Icons.filter_alt;
  static const IconData filter = Icons.filter_alt_outlined;

  // fiels
  static const IconData settings = Icons.settings_rounded;
  static const IconData questionmark = Icons.question_mark_rounded;
  static const IconData email = Icons.email_outlined;
  static const IconData key = Icons.key_outlined;
  static const IconData map = Icons.map;
  static const IconData timer = Icons.timer_outlined;
  static const IconData sports = Icons.sports;
  static const IconData comment = Icons.comment_outlined;
  static const IconData exercise = Icons.directions_run_rounded;
  static const IconData calendar = Icons.calendar_today;
  static const IconData notes = Icons.notes_rounded;
  static const IconData cloudUpload = Icons.cloud_upload_outlined;
  static const IconData account = Icons.account_circle_outlined;
  static const IconData contributors = Icons.supervised_user_circle_outlined;
  static const IconData copyright = Icons.copyright_outlined;
  static const IconData playCircle = Icons.play_circle_outline;
  static const IconData timeline = Icons.timeline;
}
