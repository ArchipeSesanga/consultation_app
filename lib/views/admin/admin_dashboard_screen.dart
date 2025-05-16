/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */

import 'package:assignement_1_2025/routes/route_manager.dart';
import 'package:assignement_1_2025/views/admin/bookings_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:assignement_1_2025/services/auth_service.dart';
import 'package:provider/provider.dart';


/// Admin dashboard screen
/// This screen serves as the main interface for admin users.
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
            tooltip: 'Log out',
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteManager.authPage,
                (route) => false,
              );
            },
          ),
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
             // TODO: Navigate to students list screen
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Students'),
              onTap: () {
               
                Navigator.pushNamed(context, RouteManager.studentAccount);
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Register New Admin'),
              onTap: () {
                Navigator.pushNamed(context, RouteManager.adminRegister);
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
                // TODO: Navigate to settings screen
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Welcome ${email.isNotEmpty ? email.split('@').first : 'Admin'}',
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
