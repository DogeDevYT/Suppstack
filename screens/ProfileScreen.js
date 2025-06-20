import { SafeAreaView, Text, TouchableOpacity, View } from 'react-native';
import { supabase } from '../lib/supabase';
import { styles } from '../styles/globalStyles';

const ProfileScreen = ({ session }) => {
  return (
    <SafeAreaView style={styles.container}>
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 }}>
        <Text style={styles.headerTitle}>Profile</Text>
        <Text style={styles.headerSubtitle}>Your email: {session?.user?.email}</Text>
        <TouchableOpacity 
          style={[styles.button, { marginTop: 40, backgroundColor: '#ef4444' }]} 
          onPress={() => supabase.auth.signOut()}
        >
          <Text style={styles.buttonText}>Sign Out</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

export default ProfileScreen;