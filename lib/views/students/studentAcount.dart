import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registered Students'),
        backgroundColor: Colors.green,
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(email),
                      if (studentId.isNotEmpty) Text('ID: $studentId'),
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
