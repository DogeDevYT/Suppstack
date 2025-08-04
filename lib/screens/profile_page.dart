import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

final supabase = Supabase.instance.client;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = false;

  // This function now gets called when the user presses the button
  Future<void> _setupPushNotifications() async {
    setState(() => _isLoading = true);
    try {
      final messaging = FirebaseMessaging.instance;
      // Request permission from the user
      await messaging.requestPermission();
      // Get the unique device token
      final fcmToken = await messaging.getToken();

      if (fcmToken != null) {
        // Save the token to the user's profile in Supabase
        await supabase.from('profiles').upsert({
          'id': supabase.auth.currentUser!.id,
          'fcm_token': fcmToken,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notifications have been enabled for this device.'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw 'Could not get a notification token for this device.';
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting up notifications: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            if (user != null) ...[
              Center(child: Text('Signed in as:', style: Theme.of(context).textTheme.titleMedium)),
              const SizedBox(height: 8),
              Center(child: Text(user.email ?? 'No email found', style: Theme.of(context).textTheme.titleLarge)),
              const SizedBox(height: 40),
            ],
            
            // --- New Button to Setup Notifications ---
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _setupPushNotifications,
              icon: const Icon(CupertinoIcons.bell),
              label: Text(_isLoading ? 'Setting Up...' : 'Enable Supplement Reminders'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: () => supabase.auth.signOut(),
              icon: const Icon(CupertinoIcons.arrow_right_to_line),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              label: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
