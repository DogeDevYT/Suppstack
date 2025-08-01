import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Get a reference to the Supabase client
final supabase = Supabase.instance.client;

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current user from the session
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display the user's email if available
            if (user != null) ...[
              Center(child: Text('Signed in as:', style: Theme.of(context).textTheme.titleMedium)),
              const SizedBox(height: 8),
              Center(child: Text(user.email ?? 'No email found', style: Theme.of(context).textTheme.titleLarge)),
              const SizedBox(height: 40),
            ],
            
            // The Sign Out button
            ElevatedButton(
              onPressed: () async {
                // This will sign the user out and the onAuthStateChange listener
                // in main.dart will automatically navigate to the LoginPage.
                await supabase.auth.signOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // A distinct color for a destructive action
              ),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
