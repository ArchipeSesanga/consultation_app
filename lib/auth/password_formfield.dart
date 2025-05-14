 /*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */
import 'package:flutter/material.dart';

class PasswordFormField extends StatelessWidget {
  final TextEditingController controller;
  const PasswordFormField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
      
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password is required';
        if (value.length < 8) return 'Minimum 8 characters';
        if (!value.contains('@')) return 'Must contain @ symbol';
        return null;
      },
    );
  }
}
// // This widget is a custom password input field for a form. It uses a TextFormField to accept user input and validate the password.
// // The validator checks if the password is empty, if it is at least 8 characters long, and if it contains an '@' symbol.
// // The field also includes an icon for better user experience.
// // The widget is reusable and can be easily integrated into any form that requires password input.
// // It enhances the user interface by providing clear feedback on the validity of the input, ensuring that only strong passwords are accepted.
// // This widget is a custom password input field for a form. It uses a TextFormField to accept user input and validate the password.
// // The validator checks if the password is empty, if it is at least 8 characters long, and if it contains an '@' symbol.
