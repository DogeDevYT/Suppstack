import AsyncStorage from '@react-native-async-storage/async-storage';
import { createClient } from '@supabase/supabase-js';
import 'react-native-url-polyfill/auto';

// --- Get these from your Supabase project settings ---
// Go to Project Settings > API
const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_PUBLIC_KEY;

// createClient is used to connect to your Supabase project.
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  // The auth configuration object.
  auth: {
    // Use AsyncStorage for session persistence in React Native.
    storage: AsyncStorage,
    // Automatically refreshes the token to keep the user signed in.
    autoRefreshToken: true,
    // Whether to persist the user's session.
    persistSession: true,
    // Supabase specific setting for React Native to not parse URL hashes.
    detectSessionInUrl: false,
  },
});