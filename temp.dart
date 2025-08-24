// lib/create_event_screen.dart -> inside the _submitForm method

// ... inside the if (success) block ...

if (success) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Event created successfully!'),
      backgroundColor: Colors.green,
    ),
  );
  // ✨ CHANGE THIS LINE
  Navigator.of(context).pop(true); // Go back and send 'true' as a result
} else {
// ...
