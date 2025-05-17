/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075    221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// this class is used to display the list of registered students
// and allow the admin to edit or delete their details

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Students'),
        backgroundColor: const Color(0xFF205759),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('students').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No students found.'));
          }

          final studentDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: studentDocs.length,
            itemBuilder: (context, index) {
              final studentData = studentDocs[index].data() as Map<String, dynamic>;

              final name = studentData['name'] ?? 'No Name';
              final email = studentData['email'] ?? 'No Email';
              final studentId = studentData['studentId'] ?? '';

             return Card(
  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
  child: ListTile(
    leading: const Icon(Icons.person),
    title: Text(name),
    subtitle: Text(email),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
       
         //  Show edit delete
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('students')
                .doc(studentDocs[index].id)
                .delete();
          },
        ),
      ],
    ),
  ),
);

            },
          );
        },
      ),
    );
  }
}
