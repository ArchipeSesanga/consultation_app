 /*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/profile_view_model.dart';

class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return UpdateProfileDialog();
          },
        );
      },
      child: const Text('Update Details'),
    );
  }
}

class UpdateProfileDialog extends StatefulWidget {
  @override
  _UpdateProfileDialogState createState() => _UpdateProfileDialogState();
}

class _UpdateProfileDialogState extends State<UpdateProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late String name, role, email, phone;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Profile'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              onSaved: (value) => name = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Role'),
              validator: (value) => value!.isEmpty ? 'Enter your role' : null,
              onSaved: (value) => role = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value!.contains('@') ? null : 'Enter a valid email',
              onSaved: (value) => email = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              validator: (value) => value!.isEmpty ? 'Enter your phone number' : null,
              onSaved: (value) => phone = value!,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Provider.of<ProfileViewModel>(context, listen: false)
                ..updateName(name)
                ..updateRole(role)
                ..updateEmail(email)
                ..updatePhoneNumber(phone);
              Navigator.pop(context);
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
