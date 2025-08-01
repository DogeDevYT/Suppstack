import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Import the dotenv package
import 'package:flutter_dotenv/flutter_dotenv.dart';

// --- Placeholder Screens ---
// We'll create these as simple placeholders for now.
// In a real app, these would be in their own files.

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Login Page - Coming Soon!'),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Stack')),
      body: const Center(
        child: Text('Home Page - Coming Soon!'),
      ),
    );
  }
}

// --- Main App Entry Point ---

Future<void> main() async {
  // This ensures that Flutter widgets are initialized before we run the app.
  WidgetsFlutterBinding.ensureInitialized();

  // Load the environment variables from the .env file
  await dotenv.load(fileName: ".env");

  // Initialize Supabase.
  await Supabase.initialize(
    // Use the environment variables
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suppstack',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // This stream builder will listen for authentication changes
      // and show the correct screen.
      home: StreamBuilder<AuthState>(
        stream: supabase.auth.onAuthStateChange,
        builder: (context, snapshot) {
          // While waiting for the initial session, show a loading screen.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // If a user is logged in, show the HomePage.
          if (snapshot.hasData && snapshot.data?.session != null) {
            return const HomePage();
          }

          // Otherwise, show the LoginPage.
          return const LoginPage();
        },
      ),
    );
  }
}
