
 /*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */
class Consultation {
  final String id;
  final String date;  // Change to DateTime
  final String time; // Change to TimeOfDay
  final String description;
  final String topic;

  Consultation({
    required this.id,
    required this.date,
    required this.time,
    required this.description,
    required this.topic,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,  // Convert DateTime to string for storage
      'time': time, // Convert TimeOfDay to string for storage
      'description': description,
      'topic': topic,
    };
  }
}
