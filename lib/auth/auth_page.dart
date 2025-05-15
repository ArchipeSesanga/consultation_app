/*
Student Numbers: 221003314,  221049485, 222052243  ,  220014909, 221032075  221005490
Student Names:   AM Sesanga, BD Davis,  E.B Phungula, T.E Sello, Mutlana K.P  S.P Vilane */
import 'package:assignement_1_2025/routes/route_manager.dart';
import 'package:assignement_1_2025/services/auth_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'email_formfield.dart';
import 'password_formfield.dart';

// The main authentication page, used for both login and registration
class AuthPage extends StatefulWidget {
  final bool isLogin; // Determines if the page is for login or registration
  const AuthPage({super.key, required this.isLogin});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Form and controllers for user input
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  // State variables
  bool _isLoading = false; // Shows loading indicator during async actions
  bool rememberMe = false; // For "Remember Me" checkbox
  bool isAdmin = false;    // For "Login as Admin" checkbox

  @override
  void initState() {
    super.initState();
    _loadSavedEmail(); // Load saved email if "Remember Me" was checked
  }

  // Loads saved email from local storage if "Remember Me" was checked
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

  // Saves or removes the email in local storage based on "Remember Me"
  Future<void> _saveRememberMe(bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', remember);

    if (remember) {
      prefs.setString('savedEmail', _emailController.text);
    } else {
      prefs.remove('savedEmail');
    }
  }

  // Handles login or registration when the form is submitted
  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return; // Validate form

    setState(() => _isLoading = true); // Show loading

    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      if (widget.isLogin) {
        // Save email if "Remember Me" is checked
        await _saveRememberMe(rememberMe);

        if (isAdmin) {
          // Admin login
          await authService.logAdminWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

          // Navigate to admin dashboard, passing the email
          Navigator.pushReplacementNamed(
            context,
            RouteManager.adminDashboard,
            arguments: _emailController.text.trim(),
          );
        } else {
          // Regular user login
          await authService.logUserWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

          // Navigate to home screen, passing the email
          Navigator.pushReplacementNamed(
            context,
            RouteManager.homeScreen,
            arguments: _emailController.text.trim(),
          );
        }
      }
      // Registration logic would go here if needed
    } catch (e) {
      // Show error message if login/registration fails
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false); // Hide loading
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
          child: Column(
            children: [
              // Show name field only on registration
              if (!widget.isLogin)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator:
                      (value) => value!.isEmpty ? 'Required field' : null,
                ),
              const SizedBox(height: 16),
              // Email input
              EmailFormField(controller: _emailController),
              const SizedBox(height: 16),
              // Password input
              PasswordFormField(controller: _passwordController),
              const SizedBox(height: 16),
              // Show checkboxes only on login
              if (widget.isLogin)
                Row(
                  children: [
                    // "Remember Me" checkbox
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    const Text('Remember Me'),
                    // "Login as Admin" checkbox
                    Checkbox(
                      value: isAdmin,
                      onChanged: (value) {
                        setState(() {
                          isAdmin = value!;
                        });
                      },
                    ),
                    const Text('Login as Admin'),
                  ],
                ),
              const SizedBox(height: 24),
              // Login/Register button
              ElevatedButton(
                onPressed: _isLoading ? null : () => _submit(context),
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : Text(widget.isLogin ? 'Login' : 'Register'),
              ),
              // Switch between login and registration
              TextButton(
                onPressed:
                    () => Navigator.pushReplacementNamed(
                      context,
                      widget.isLogin
                          ? RouteManager.registrationPage
                          : RouteManager.authPage,
                    ),
                child: Text(
                  widget.isLogin
                      ? 'Create an account'
                      : 'Already have an account?',
                ),
              ),
              // Button to go to admin registration page
              TextButton(
                onPressed: () => Navigator.pushNamed(context, RouteManager.adminRegister),
                child: const Text('Register as Admin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
