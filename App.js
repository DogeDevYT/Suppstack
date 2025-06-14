import { useEffect, useState } from 'react';
import { supabase } from './lib/supabase';
import AppNavigator from './navigation/AppNavigator';
import AuthScreen from './screens/AuthScreen';

/**
 * The root component of the app.
 * It manages the user session and determines which navigator to show.
 */
export default function App() {
  const [session, setSession] = useState(null);

  useEffect(() => {
    // Check for an existing session when the app starts.
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
    });

    // Listen for changes in authentication state (sign in, sign out).
    const { data: authListener } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session);
    });

    // Cleanup the listener when the component unmounts.
    return () => {
      authListener?.unsubscribe();
    };
  }, []);

  // Conditionally render the correct screen based on the session.
  // If a session exists, show the main app. Otherwise, show the auth screen.
  return session && session.user ? <AppNavigator key={session.user.id} /> : <AuthScreen />;
}