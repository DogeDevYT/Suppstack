import * as Notifications from 'expo-notifications';
import { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, Platform, View } from 'react-native';
import { supabase } from './lib/supabase';
import AppNavigator from './navigation/AppNavigator';
import AuthScreen from './screens/AuthScreen';

// Configure notification handling for when the app is in the foreground
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: false,
  }),
});

async function registerForPushNotificationsAsync() {
  let token;
  const { status: existingStatus } = await Notifications.getPermissionsAsync();
  let finalStatus = existingStatus;

  if (existingStatus !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync();
    finalStatus = status;
  }
  if (finalStatus !== 'granted') {
    Alert.alert('Permission required', 'Please enable push notifications to use the reminder feature.');
    return;
  }
  // You can get the Expo Push Token here if you want to send notifications from a server
  // token = (await Notifications.getExpoPushTokenAsync()).data;
  // console.log(token);

  if (Platform.OS === 'android') {
    Notifications.setNotificationChannelAsync('default', {
      name: 'default',
      importance: Notifications.AndroidImportance.MAX,
      vibrationPattern: [0, 250, 250, 250],
      lightColor: '#FF231F7C',
    });
  }
}

export default function App() {
  const [session, setSession] = useState(null);
  const [initializing, setInitializing] = useState(true);

  useEffect(() => {
    // Request notification permissions
    registerForPushNotificationsAsync();

    // Check for an existing session when the app starts.
    supabase.auth.getSession().then(({ data: { session } }) => {
      setSession(session);
      setInitializing(false);
    });

    const { data: authListener } = supabase.auth.onAuthStateChange((_event, session) => {
      setSession(session);
      setInitializing(false);
    });

    return () => {
      authListener?.unsubscribe();
    };
  }, []);

  if (initializing) {
    return (
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', backgroundColor: '#f9fafb' }}>
        <ActivityIndicator size="large" color="#1e40af" />
      </View>
    );
  }

  return session && session.user ? <AppNavigator key={session.user.id} session={session} /> : <AuthScreen />;
}
