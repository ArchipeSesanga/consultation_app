 /*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */

class Booking {
  final String studentId;
  final String lecturerId;
  final DateTime date;
  final String topic;

  Booking({
    required this.studentId,
    required this.lecturerId,
    required this.date,
    required this.topic, required String lecturer, required String id, required String status,
  });

  Map<String, dynamic> toJson() => {
        'studentId': studentId,
        'lecturerId': lecturerId,
        'date': date.toIso8601String(),
        'topic': topic,
      };
}
