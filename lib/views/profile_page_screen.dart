 /*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075    221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */

import 'package:assignement_1_2025/viewmodels/profile_view_model.dart';
import 'package:assignement_1_2025/views/widgets/profile_details.dart';
import 'package:assignement_1_2025/views/widgets/profile_image.dart';
import 'package:assignement_1_2025/views/widgets/update_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Provider.of<ProfileViewModel>(context, listen: false)
          .updateImage(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Page')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 100), // Adjust as needed
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileImage(onImagePick: _pickImage),
                  const SizedBox(height: 30),
                  ProfileDetails(),
                  const SizedBox(height: 20),
                  UpdateButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
