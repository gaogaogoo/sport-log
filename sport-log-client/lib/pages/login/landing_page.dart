import 'package:flutter/material.dart';
import 'package:sport_log/defaults.dart';
import 'package:sport_log/pages/login/welcome_screen.dart';
import 'package:sport_log/routes.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WelcomeScreen(
      content: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.login);
              },
              child: const Text("Login"),
            ),
          ),
          Defaults.sizedBox.horizontal.big,
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.registration);
              },
              child: const Text("Register"),
            ),
          ),
        ],
      ),
    );
  }
}
