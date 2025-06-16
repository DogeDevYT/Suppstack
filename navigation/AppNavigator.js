import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';

// Import Screens
import AddSupplementScreen from '../screens/AddSupplementScreen';
import HomeScreen from '../screens/HomeScreen';
import SupplementDetailScreen from '../screens/SupplementDetailScreen';

const Stack = createStackNavigator();

export default function AppNavigator({ session }) {
  return (
    <NavigationContainer>
      <Stack.Navigator
        screenOptions={{
          headerStyle: { backgroundColor: '#f9fafb' },
          headerTintColor: '#111827',
          headerTitleStyle: { fontWeight: 'bold' },
        }}
      >
        <Stack.Screen name="Home" options={{ headerShown: false }}>
          {(props) => <HomeScreen {...props} session={session} />}
        </Stack.Screen>
        <Stack.Screen name="AddSupplement" options={{ title: 'Add Supplement' }}>
          {(props) => <AddSupplementScreen {...props} session={session} />}
        </Stack.Screen>
        {/*
          The title will now be set by the SupplementDetailScreen itself,
          removing the dependency on mock data here.
        */}
        <Stack.Screen
          name="SupplementDetail"
          component={SupplementDetailScreen}
        />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
