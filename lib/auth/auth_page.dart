
//import 'package:firebase_flutter/routes/app_router.dart';
import 'package:assignement_1_2025/routes/route_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'email_formfield.dart';
import 'password_formfield.dart';

class AuthPage extends StatefulWidget {
  final bool isLogin;
  const AuthPage({super.key, required this.isLogin});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _contactController = TextEditingController();

  bool _isLoading = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('savedEmail') ?? '';
    final remember = prefs.getBool('rememberMe') ?? false;

    if (remember) {
      _emailController.text = savedEmail;
      rememberMe = true;
      setState(() {});
    }
  }

  Future<void> _saveRememberMe(bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', remember);

    if (remember) {
      prefs.setString('savedEmail', _emailController.text);
    } else {
      prefs.remove('savedEmail');
    }
  }

  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      if (widget.isLogin) {
        await _saveRememberMe(rememberMe);

        await authService.login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        Navigator.pushReplacementNamed(
          context,
          RouteManager.homeScreen,
          arguments: _emailController.text.trim(),
        );
      } else {
        final userCredential = await authService.register(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        await userCredential.user?.updateDisplayName(_nameController.text.trim());

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'fullName': _nameController.text.trim(),
          'studentId': _studentIdController.text.trim(),
          'contactNumber': _contactController.text.trim(),
          'email': _emailController.text.trim(),
        });

        Navigator.pushReplacementNamed(context, RouteManager.authPage);
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (!widget.isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) => value!.isEmpty ? 'Required field' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _studentIdController,
                    decoration: const InputDecoration(labelText: 'Student ID'),
                    validator: (value) => value!.isEmpty ? 'Required field' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contactController,
                    decoration: const InputDecoration(labelText: 'Contact Number'),
                    validator: (value) => value!.isEmpty ? 'Required field' : null,
                  ),
                  const SizedBox(height: 16),
                ],
                EmailFormField(controller: _emailController),
                const SizedBox(height: 16),
                PasswordFormField(controller: _passwordController),
                const SizedBox(height: 16),
                if (widget.isLogin)
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value!;
                          });
                        },
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _submit(context),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.isLogin ? 'Login' : 'Register'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AuthPage(isLogin: !widget.isLogin),
                      ),
                    );
                  },
                  child: Text(widget.isLogin
                      ? 'Create an account'
                      : 'Already have an account?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// This code defines an authentication page that allows users to either log in or register.
// It uses a form with validation for email and password inputs, and conditionally shows a name input field for registration.
// The page handles form submission, showing loading indicators and error messages as needed.
