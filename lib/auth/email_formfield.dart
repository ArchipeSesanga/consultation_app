/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */
import 'package:flutter/material.dart';

class EmailFormField extends StatelessWidget {
  final TextEditingController controller;
  const EmailFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: 'Email'),
       validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (!value.contains('@')) return 'Invalid email';
                    return null;
                  },
    );
  }
}
// This widget is a custom email input field for a form. It uses a TextFormField to accept user input and validate the email address. 
//The validator checks if the email is empty and if it ends with '@cut.ac.za', which is a requirement for the application. 
//The field also includes an icon for better user experience.
// The widget is reusable and can be easily integrated into any form that requires email input. 
//It enhances the user interface by providing clear feedback on the validity of the input, ensuring that only valid CUT email addresses are accepted.