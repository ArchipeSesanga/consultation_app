/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */

import 'package:flutter/material.dart';
import '../views/add_consultation_screen.dart';
import '../views/consultation_details_screen.dart';
import '../views/home_screen.dart';
import '../views/profile_page_screen.dart';

class RouteManager {
  static const String homeScreen = '/';
  static const String addConsultationScreen = '/addConsultation';
  static const String consultationDetailsScreen = '/consultationDetails';
  static const String profileScreen = '/profile';
  static const String login_screen = '/login_screen';
  static const String registrationScreen = '/register';

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
      default:
        throw const FormatException('Route not found!');
    }
  }
}
