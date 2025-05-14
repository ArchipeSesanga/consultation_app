/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes/route_manager.dart';
import '../viewmodels/consultation_view_model.dart';
import '../viewmodels/profile_view_model.dart'; // Import profile ViewModel

class HomeScreen extends StatelessWidget {
  final String email; // User's email passed from the login page
  const HomeScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final consultations =
        Provider.of<ConsultationViewModel>(context).consultations;
    final profileViewModel = Provider.of<ProfileViewModel>(
      context,
    ); // Get profile data

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: const Color(0xFF205759), // Cozy academic greenish-teal
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0), // Add some space
            child: CircleAvatar(
              radius: 20, // Adjust size
              backgroundImage:
                  profileViewModel.image != null
                      ? FileImage(profileViewModel.image!)
                      : const NetworkImage('https://picsum.photos/250?image=9')
                          as ImageProvider,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'lib/assets/images/bodyBackground.png',
            ), // Add your image here
            fit: BoxFit.cover, // Covers the entire screen
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(
                0.4,
              ), // Adds a slight dark overlay for readability
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Easy Consultation Management',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text for contrast
                ),
              ),
              const SizedBox(height: 20),

              // Register Student Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    RouteManager.studentRegistration,
                  );
                },
                icon: const Icon(Icons.person_add),
                label: const Text('Register Student'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF205759),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child:
                    consultations.isEmpty
                        ? const Center(
                          child: Text(
                            'No consultations booked yet',
                            style: TextStyle(color: Colors.white), // White text
                          ),
                        )
                        : ListView.builder(
                          itemCount: consultations.length,
                          itemBuilder: (context, index) {
                            final consultation = consultations[index];
                            return Card(
                              color: Colors.white.withOpacity(
                                0.9,
                              ), // Card with soft opacity for contrast
                              child: ListTile(
                                title: Text(consultation.description),
                                subtitle: Text(consultation.topic),
                                trailing: const Icon(Icons.chevron_right),
                                onTap:
                                    () => Navigator.pushNamed(
                                      context,
                                      RouteManager.consultationDetailsScreen,
                                      arguments: consultation.toMap(),
                                    ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => Navigator.pushNamed(
              context,
              RouteManager.addConsultationScreen,
            ),
        backgroundColor: const Color(0xFF205759), // Modern teal academic color
        elevation: 6, // Soft shadow for a sleek effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            16,
          ), // Slightly rounded for a modern look
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white, // White for contrast
          size: 28, // Larger icon for better visibility
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF205759), // Cozy academic teal
        selectedItemColor: Colors.white, // Highlighted icon/text color
        unselectedItemColor:
            Colors.grey.shade300, // Muted color for inactive items
        elevation: 8, // Adds a floating effect
        type:
            BottomNavigationBarType.fixed, // Ensures labels are always visible
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, RouteManager.profileScreen);
          }
        },
      ),
    );
  }
}
