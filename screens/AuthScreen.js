import { useState } from 'react';
import { Alert, SafeAreaView, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { supabase } from '../lib/supabase';
import { styles } from '../styles/globalStyles';

export default function AuthScreen() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);

  // --- Sign In Function with Validation ---
  async function signInWithEmail() {
    // Validation Check: Ensure fields are not empty.
    if (!email || !password) {
      Alert.alert('Error', 'Please enter both email and password.');
      return;
    }
    
    setLoading(true);
    const { error } = await supabase.auth.signInWithPassword({
      email: email,
      password: password,
    });

    if (error) Alert.alert('Error', error.message);
    setLoading(false);
  }

  // --- Sign Up Function with Validation ---
  async function signUpWithEmail() {
    // Validation Check: Ensure fields are not empty.
    if (!email || !password) {
        Alert.alert('Error', 'Please enter both email and password.');
        return;
    }
    // Validation Check: Ensure password meets length requirement.
    if (password.length < 6) {
        Alert.alert('Error', 'Password must be at least 6 characters long.');
        return;
    }

    setLoading(true);
    const { data, error } = await supabase.auth.signUp({
      email: email,
      password: password,
    });

    // Check for errors from Supabase
    if (error) {
      Alert.alert('Error', error.message);
    } else if (data.session === null) {
      // This block runs if signup is successful but requires email confirmation.
      Alert.alert('Success!', 'Please check your email for a confirmation link.');
    }
    // If signup is successful and email confirmation is disabled,
    // the onAuthStateChange listener in App.js will handle the navigation automatically.

    setLoading(false);
  }

  return (
    <SafeAreaView style={styles.container}>
      <View style={[styles.loginContainer, { paddingTop: 40 }]}>
        <Text style={styles.loginTitle}>Welcome to</Text>
        <Text style={styles.loginAppName}>Supplement Advisor</Text>
        <Text style={styles.loginSubtitle}>Sign in or create an account.</Text>

        <TextInput
          style={styles.input}
          onChangeText={setEmail}
          value={email}
          placeholder="email@address.com"
          autoCapitalize={'none'}
          keyboardType="email-address"
        />
        <TextInput
          style={styles.input}
          onChangeText={setPassword}
          value={password}
          secureTextEntry={true}
          placeholder="Password (min. 6 characters)"
          autoCapitalize={'none'}
        />

        <TouchableOpacity
          style={styles.button}
          disabled={loading}
          onPress={signInWithEmail}
        >
          <Text style={styles.buttonText}>{loading ? 'Signing In...' : 'Sign In'}</Text>
        </TouchableOpacity>
        
        <TouchableOpacity
          style={[styles.button, { marginTop: 15, backgroundColor: '#4b5563' }]}
          disabled={loading}
          onPress={signUpWithEmail}
        >
          <Text style={styles.buttonText}>{loading ? 'Creating Account...' : 'Sign Up'}</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}
