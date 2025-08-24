// frontend/oozy/lib/login_screen.dart

import 'package:flutter/material.dart';
import 'package:oozy/event_list_screen.dart';
import 'package:oozy/services/api_service.dart'; // NEW: Import our ApiService
import 'signup_screen.dart';
import 'app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Our "memory boxes" for the text fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // NEW: Add an instance of our ApiService
  final ApiService _apiService = ApiService();

  // NEW: A boolean to track the loading state for our login button
  bool _isLoading = false;

  String? _emailErrorText;
  String? _passwordErrorText;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    // ... (no changes in this function)
    if (_emailController.text.isNotEmpty &&
        !_emailController.text.contains('@')) {
      setState(() {
        _emailErrorText = 'Please enter a valid email address.';
      });
    } else {
      setState(() {
        _emailErrorText = null;
      });
    }
  }

  void _validatePassword() {
    // ... (no changes in this function)
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text.length < 6) {
      setState(() {
        _passwordErrorText = 'Password must be at least 6 characters long.';
      });
    } else {
      setState(() {
        _passwordErrorText = null;
      });
    }
  }

  // NEW: This is our new login handler function
  void _handleLogin() async {
    // Show a loading indicator
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Call the login method from our ApiService
    final bool success = await _apiService.login(email, password);

    // Stop the loading indicator
    setState(() {
      _isLoading = false;
    });

    // Check if the login was successful and the widget is still in the tree
    if (success && mounted) {
      // Navigate to the next screen on success
      Navigator.pushReplacement( // Use pushReplacement to prevent going back to login
        context,
        MaterialPageRoute(builder: (context) => const EventListScreen()),
      );
    } else {
      // Show an error message on failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Failed: Incorrect email or password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              // ... (no changes in this part of the UI)
              'oozy',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              // ... (no changes in this part of the UI)
              'Login/Sign up using phone number',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: AppColors.primaryText),
            ),
            const SizedBox(height: 48.0),
            TextFormField(
              // ... (no changes in this widget)
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryText,
                hintText: 'Email',
                hintStyle: const TextStyle(color: AppColors.background),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                errorText: _emailErrorText,
              ),
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: AppColors.background),
            ),
            const SizedBox(height: 8.0),
            TextFormField(
              // ... (no changes in this widget)
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.primaryText,
                hintText: 'Password',
                hintStyle: const TextStyle(color: AppColors.background),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                errorText: _passwordErrorText,
              ),
              style: const TextStyle(color: AppColors.background),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              // MODIFIED: We now call our _handleLogin function.
              // We also disable the button while loading.
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryText,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              // MODIFIED: Show a loading circle or the text
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.background),
                    )
                  : const Text('Login',
                      style: TextStyle(color: AppColors.background)),
            ),
            TextButton(
              // ... (no changes in this widget)
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
              child: const Text(
                'Sign Up with Phone number',
                style: TextStyle(color: AppColors.primaryText),
              ),
            )
          ],
        ),
      ),
    );
  }
}
