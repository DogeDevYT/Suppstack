import { useEffect, useState } from 'react';
// The import for SafeAreaView is crucial and must be included here.
import { FlatList, SafeAreaView, Text, TouchableOpacity, View } from 'react-native';
import SupplementCard from '../components/SupplementCard';
import { MOCK_DATA } from '../data/mockData';
import { styles } from '../styles/globalStyles';

const HomeScreen = ({ navigation }) => {
  const [userStack, setUserStack] = useState(MOCK_DATA.userStack);

  useEffect(() => {
    const unsubscribe = navigation.addListener('focus', () => {
      setUserStack([...MOCK_DATA.userStack]);
    });
    return unsubscribe;
  }, [navigation]);

  const handleSelectSupplement = (supplementName) => {
    const supplement = MOCK_DATA.supplements.find(s => s.name === supplementName);
    if (supplement) {
      navigation.navigate('SupplementDetail', { supplementId: supplement.id });
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <FlatList
        data={userStack}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => (
          <SupplementCard
            name={item.name}
            dosage={item.dosage}
            onPress={() => handleSelectSupplement(item.name)}
          />
        )}
        ListHeaderComponent={
          <View style={{ paddingHorizontal: 20, paddingTop: 20, paddingBottom: 10 }}>
            <Text style={styles.headerTitle}>Your Supplement Stack</Text>
            <Text style={styles.headerSubtitle}>Here's what you're tracking. Tap to see details.</Text>
          </View>
        }
        contentContainerStyle={{ paddingBottom: 20 }}
        style={{ paddingHorizontal: 20 }}
      />
      <View style={{ paddingHorizontal: 20, paddingBottom: 20 }}>
        <TouchableOpacity style={[styles.button, styles.addButton]} onPress={() => navigation.navigate('AddSupplement')}>
          <Text style={styles.buttonText}>+ Add Supplement</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

export default HomeScreen;
