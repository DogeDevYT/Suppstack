import { SafeAreaView, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { styles } from '../styles/globalStyles';

// The import for SafeAreaView is crucial and must be included here.

const LoginScreen = ({ navigation }) => (
  <SafeAreaView style={styles.container}>
    <View style={styles.loginContainer}>
      <Text style={styles.loginTitle}>Welcome to</Text>
      <Text style={styles.loginAppName}>Supplement Advisor</Text>
      <Text style={styles.loginSubtitle}>Your trusted source for supplement advice.</Text>
      <TextInput style={styles.input} placeholder="Email (mock)" keyboardType="email-address" autoCapitalize="none" />
      <TextInput style={styles.input} placeholder="Password (mock)" secureTextEntry />
      <TouchableOpacity style={styles.button} onPress={() => navigation.replace('AppHome')}>
        <Text style={styles.buttonText}>Login</Text>
      </TouchableOpacity>
      <TouchableOpacity>
        <Text style={styles.linkText}>Don't have an account? Sign Up</Text>
      </TouchableOpacity>
    </View>
  </SafeAreaView>
);

export default LoginScreen;