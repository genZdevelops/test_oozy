// lib/create_event_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'services/api_service.dart';
import 'event_model.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  // A global key to identify our form and assist with validation
  final _formKey = GlobalKey<FormState>();

  // Controllers to manage the text in each TextFormField
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _tagsController = TextEditingController();
  final _groupSizeController = TextEditingController();
  final _durationController = TextEditingController();

  bool _isLoading = false;

  // Instance of our ApiService
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _titleController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _tagsController.dispose();
    _groupSizeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  // Method to handle the form submission
  Future<void> _submitForm() async {
    // Validate all form fields
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show a loading indicator
      });

      // Create an Event object from the form data
      final newEvent = Event(
        title: _titleController.text,
        date: _dateController.text,
        location: _locationController.text,
        interestTags: _tagsController.text,
        groupSize: int.tryParse(_groupSizeController.text) ?? 0,
        duration: _durationController.text,
      );

      // Call the ApiService to create the event
      final success = await _apiService.createEvent(newEvent);

      setState(() {
        _isLoading = false; // Hide loading indicator
      });

      // Show feedback to the user and navigate back on success
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Go back to the previous screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create event. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an Event'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.primaryText,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(_titleController, 'Title'),
              const SizedBox(height: 16),
              _buildTextField(_dateController, 'Date (e.g., YYYY-MM-DD)'),
              const SizedBox(height: 16),
              _buildTextField(_locationController, 'Location'),
              const SizedBox(height: 16),
              _buildTextField(_tagsController, 'Interest Tags (comma separated)'),
              const SizedBox(height: 16),
              _buildTextField(
                _groupSizeController,
                'Group Size',
                keyboardType: TextInputType.number,
                // Ensure only numbers can be entered
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 16),
              _buildTextField(_durationController, 'Duration (e.g., 2 hours)'),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Create Event',
                        style: TextStyle(color: AppColors.primaryText),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to reduce code duplication for TextFormFields
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: AppColors.primaryText),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.secondaryText),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.secondaryText),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a $label';
        }
        return null;
      },
    );
  }
}
