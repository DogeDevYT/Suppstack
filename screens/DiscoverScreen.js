import { SafeAreaView, Text, View } from 'react-native';
import { styles } from '../styles/globalStyles';

const DiscoverScreen = () => {
  return (
    <SafeAreaView style={styles.container}>
      <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
        <Text style={styles.headerTitle}>Discover</Text>
        <Text style={styles.headerSubtitle}>Trending supplements will be here.</Text>
      </View>
    </SafeAreaView>
  );
};

export default DiscoverScreen;