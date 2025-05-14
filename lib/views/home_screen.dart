 /*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../routes/route_manager.dart';
import '../viewmodels/consultation_view_model.dart';
import '../viewmodels/profile_view_model.dart';

class HomeScreen extends StatelessWidget {
   final String email; // User's email passed from the login page
  const HomeScreen({super.key, required this.email});
  

  @override
  Widget build(BuildContext context) {
    final consultations =
        Provider.of<ConsultationViewModel>(context).consultations;
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: const Color(0xFF205759),
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: profileViewModel.image != null
                  ? FileImage(profileViewModel.image!)
                  : const NetworkImage('https://picsum.photos/250?image=9')
                      as ImageProvider,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('lib/assets/images/bodyBackground.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black54,
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
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Register Student Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, RouteManager.studentRegistration);
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
                      horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: consultations.isEmpty
                    ? const Center(
                        child: Text(
                          'No consultations booked yet',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: consultations.length,
                        itemBuilder: (context, index) {
                          final consultation = consultations[index];
                          return Card(
                            color: Colors.white.withOpacity(0.9),
                            child: ListTile(
                              title: Text(consultation.description),
                              subtitle: Text(consultation.topic),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.pushNamed(
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
        onPressed: () =>
            Navigator.pushNamed(context, RouteManager.addConsultationScreen),
        backgroundColor: const Color(0xFF205759),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF205759),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade300,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
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
