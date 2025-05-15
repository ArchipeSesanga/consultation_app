/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */

import 'package:assignement_1_2025/routes/route_manager.dart';
import 'package:assignement_1_2025/views/admin/bookings_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:assignement_1_2025/services/auth_service.dart';
import 'package:provider/provider.dart';

class AdminDashboard extends StatelessWidget {
  final String email;
  const AdminDashboard({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authService = Provider.of<AuthService>(
                context,
                listen: false,
              );
              await authService
                  .signOut(); // <-- implement this in your AuthService
              Navigator.pushReplacementNamed(context, RouteManager.authPage);
            },
          ),

          /*IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Log out and navigate to login screen
              await Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/auth-page', // Or RouteManager.authPage if you use RouteManager
                (route) => false,
              );
            },
          )*/
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 53, 159, 131),
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Students'),
              onTap: () {
                // TODO: Navigate to users list
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_online_outlined),
              title: const Text('Bookings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookingsListScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // TODO: Navigate to settings
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Welcome, Admin!\n$email',
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
