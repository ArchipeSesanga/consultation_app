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



// The main authentication page, responsible for both Login and Registration screens
class AuthPage extends StatefulWidget {
  final bool isLogin; // Determines if this page is for Login (true) or Register (false)

  const AuthPage({super.key, required this.isLogin});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Form key to manage form validation and submission state
  final _formKey = GlobalKey<FormState>();

  // Text editing controllers for each form input field
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _contactController = TextEditingController();

  // State variables for form interactivity
  bool _disabled = true; // Disable the login/register button by default
  bool _isLoading = false; // Controls loading spinner during async operations
  bool rememberMe = false; // State for 'Remember Me' checkbox
  bool isAdmin = false; // State for 'Login as Admin' checkbox

  @override
  void initState() {
    super.initState();
    _loadSavedEmail(); // Load saved email if Remember Me was enabled previously

    // Attach listeners to email and password fields to enable/disable button dynamically
    _emailController.addListener(_setDisabled);
    _passwordController.addListener(_setDisabled);
  }

  // Loads previously saved email and rememberMe preference from local storage
  Future<void> _loadSavedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('savedEmail') ?? '';
    final remember = prefs.getBool('rememberMe') ?? false;

    // If Remember Me was enabled, pre-fill email and checkbox state
    if (remember) {
      _emailController.text = savedEmail;
      rememberMe = true;
      setState(() {});
      _setDisabled();
    }
  }

  // Saves or removes email in local storage based on Remember Me checkbox state
  Future<void> _saveRememberMe(bool remember) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', remember);

    if (remember) {
      prefs.setString('savedEmail', _emailController.text);
    } else {
      prefs.remove('savedEmail');
    }
  }

  // Handles login or registration process when form is submitted
  Future<void> _submit(BuildContext context) async {
    // First, check if the form is valid
    if (!_formKey.currentState!.validate()) return;

    // Show loading indicator during asynchronous call
    setState(() => _isLoading = true);

    try {
      // Access AuthService using Provider package
      final authService = Provider.of<AuthService>(context, listen: false);

      if (widget.isLogin) {
        // If 'Remember Me' is checked, save email
        await _saveRememberMe(rememberMe);

        if (isAdmin) {
          // Admin login attempt
          await authService.logAdminWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

          // Redirect to admin dashboard if successful
          Navigator.pushReplacementNamed(
            context,
            RouteManager.adminDashboard,
            arguments: _emailController.text.trim(),
          );
        } else {
          // Regular student login
          await authService.logUserWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

          // Redirect to home screen if successful
          Navigator.pushReplacementNamed(
            context,
            RouteManager.homeScreen,
            arguments: _emailController.text.trim(),
          );
        }
      } else {
        // Registration logic for new users
        await authService.registerUserWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
         
        );

        // Redirect to home screen after successful registration
        Navigator.pushReplacementNamed(
          context,
          RouteManager.homeScreen,
          arguments: _emailController.text.trim(),
        );
      }
    } catch (e) {
      // Catch any error and display it via a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      // Hide loading indicator once done
      setState(() => _isLoading = false);
    }
  }

  // Checks if email and password fields are both non-empty to enable/disable submit button
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
        automaticallyImplyLeading: false, // Hide back button on AppBar
        title: Text(widget.isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey, // Assign form key for validation control
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Only show Name, Student ID and Contact fields during registration
                if (!widget.isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Full name is required' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _studentIdController,
                    decoration: const InputDecoration(labelText: 'Student ID'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Student ID is required' : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _contactController,
                    decoration: const InputDecoration(labelText: 'Contact Number'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Contact number is required' : null,
                  ),
                  const SizedBox(height: 16),
                ],

                // Email input (always visible)
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value!.isEmpty ? 'Email is required' : null,
                ),
                const SizedBox(height: 16),

                // Password input (always visible)
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Hide text as user types
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) =>
                      value!.isEmpty ? 'Password is required' : null,
                ),
                const SizedBox(height: 16),

                // Show 'Remember Me' and 'Login as Admin' checkboxes only on login page
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

                // Login/Register button with disabled state and loading indicator
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

                // Link to switch between Login and Register pages
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
