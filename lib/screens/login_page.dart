import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// --- KEY CHANGE: Import the services package for clipboard access ---
import 'package:flutter/services.dart';

// Get a reference to the Supabase client
final supabase = Supabase.instance.client;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // --- Sign In with Email and Password ---
  Future<void> _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter both email and password.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on AuthException catch (error) {
      _showErrorSnackBar(error.message);
    } catch (error) {
      _showErrorSnackBar('An unexpected error occurred.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- Sign Up with Email and Password ---
  Future<void> _signUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorSnackBar('Please enter both email and password.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      final result = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (result.session == null) {
        _showSuccessSnackBar('Success! Please check your email for a confirmation link.');
      }
    } on AuthException catch (error) {
      _showErrorSnackBar(error.message);
    } catch (error) {
      _showErrorSnackBar('An unexpected error occurred.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- Sign In with Google ---
  Future<void> _googleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final serverClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];
      final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];

      if (serverClientId == null || iosClientId == null) {
        throw 'Google Client IDs are not configured in your .env file.';
      }

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: kIsWeb ? serverClientId : (Platform.isIOS ? iosClientId : null),
        serverClientId: kIsWeb ? null : serverClientId,
      );
      
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'No ID token from Google!';
      }

      await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (error) {
      _showErrorSnackBar('Google Sign-In failed: ${error.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- Password Reset ---
  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      _showErrorSnackBar('Please enter your email to reset your password.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await supabase.auth.resetPasswordForEmail(_emailController.text.trim());
      _showSuccessSnackBar('Password reset link sent! Please check your email.');
    } on AuthException catch (error) {
      _showErrorSnackBar(error.message);
    } catch (error) {
      _showErrorSnackBar('An unexpected error occurred.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Helper functions to show snack bars
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        // --- KEY CHANGE: Add a SnackBarAction to copy the text ---
        action: SnackBarAction(
          label: 'COPY',
          textColor: Colors.white,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: message));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error copied to clipboard')),
            );
          },
        ),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suppstack')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isLoading ? null : _signIn,
            child: Text(_isLoading ? 'Loading...' : 'Sign In'),
          ),
          TextButton(
            onPressed: _isLoading ? null : _signUp,
            child: const Text('Create Account'),
          ),
          TextButton(
            onPressed: _isLoading ? null : _resetPassword,
            child: const Text('Forgot Password?'),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          ElevatedButton.icon(
              onPressed: _isLoading ? null : _googleSignIn,
              icon: const Icon(Icons.login), // Replace with a Google icon later
              label: const Text('Sign In with Google'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          )
        ],
      ),
    );
  }
}
