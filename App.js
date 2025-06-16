import { useEffect, useState } from 'react';
import { ActivityIndicator, View } from 'react-native';
import { supabase } from './lib/supabase';
import AppNavigator from './navigation/AppNavigator';
import AuthScreen from './screens/AuthScreen';

/**
 * The root component of the app.
 * It manages the user session and determines which navigator to show.
 */
export default function App() {
  const [session, setSession] = useState(null);
  // This new state will track if we are waiting for the initial session check.
  const [initializing, setInitializing] = useState(true);

  useEffect(() => {
    // Check for an existing session when the app starts.
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      // Once the check is complete, we are no longer initializing.
      setInitializing(false);
    });

    // Listen for changes in authentication state (sign in, sign out).
    const { data: authListener } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session);
      // We are also no longer initializing if the auth state changes.
      setInitializing(false);
    });

    // Cleanup the listener when the component unmounts.
    return () => {
      authListener?.unsubscribe();
    };
  }, []);

  // While we are checking for the session, show a loading indicator.
  if (initializing) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: '#f9fafb' }}>
        <ActivityIndicator size="large" color="#1e40af" />
      </View>
    );
  }

  // Once the check is done, conditionally render the correct screen.
  // The key prop is crucial here to force a re-render of the navigator on login/logout.
  return session && session.user ? <AppNavigator key={session.user.id} session={session} /> : <AuthScreen />;
}
