import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import 'login.dart';
import 'dashboard.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF121212),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFF4D4D)),
            ),
          );
        }

        // If user is logged in, show dashboard
        if (snapshot.hasData && snapshot.data != null) {
          return const DashboardScreen();
        }

        // If user is not logged in, show login screen
        return const LoginScreen();
      },
    );
  }
}
