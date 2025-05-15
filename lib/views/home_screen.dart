/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */

import 'package:assignement_1_2025/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../routes/route_manager.dart';
import '../viewmodels/consultation_view_model.dart';
import '../viewmodels/profile_view_model.dart';
import '../models/consultation.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Use a RefreshIndicator to implement pull-to-refresh
  Future<void> _refreshData() async {
    await Provider.of<ConsultationViewModel>(
      context,
      listen: false,
    ).loadConsultations();
  }

  @override
  Widget build(BuildContext context) {
    final consultations =
        Provider.of<ConsultationViewModel>(context).consultations;
    final profileViewModel = Provider.of<ProfileViewModel>(context);

    // Group consultations by date
    Map<String, List<Consultation>> groupedConsultations = {};
    for (var consultation in consultations) {
      final dateString = DateFormat('yyyy-MM-dd').format(consultation.date);
      if (!groupedConsultations.containsKey(dateString)) {
        groupedConsultations[dateString] = [];
      }
      groupedConsultations[dateString]!.add(consultation);
    }

    // Sort dates
    final sortedDates = groupedConsultations.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
        centerTitle: true,
        backgroundColor: const Color(0xFF205759),
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            final authService = Provider.of<AuthService>(
              context,
              listen: false,
            );
            await authService.signOut();
            Navigator.pushReplacementNamed(context, RouteManager.authPage);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
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
            image: AssetImage('lib/assets/images/bodyBackground.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Personalized welcome message
              Text(
                'Welcome, ${widget.email.isNotEmpty ? widget.email.split('@').first : "Student"}!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Your Consultations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child:
                    consultations.isEmpty
                        ? const Center(
                          child: Text(
                            'No consultations booked yet',
                            style: TextStyle(
                              color: Color.fromARGB(255, 80, 79, 79),
                            ),
                          ),
                        )
                        : RefreshIndicator(
                          onRefresh: _refreshData,
                          child: ListView.builder(
                            itemCount: sortedDates.length,
                            itemBuilder: (context, index) {
                              final date = sortedDates[index];
                              final dateConsultations =
                                  groupedConsultations[date]!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Date header
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      _formatDateHeader(date),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // Consultations for this date
                                  ...dateConsultations.map((consultation) {
                                    return Card(
                                      color: Colors.white.withOpacity(0.9),
                                      margin: const EdgeInsets.only(
                                        bottom: 8.0,
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          consultation.topic,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          '${consultation.lecturer.name} • ${consultation.time.format(context)}',
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Status indicator
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 4.0,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    consultation.status ==
                                                            'confirmed'
                                                        ? Colors.green
                                                            .withOpacity(0.2)
                                                        : Colors.amber
                                                            .withOpacity(0.2),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                consultation.status ==
                                                        'confirmed'
                                                    ? 'Confirmed'
                                                    : 'Pending',
                                                style: TextStyle(
                                                  color:
                                                      consultation.status ==
                                                              'confirmed'
                                                          ? Colors.green
                                                          : Colors.amber[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.chevron_right),
                                          ],
                                        ),
                                        onTap:
                                            () => Navigator.pushNamed(
                                              context,
                                              RouteManager
                                                  .consultationDetailsScreen,
                                              arguments: consultation,
                                            ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                              );
                            },
                          ),
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
        backgroundColor: const Color(0xFF205759),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF205759),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade300,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
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

  String _formatDateHeader(String dateStr) {
    final date = DateFormat('yyyy-MM-dd').parse(dateStr);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEEE, MMMM d').format(date);
    }
  }
}
