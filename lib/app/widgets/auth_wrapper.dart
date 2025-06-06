import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:family_market/app/screens/login_screen.dart';
import 'package:family_market/app/screens/home_screen.dart';
import 'package:family_market/app/data/services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService? authService;

  const AuthWrapper({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final service = authService ?? AuthService();

    return StreamBuilder<User?>(
      stream: service.authStateChanges,
      builder: (context, snapshot) {
        // During loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // If user is logged in, navigate to HomeScreen
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }
        // If user is not logged in, navigate to LoginScreen
        return const LoginScreen();
      },
    );
  }
}
