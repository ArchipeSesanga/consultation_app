import 'package:assignement_1_2025/viewmodels/profile_view_model.dart';
import 'package:flutter/material.dart';

//import 'dart:io';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages

class ProfileImage extends StatelessWidget {
  final VoidCallback onImagePick;

  const ProfileImage({super.key, required this.onImagePick});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, profileViewModel, child) {
        return GestureDetector(
          onTap: onImagePick,
          child: CircleAvatar(
            radius: 50,
            backgroundImage:
                profileViewModel.image != null
                    ? FileImage(profileViewModel.image!)
                    : NetworkImage('https://picsum.photos/250?image=9')
                        as ImageProvider,
            child:
                profileViewModel.image == null
                    ? Icon(Icons.camera_alt, size: 50, color: Colors.white)
                    : null,
          ),
        );
      },
    );
  }
}
