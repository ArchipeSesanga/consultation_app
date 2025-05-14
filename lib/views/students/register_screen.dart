 /*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */
import 'package:assignement_1_2025/services/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final String? studentId;
  final String? initialEmail;
  final String? initialPassword;
  final String? initialContact;
  final Function(String studentId, String email, String password, String contact) onSubmit;

  const RegisterScreen({
    super.key,
    this.studentId,
    this.initialEmail,
    this.initialPassword,
    this.initialContact,
    required this.onSubmit,
  });
  

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _contactController = TextEditingController();

  bool isFormValid = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.studentId != null) _studentIdController.text = widget.studentId!;
    if (widget.initialEmail != null) _emailController.text = widget.initialEmail!;
    if (widget.initialPassword != null) _passwordController.text = widget.initialPassword!;
    if (widget.initialContact != null) _contactController.text = widget.initialContact!;

    _studentIdController.addListener(validateForm);
    _emailController.addListener(validateForm);
    _passwordController.addListener(validateForm);
    _contactController.addListener(validateForm);
  }

  void validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != isFormValid) {
      setState(() {
        isFormValid = isValid;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await widget.onSubmit(
        _studentIdController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _contactController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.studentId == null ? 'Register Student' : 'Update Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _studentIdController,
                  decoration: const InputDecoration(labelText: 'Student ID'),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (!value.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    if (value.length < 8) return 'Minimum 8 characters';
                    if (!value.contains('@')) return 'Must contain "@"';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(labelText: 'Contact Number'),
                  validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),
  ElevatedButton(
    onPressed: isFormValid
    ? () async {
        if (_formKey.currentState!.validate()) {
          final error = await _auth.register(
            _emailController.text.trim(),
            _passwordController.text.trim(), email: '',
          );

          if (error == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful')),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)),
            );
          }
        }
      }
    : null,

    child: Text(widget.studentId == null ? 'Register' : 'Update'),
  ),
                ElevatedButton(
                  onPressed: isFormValid && !isLoading ? _handleSubmit : null,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.studentId == null ? 'Register Student' : 'Update Student'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

  
          
              
              
              
      