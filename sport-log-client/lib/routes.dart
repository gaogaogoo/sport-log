import 'package:flutter/material.dart' hide Route;
import 'package:sport_log/models/all.dart';
import 'package:sport_log/models/cardio/cardio_session_description.dart';
import 'package:sport_log/pages/action/action_provider_overview_page.dart';
import 'package:sport_log/pages/action/platform_overview_page.dart';
import 'package:sport_log/pages/heart_rate/heart_rate_page.dart';
import 'package:sport_log/pages/login/login_page.dart';
import 'package:sport_log/pages/map/map_page.dart';
import 'package:sport_log/pages/offline_maps/offline_maps_overview.dart';
import 'package:sport_log/pages/settings/about_page.dart';
import 'package:sport_log/pages/settings/settings_page.dart';
import 'package:sport_log/pages/timer/timer_page.dart';
import 'package:sport_log/pages/workout/cardio/cardio_details_page.dart';
import 'package:sport_log/pages/workout/cardio/cardio_edit_page.dart';
import 'package:sport_log/pages/workout/cardio/cardio_overview_page.dart';
import 'package:sport_log/pages/workout/cardio/route_overview_page.dart';
import 'package:sport_log/pages/workout/cardio/route_edit_page.dart';
import 'package:sport_log/pages/workout/cardio/tracking_page.dart';
import 'package:sport_log/pages/workout/cardio/tracking_settings_page.dart';
import 'package:sport_log/pages/login/landing_page.dart';
import 'package:sport_log/pages/workout/metcon_sessions/metcon_details_page.dart';
import 'package:sport_log/pages/workout/metcon_sessions/metcon_edit_page.dart';
import 'package:sport_log/pages/workout/metcon_sessions/metcon_overview_page.dart';
import 'package:sport_log/pages/movements/movement_edit_page.dart';
import 'package:sport_log/pages/movements/movement_overview_page.dart';
import 'package:sport_log/pages/workout/diary/diary_edit_page.dart';
import 'package:sport_log/pages/workout/diary/diary_overview_page.dart';
import 'package:sport_log/pages/workout/metcon_sessions/metcon_session_details_page.dart';
import 'package:sport_log/pages/workout/metcon_sessions/metcon_session_edit_page.dart';
import 'package:sport_log/pages/workout/metcon_sessions/metcon_session_overview_page.dart';
import 'package:sport_log/pages/workout/strength_sessions/strength_details_page.dart';
import 'package:sport_log/pages/workout/strength_sessions/strength_edit_page.dart';
import 'package:sport_log/pages/workout/strength_sessions/strength_overview_page.dart';
import 'package:sport_log/pages/workout/timeline/timeline_page.dart';
import 'package:sport_log/settings.dart';

abstract class Routes {
  static const landing = '/landing';
  static const login = '/login';
  static const registration = '/register';
  static const timer = "/timer";
  static const map = "/map";
  static const offlineMaps = "/offline_maps";
  static const heartRate = "/heart_rate";
  static const settings = "/settings";
  static const about = "/about";
  static const action = _ActionRoutes();
  static const timeline = _TimelineRoutes();
  static const metcon = _MetconRoutes();
  static const movement = _MovementRoutes();
  static const cardio = _CardioRoutes();
  static const strength = _StrengthRoutes();
  static const diary = _DiaryRoutes();

  static Widget _checkLogin(Widget Function() builder) {
    return Settings.userExists() ? builder() : const LandingPage();
  }

  static Widget _checkNotLogin(Widget Function() builder) {
    return Settings.userExists() ? const TimelinePage() : builder();
  }

