 /*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */
class StudentModel {
  final String id;
  final String email;
  final String contactNumber;
  final bool isAdmin;

  StudentModel({
    required this.id,
    required this.email,
    required this.contactNumber,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'contactNumber': contactNumber,
      'isAdmin': isAdmin,
    };
  }

  factory StudentModel.fromMap(String id, Map<String, dynamic> map) {
    return StudentModel(
      id: id,
      email: map['email'],
      contactNumber: map['contactNumber'],
      isAdmin: map['isAdmin'] ?? false,
    );
  }
}
