import 'package:flutter/material.dart';
import 'package:sport_log/data_provider/user_state.dart';
import 'package:sport_log/helpers/material_color_generator.dart';
import 'package:sport_log/models/metcon/metcon_description.dart';
import 'package:sport_log/models/movement/movement_description.dart';
import 'package:sport_log/models/strength/strength_session_description.dart';
import 'package:sport_log/pages/landing/landing_page.dart';
import 'package:sport_log/pages/login/login_page.dart';
import 'package:sport_log/pages/movements/edit_movement_page.dart';
import 'package:sport_log/pages/movements/movements_page.dart';
import 'package:sport_log/pages/registration/registration_page.dart';
import 'package:sport_log/pages/syncing/actions_page.dart';
import 'package:sport_log/pages/workout/metcon/edit_metcon_page.dart';
import 'package:sport_log/pages/workout/strength/edit_strength_session_page.dart';
import 'package:sport_log/pages/workout/workout_page.dart';
import 'package:sport_log/widgets/protected_route.dart';

import 'routes.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final primarySwatch = generateMaterialColor(const Color(0xff55d2db));
    bool isAuthenticated = UserState.instance.currentUser != null;
    return MaterialApp(
      routes: {
        Routes.landing: (_) => const LandingPage(),
        Routes.login: (_) => const LoginPage(),
        Routes.registration: (_) => const RegistrationPage(),
        Routes.workout: (_) =>
            ProtectedRoute(builder: (_) => const WorkoutPage()),
        Routes.editMetcon: (_) => ProtectedRoute(builder: (context) {
              final arg = ModalRoute.of(context)?.settings.arguments;
              return EditMetconPage(
                initialMetcon: (arg is MetconDescription) ? arg : null,
              );
            }),
        Routes.actions: (_) =>
            ProtectedRoute(builder: (_) => const ActionsPage()),
        Routes.movements: (_) =>
            ProtectedRoute(builder: (_) => const MovementsPage()),
        Routes.editMovement: (_) => ProtectedRoute(builder: (context) {
              final arg = ModalRoute.of(context)?.settings.arguments;
              if (arg is MovementDescription) {
                return EditMovementPage(initialMovement: arg);
              } else if (arg is String) {
                return EditMovementPage.fromName(initialName: arg);
              }
              return EditMovementPage.newMovement();
            }),
        Routes.editStrengthSession: (context) =>
            ProtectedRoute(builder: (context) {
              final dynamic arg = ModalRoute.of(context)?.settings.arguments;
              return EditStrengthSessionPage(
                  description: arg is StrengthSessionDescription ? arg : null);
            }),
      },
      initialRoute: isAuthenticated ? Routes.workout : Routes.landing,
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: primarySwatch,
        primaryColor: primarySwatch[500],
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primarySwatch,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        if (child != null) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
