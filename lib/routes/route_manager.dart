import 'package:assignement_1_2025/views/students/login_screen.dart';
import 'package:assignement_1_2025/views/students/register_screen.dart';
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
  static const String login_screen = '/login-screen';
  static const String registrationPage = '/register';
  static const String register_screen = '/studentRegistrationScreen';
  static const String studentRegistration = '/studentRegistration';
  static const String mainPage = '/mainPage'; // Assuming you have this too

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen(email: ''));

      case addConsultationScreen:
        return MaterialPageRoute(builder: (_) => const AddConsultationScreen());

      case consultationDetailsScreen:
        final consultation = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ConsultationDetailsScreen(consultation: consultation),
        );

      case profileScreen:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case login_screen:
        return MaterialPageRoute(
          builder: (_) => const LoginView(isLogin: true),
        );

      case register_screen:
        return MaterialPageRoute(
          builder: (_) => const LoginView(isLogin: false),
        );

      case studentRegistration:
        final args =
            settings.arguments
                as Map<String, dynamic>?; // if you’re passing initial values
        return MaterialPageRoute(
          builder:
              (_) => StudentRegistrationScreen(
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
          builder:
              (_) => HomeScreen(email: ''), // replace with your main dashboard
        );

      default:
        throw const FormatException('Route not found!');
    }
  }
}
