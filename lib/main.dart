/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */

import 'package:assignement_1_2025/services/auth_service.dart';
import 'package:assignement_1_2025/viewmodels/auth_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'routes/route_manager.dart';
import 'viewmodels/consultation_view_model.dart';
import 'viewmodels/profile_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb){
    await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDyXmVzFO4KetIEhDHk9rs1MSby0pNzAb4",
      authDomain: "consultationapp-9f02b.firebaseapp.com",
      projectId: "consultationapp-9f02b",
      storageBucket: "consultationapp-9f02b.firebasestorage.app",
      messagingSenderId: "352229037942",
      appId: "1:352229037942:web:02152a00d901acbcfd4c57",
    ),
  );
  }//End if 
  else{
    await Firebase.initializeApp();
  }
  

  
    runApp(
  MultiProvider(
    providers: [
      Provider<AuthService>(
        create: (_) => AuthService(),
      ),
      ChangeNotifierProvider<AuthViewModel>(
        create: (_) => AuthViewModel(),
      ),
      ChangeNotifierProvider(
        create: (_) => ConsultationViewModel(),
      ),
      ChangeNotifierProvider(
        create: (_) => ProfileViewModel(),
      ),
    ],
    child: const MyApp(),
  ),
);

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consultation Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          elevation: 2, // Soft shadow for depth
          centerTitle: true,
          backgroundColor: Color(0xFF205759), // Cozy academic greenish-teal
          titleTextStyle: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text for contrast
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ), // White icons for a clean look
        ),
      ),
      
      initialRoute: RouteManager.authPage,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
