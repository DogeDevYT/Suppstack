import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';

// Import Screens
import AddSupplementScreen from '../screens/AddSupplementScreen';
import HomeScreen from '../screens/HomeScreen';
import LoginScreen from '../screens/LoginScreen';
import SupplementDetailScreen from '../screens/SupplementDetailScreen';

// Import Mock Data to get titles
import { MOCK_DATA } from '../data/mockData';

const Stack = createStackNavigator();

// A separate stack for the main app allows for different header styles, etc.
const AppStack = () => {
  return (
    <Stack.Navigator
      screenOptions={{
        headerStyle: {
          backgroundColor: '#f9fafb',
        },
        headerTintColor: '#111827',
        headerTitleStyle: {
          fontWeight: 'bold',
        },
      }}
    >
      <Stack.Screen name="Home" component={HomeScreen} options={{ headerShown: false }} />
      <Stack.Screen name="AddSupplement" component={AddSupplementScreen} options={{ title: 'Add Supplement' }} />
      <Stack.Screen
        name="SupplementDetail"
        component={SupplementDetailScreen}
        options={({ route }) => ({
          title: MOCK_DATA.supplements.find(s => s.id === route.params.supplementId)?.name || 'Details',
        })}
      />
    </Stack.Navigator>
  )
}

/**
 * The root navigator for the entire application.
 * It handles the initial authentication flow and the main app flow.
 */
export default function AppNavigator() {
  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        <Stack.Screen name="Login" component={LoginScreen} />
        <Stack.Screen name="AppHome" component={AppStack} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
