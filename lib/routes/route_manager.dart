import 'package:assignement_1_2025/auth/auth_page.dart';
import "package:assignement_1_2025/views/students/register_screen.dart";
import 'package:flutter/material.dart';
import '../views/add_consultation_screen.dart';
import '../views/consultation_details_screen.dart';
import '../views/home_screen.dart';
import '../views/profile_page_screen.dart';

class RouteManager {
  // Route names
  static const String homeScreen = '/';
  static const String addConsultationScreen = '/addConsultation';
  static const String consultationDetailsScreen = '/consultationDetails';
  static const String profileScreen = '/profile';
  static const String authPage = '/auth-page';
  static const String registrationPage = '/register';
  static const String studentRegistration = '/studentRegistration';
  static const String mainPage = '/mainPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen(email: ''));
      case addConsultationScreen:
        return MaterialPageRoute(builder: (_) => const AddConsultationScreen());

      case consultationDetailsScreen:
        final consultation = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) =>
              ConsultationDetailsScreen(consultation: consultation),
        );

      case profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case authPage:
        return MaterialPageRoute(
          builder: (_) => const AuthPage(isLogin: true),
        );

      case registrationPage:
        return MaterialPageRoute(
          builder: (_) => const AuthPage(isLogin: false),
        );

      case studentRegistration:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(
            studentId: args?['studentId'],
            initialEmail: args?['initialEmail'],
            initialPassword: args?['initialPassword'],
            initialContact: args?['initialContact'],
            onSubmit: args?['onSubmit'],
          ),
        );

      case mainPage:
        final email = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => HomeScreen(email: email ?? ''),
        );

      default:
        throw const FormatException('Route not found!');
    }
  }
}