  static final Map<String, Widget Function(BuildContext)> _routeList = {
    Routes.landing: (_) => _checkNotLogin(() => const LandingPage()),
    Routes.login: (_) => _checkNotLogin(
          () => const LoginPage(
            register: false,
          ),
        ),
    Routes.registration: (_) =>
        _checkNotLogin(() => const LoginPage(register: true)),
    Routes.timer: (_) => _checkLogin(() => const TimerPage()),
    Routes.map: (_) => _checkLogin(() => const MapPage()),
    Routes.offlineMaps: (_) => _checkLogin(() => const OfflineMapsPage()),
    Routes.heartRate: (_) => _checkLogin(() => const HeartRatePage()),
    Routes.settings: (_) => _checkLogin(() => const SettingsPage()),
    Routes.about: (_) => _checkLogin(() => const AboutPage()),
    // Action
    Routes.action.platformOverview: (_) =>
        _checkLogin(() => const PlatformOverviewPage()),
    Routes.action.actionProviderOverview: (context) => _checkLogin(() {
          final actionProvider =
              ModalRoute.of(context)?.settings.arguments as ActionProvider;
          return ActionProviderOverviewPage(actionProvider: actionProvider);
        }),
    // movement
    Routes.movement.overview: (_) => _checkLogin(() => const MovementsPage()),
    Routes.movement.edit: (context) => _checkLogin(() {
          final arg = ModalRoute.of(context)?.settings.arguments;
          if (arg is MovementDescription) {
            return EditMovementPage(movementDescription: arg);
          } else if (arg is String) {
            return EditMovementPage.fromName(name: arg);
          }
          return const EditMovementPage(movementDescription: null);
        }),
    // metcon
    Routes.metcon.overview: (_) => _checkLogin(() => const MetconsPage()),
    Routes.metcon.details: (context) => _checkLogin(() {
          final metconDescription =
              ModalRoute.of(context)?.settings.arguments as MetconDescription;
          return MetconDetailsPage(metconDescription: metconDescription);
        }),
    Routes.metcon.edit: (context) => _checkLogin(() {
          final metconDescription =
              ModalRoute.of(context)?.settings.arguments as MetconDescription?;
          return EditMetconPage(metconDescription: metconDescription);
        }),
    // timeline
    Routes.timeline.overview: (_) => _checkLogin(() => const TimelinePage()),
    // metcon session
    Routes.metcon.sessionOverview: (_) =>
        _checkLogin(() => const MetconSessionsPage()),
    Routes.metcon.sessionDetails: (context) => _checkLogin(() {
          final metconSessionDescription = ModalRoute.of(context)
              ?.settings
              .arguments as MetconSessionDescription;
          return MetconSessionDetailsPage(
            metconSessionDescription: metconSessionDescription,
          );
        }),
    Routes.metcon.sessionEdit: (context) => _checkLogin(() {
          final metconSessionDescription = ModalRoute.of(context)
              ?.settings
              .arguments as MetconSessionDescription?;
          return MetconSessionEditPage(
            metconSessionDescription: metconSessionDescription,
          );
        }),
    // strength
    Routes.strength.overview: (_) =>
        _checkLogin(() => const StrengthSessionsPage()),
    Routes.strength.details: (context) => _checkLogin(() {
          final strengthSessionDescription = ModalRoute.of(context)
              ?.settings
              .arguments as StrengthSessionDescription;
          return StrengthSessionDetailsPage(
            strengthSessionDescription: strengthSessionDescription,
          );
        }),
    Routes.strength.edit: (context) => _checkLogin(() {
          final arg = ModalRoute.of(context)?.settings.arguments
              as StrengthSessionDescription?;
          return StrengthSessionEditPage(strengthSessionDescription: arg);
        }),
    // cardio
    Routes.cardio.overview: (_) =>
        _checkLogin(() => const CardioSessionsPage()),
    Routes.cardio.trackingSettings: (_) =>
        _checkLogin(() => const CardioTrackingSettingsPage()),
    Routes.cardio.tracking: (context) => _checkLogin(() {
          final args =
              ModalRoute.of(context)?.settings.arguments as List<dynamic>;
          return CardioTrackingPage(
            movement: args[0] as Movement,
            cardioType: args[1] as CardioType,
            route: args[2] as Route?,
            heartRateMonitorId: args[3] as String?,
          );
        }),
    Routes.cardio.cardioEdit: (context) => _checkLogin(() {
          final cardioSessionDescription = ModalRoute.of(context)
              ?.settings
              .arguments as CardioSessionDescription?;
          return CardioEditPage(
            cardioSessionDescription: cardioSessionDescription,
          );
        }),
    Routes.cardio.cardioDetails: (context) => _checkLogin(() {
          final cardioSessionDescription = ModalRoute.of(context)
              ?.settings
              .arguments as CardioSessionDescription;
          return CardioDetailsPage(
            cardioSessionDescription: cardioSessionDescription,
          );
        }),
    Routes.cardio.routeOverview: (_) => _checkLogin(() => const RoutePage()),
    Routes.cardio.routeEdit: (context) => _checkLogin(() {
          final route = ModalRoute.of(context)?.settings.arguments as Route?;
          return RouteEditPage(
            route: route,
          );
        }),
    // diary
    Routes.diary.overview: (_) => _checkLogin(() => const DiaryPage()),
    Routes.diary.edit: (context) => _checkLogin(() {
          final diary = ModalRoute.of(context)?.settings.arguments as Diary?;
          return DiaryEditPage(diary: diary);
        })
  };

  static Map<String, Widget Function(BuildContext)> get all => _routeList;
  static Widget Function(BuildContext) get(String routeName) =>
      _routeList[routeName]!;
}

class _ActionRoutes {
  const _ActionRoutes();

  final String platformOverview = '/action/platform_overview';
  final String actionProviderOverview = '/action/action_overview';
}

class _MovementRoutes {
  const _MovementRoutes();

  final String overview = '/movement/overview';
  final String edit = '/movement/edit';
}

class _TimelineRoutes {
  const _TimelineRoutes();

  final String overview = '/timeline/overview';
}

class _MetconRoutes {
  const _MetconRoutes();

  final String overview = '/metcon/overview';
  final String details = '/metcon/details';
  final String edit = '/metcon/edit';
  final String sessionOverview = '/metcon/session_overview';
  final String sessionDetails = '/metcon/session_details';
  final String sessionEdit = '/metcon/session_edit';
}

class _CardioRoutes {
  const _CardioRoutes();

  final String overview = '/cardio/overview';
  final String trackingSettings = '/cardio/tracking_settings';
  final String tracking = '/cardio/tracking';
  final String cardioEdit = '/cardio/cardio_edit';
  final String cardioDetails = '/cardio/cardio_details';
  final String routeEdit = '/cardio/route_edit';
  final String routeOverview = '/cardio/route_overview';
}

class _StrengthRoutes {
  const _StrengthRoutes();

  final String overview = '/strength/overview';
  final String details = '/strength/details';
  final String edit = '/strength/edit';
}

class _DiaryRoutes {
  const _DiaryRoutes();

  final String overview = '/diary/overview';
  final String edit = '/diary/edit';
}
