/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075 
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P   */
class Consultation {
  final String id;
  final String studentId; // Who submitted it
  final String lecturer; // Change to Lecturer type
  final String date; // Change to DateTime
  final String time; // Change to TimeOfDay
  final String topic;
  final String description;

  Consultation({
    required this.id,
    required this.studentId,
    required this.lecturer,
    required this.date,
    required this.time,
    required this.topic,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'lecture': lecturer,
      'date': date, // Convert DateTime to string for storage
      'time': time, // Convert TimeOfDay to string for storage
      'topic': topic,
      'description': description,
    };
  }

  factory Consultation.fromMap(Map<String, dynamic> map) {
    return Consultation(
      id: map['id'],
      studentId: map['studentId'],
      lecturer: map['lecture'],
      date: map['date'], // Convert string back to DateTime
      time: map['time'], // Convert string back to TimeOfDay
      topic: map['topic'],
      description: map['description'],
    );
  }
}
