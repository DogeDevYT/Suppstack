import { Ionicons } from '@expo/vector-icons'; // Import icons
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';

// Import Screens
import AddSupplementScreen from '../screens/AddSupplementScreen';
import DiscoverScreen from '../screens/DiscoverScreen';
import HomeScreen from '../screens/HomeScreen';
import ProfileScreen from '../screens/ProfileScreen';
import SupplementDetailScreen from '../screens/SupplementDetailScreen';

const Stack = createStackNavigator();
const Tab = createBottomTabNavigator();

/**
 * This Stack Navigator handles the flow for the "Home" tab,
 * allowing navigation from the stack list to the detail and add screens.
 */
function HomeStack({ session }) {
  return (
    <Stack.Navigator
      screenOptions={{
        headerStyle: { backgroundColor: '#f9fafb' },
        headerTintColor: '#111827',
        headerTitleStyle: { fontWeight: 'bold' },
      }}
    >
      <Stack.Screen name="YourStack" options={{ headerShown: false }}>
        {(props) => <HomeScreen {...props} session={session} />}
      </Stack.Screen>
      <Stack.Screen name="AddSupplement" options={{ title: 'Add Supplement' }}>
        {(props) => <AddSupplementScreen {...props} session={session} />}
      </Stack.Screen>
      <Stack.Screen name="SupplementDetail" component={SupplementDetailScreen} />
    </Stack.Navigator>
  );
}

/**
 * This is the main Tab Navigator for logged-in users.
 * It contains the Home stack and the other main screens.
 */
export default function AppNavigator({ session }) {
  return (
    <NavigationContainer>
      <Tab.Navigator
        screenOptions={({ route }) => ({
          headerShown: false, // We handle headers inside each stack
          tabBarIcon: ({ focused, color, size }) => {
            let iconName;
            if (route.name === 'Home') {
              iconName = focused ? 'file-tray-full' : 'file-tray-full-outline';
            } else if (route.name === 'Discover') {
              iconName = focused ? 'sparkles' : 'sparkles-outline';
            } else if (route.name === 'Profile') {
              iconName = focused ? 'person-circle' : 'person-circle-outline';
            }
            return <Ionicons name={iconName} size={size} color={color} />;
          },
          tabBarActiveTintColor: '#1e40af',
          tabBarInactiveTintColor: 'gray',
        })}
      >
        <Tab.Screen name="Home">
          {(props) => <HomeStack {...props} session={session} />}
        </Tab.Screen>
        <Tab.Screen name="Discover" component={DiscoverScreen} />
        <Tab.Screen name="Profile">
           {(props) => <ProfileScreen {...props} session={session} />}
        </Tab.Screen>
      </Tab.Navigator>
    </NavigationContainer>
  );
}
