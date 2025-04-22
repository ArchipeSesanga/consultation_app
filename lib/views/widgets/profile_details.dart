import 'package:assignement_1_2025/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, profileViewModel, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              profileViewModel.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              profileViewModel.role,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Email: ${profileViewModel.email}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Phone: ${profileViewModel.phoneNumber}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        );
      },
    );
  }
}
