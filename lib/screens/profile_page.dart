import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final supabase = Supabase.instance.client;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  @override
  void initState() {
    super.initState();
    _setupPushNotifications();
  }

  // TODO: Move setupPushNotifcaitons to supplement details screen or reminder_setter in order to have it in a location that makes more design sense
  Future<void> _setupPushNotifications() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    final fcmToken = await messaging.getToken();

    if (fcmToken != null) {
      // Save the FCM token to a 'profiles' table in your database
      // You will need to create this table.
      await supabase.from('profiles').upsert({
        'id': supabase.auth.currentUser!.id,
        'fcm_token': fcmToken,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => supabase.auth.signOut(),
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
