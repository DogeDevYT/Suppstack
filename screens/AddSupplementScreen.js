import { useState } from 'react';
// The import for SafeAreaView is crucial and must be included here.
import { FlatList, SafeAreaView, TextInput, View } from 'react-native';
import SupplementCard from '../components/SupplementCard';
import { MOCK_DATA } from '../data/mockData';
import { styles } from '../styles/globalStyles';

const AddSupplementScreen = ({ navigation }) => {
  const [searchQuery, setSearchQuery] = useState('');
  const allSupplements = MOCK_DATA.supplements;

  const filteredSupplements = allSupplements.filter(supplement =>
    supplement.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

  const handleAddSupplement = (supplement) => {
    if (!MOCK_DATA.userStack.find(s => s.name === supplement.name)) {
      MOCK_DATA.userStack.push({ id: Date.now().toString(), name: supplement.name, dosage: 'Tap to set' });
    }
    navigation.goBack();
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={{ padding: 20 }}>
        <TextInput
          style={styles.searchInput}
          placeholder="Search for supplements..."
          value={searchQuery}
          onChangeText={setSearchQuery}
        />
      </View>
      <FlatList
        data={filteredSupplements}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <SupplementCard
            name={item.name}
            onPress={() => handleAddSupplement(item)}
          />
        )}
        contentContainerStyle={{ paddingHorizontal: 20 }}
      />
    </SafeAreaView>
  );
};

export default AddSupplementScreen;