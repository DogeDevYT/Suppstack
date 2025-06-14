import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';

// Import Screens
import AddSupplementScreen from '../screens/AddSupplementScreen';
import HomeScreen from '../screens/HomeScreen';
import SupplementDetailScreen from '../screens/SupplementDetailScreen';

// Import Mock Data for screen titles
import { MOCK_DATA } from '../data/mockData';

const Stack = createStackNavigator();

/**
 * This navigator contains all the screens for a logged-in user.
 */
export default function AppNavigator() {
  return (
    <NavigationContainer>
      <Stack.Navigator
        screenOptions={{
          headerStyle: { backgroundColor: '#f9fafb' },
          headerTintColor: '#111827',
          headerTitleStyle: { fontWeight: 'bold' },
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
    </NavigationContainer>
  );
}
