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

class AuthPage extends StatefulWidget {
  final bool isLogin;

  const AuthPage({super.key, required this.isLogin});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers for user input
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _contactController = TextEditingController();

  // State variables
  bool _disabled = true;
  bool _isLoading = false;
  bool rememberMe = false;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();

    // Listen for changes in email & password fields to enable/disable button
    _emailController.addListener(_setDisabled);
    _passwordController.addListener(_setDisabled);
  }

  // Load saved email if "Remember Me" was checked before
  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('savedEmail') ?? '';
    final remember = prefs.getBool('rememberMe') ?? false;

    if (remember) {
      _emailController.text = savedEmail;
      rememberMe = true;
      setState(() {});
      _setDisabled();
    }
  }

  // Save or remove saved email based on Remember Me checkbox
  Future<void> _saveRememberMe(bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', remember);

    if (remember) {
      prefs.setString('savedEmail', _emailController.text);
    } else {
      prefs.remove('savedEmail');
    }
  }

  // Handle login or registration
  Future<void> _submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);

      if (widget.isLogin) {
        // Save Remember Me state
        await _saveRememberMe(rememberMe);

        if (isAdmin) {
          // Admin login
          await authService.logAdminWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
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
          Navigator.pushReplacementNamed(
            context,
            RouteManager.homeScreen,
            arguments: _emailController.text.trim(),
          );
        }
      } else {
        // Registration logic
        await authService.registerUserWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
          
        );

        Navigator.pushReplacementNamed(
          context,
          RouteManager.homeScreen,
          arguments: _emailController.text.trim(),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Disable/enable login/register button
  void _setDisabled() {
    setState(() {
      _disabled = _emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Show these fields only on Register screen
                if (!widget.isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Required field' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _studentIdController,
                    decoration: const InputDecoration(labelText: 'Student ID'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contactController,
                    decoration:
                        const InputDecoration(labelText: 'Contact Number'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                ],

                // Email input
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value!.isEmpty ? 'Email is required' : null,
                ),
                const SizedBox(height: 16),

                // Password input
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) =>
                      value!.isEmpty ? 'Password is required' : null,
                ),
                const SizedBox(height: 16),

                // Checkboxes for Remember Me & Login as Admin (only on Login screen)
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
                IgnorePointer(
                  ignoring: _disabled,
                  child: Opacity(
                    opacity: _disabled ? 0.5 : 1.0,
                    child: ElevatedButton(
                      onPressed: (_isLoading || _disabled)
                          ? null
                          : () => _submit(context),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : Text(widget.isLogin ? 'Login' : 'Register'),
                    ),
                  ),
                ),

                // Switch between Login/Register
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    widget.isLogin
                        ? RouteManager.registrationPage
                        : RouteManager.authPage,
                  ),
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