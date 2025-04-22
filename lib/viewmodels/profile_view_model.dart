/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */
import 'package:assignement_1_2025/models/profile.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class ProfileViewModel with ChangeNotifier {
  ProfileData _profileData = ProfileData(
    name: '',
    role: '',
    email: '',
    phoneNumber: '',
  );

  String get name => _profileData.name;
  String get role => _profileData.role;
  String get email => _profileData.email;
  String get phoneNumber => _profileData.phoneNumber;
  File? get image => _profileData.image;

  void updateName(String newName) {
    _profileData.name = newName;
    notifyListeners();
  }

  void updateRole(String newRole) {
    _profileData.role = newRole;
    notifyListeners();
  }

  void updateEmail(String newEmail) {
    _profileData.email = newEmail;
    notifyListeners();
  }

  void updatePhoneNumber(String newPhoneNumber) {
    _profileData.phoneNumber = newPhoneNumber;
    notifyListeners();
  }

  void updateImage(File newImage) {
    _profileData.image = newImage;
    notifyListeners();
  }
}
