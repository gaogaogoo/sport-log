
import 'package:flutter/material.dart';
import 'package:sport_log/pages/logs/logs_page.dart';
import 'package:sport_log/pages/syncing/syncing_page.dart';
import 'package:sport_log/pages/workout/metcon/new_metcon_page.dart';
import 'package:sport_log/widgets/protected_route.dart';
import 'package:sport_log/helpers/material_color_generator.dart';
import 'package:sport_log/pages/workout/workout_page.dart';
import 'package:sport_log/pages/landing/landing_page.dart';
import 'package:sport_log/pages/login/login_page.dart';
import 'package:sport_log/pages/registration/registration_page.dart';
import 'routes.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.isAuthenticatedAtStart,
  }) : super(key: key);
  final bool isAuthenticatedAtStart;

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final primarySwatch = generateMaterialColor(const Color(0xff55d2db));
    return MaterialApp(
      routes: {
        Routes.landing: (_) => const LandingPage(),
        Routes.login: (_) => const LoginPage(),
        Routes.registration: (_) => const RegistrationPage(),
        Routes.workout: (_) => ProtectedRoute(builder: (_) => const WorkoutPage()),
        Routes.newMetcon: (_) => ProtectedRoute(builder: (_) => const NewMetconPage()),
        Routes.syncing: (_) => ProtectedRoute(builder: (_) => const SyncingPage()),
        Routes.logs: (_) => ProtectedRoute(builder: (_) => const LogsPage()),
      },
      initialRoute: widget.isAuthenticatedAtStart ? Routes.workout : Routes.landing,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primarySwatch,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
    );
  }
}