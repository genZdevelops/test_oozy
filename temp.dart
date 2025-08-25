// lib/signup_screen.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'services/api_service.dart';
import 'user_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  bool _isLoading = false;

  // Create a TextEditingController for each field
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _interestsController = TextEditingController();
  final _meetupStyleController = TextEditingController();
  final _purposeController = TextEditingController();
  final _availabilityController = TextEditingController();
  final _locationsController = TextEditingController();

  @override
  void dispose() {
    // Dispose all controllers to free up resources
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _interestsController.dispose();
    _meetupStyleController.dispose();
    _purposeController.dispose();
    _availabilityController.dispose();
    _locationsController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    // First, validate the form. If it's not valid, do nothing.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Create a UserModel instance from the controller's text
    final newUser = UserModel(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      phone: _phoneController.text,
      interests: _interestsController.text,
      meetupStyle: _meetupStyleController.text,
      purpose: _purposeController.text,
      availability: _availabilityController.text,
      preferredLocations: _locationsController.text,
    );

    // Call the register method from our ApiService
    final result = await _apiService.register(newUser);
    
    setState(() {
      _isLoading = false;
    });
    
    if (!mounted) return; // Check if the widget is still in the tree

    // Show feedback based on the result
    if (result == "Success") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please log in.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(); // Go back to the login screen
    } else {
      // Show the specific error message from the server
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration Failed: $result'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Join oozy',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primaryText),
              ),
              const SizedBox(height: 32.0),
              // Use a helper for cleaner code
              _buildTextField(_nameController, 'Name'),
              _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
              _buildTextField(_passwordController, 'Password', obscureText: true),
              _buildTextField(_phoneController, 'Phone Number', keyboardType: TextInputType.phone),
              _buildTextField(_interestsController, 'Interests (e.g., painting, reading)'),
              _buildTextField(_meetupStyleController, 'Meetup Style (e.g., casual, formal)'),
              _buildTextField(_purposeController, 'Purpose (e.g., networking, friendship)'),
              _buildTextField(_availabilityController, 'Availability (e.g., weekends, evenings)'),
              _buildTextField(_locationsController, 'Preferred Locations'),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Sign Up', style: TextStyle(color: AppColors.primaryText)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to reduce code duplication for TextFormFields
  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.primaryText),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.secondaryText),
          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.secondaryText), borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppColors.primary), borderRadius: BorderRadius.circular(8)),
          errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(8)),
          focusedErrorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red, width: 2), borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          if (label == 'Email' && !value.contains('@')) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
    );
  }
}
