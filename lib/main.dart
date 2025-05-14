/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */

import 'package:assignement_1_2025/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'routes/route_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDyXmVzFO4KetIEhDHk9rs1MSby0pNzAb4",
        authDomain: "consultationapp-9f02b.firebaseapp.com",
        projectId: "consultationapp-9f02b",
        storageBucket: "consultationapp-9f02b.appspot.com", // I noticed you had a typo here: it should be `.appspot.com`
        messagingSenderId: "352229037942",
        appId: "1:352229037942:web:02152a00d901acbcfd4c57",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        // Add other providers if needed
      ],
      child: const MyApp(),
    ),
  );
} // 👈✅ Closing main()

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
          elevation: 2,
          centerTitle: true,
          backgroundColor: const Color(0xFF205759),
          titleTextStyle: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: RouteManager.authPage,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
