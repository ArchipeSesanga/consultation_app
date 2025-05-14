 /*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */
import 'dart:io';

class ProfileData {
  String name;
  String role;
  String email;
  String phoneNumber;
  File? image;

  ProfileData({
    required this.name,
    required this.role,
    required this.email,
    required this.phoneNumber,
    this.image,
  });
}
