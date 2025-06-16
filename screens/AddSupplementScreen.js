import { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, FlatList, SafeAreaView, TextInput, View } from 'react-native';
import SupplementCard from '../components/SupplementCard';
import { supabase } from '../lib/supabase';
import { styles } from '../styles/globalStyles';

const AddSupplementScreen = ({ navigation, session }) => {
  const [loading, setLoading] = useState(true);
  const [adding, setAdding] = useState(false); // State to track when a supplement is being added
  const [searchQuery, setSearchQuery] = useState('');
  const [allSupplements, setAllSupplements] = useState([]);

  // --- Fetch all supplements from the database ---
  async function fetchAllSupplements() {
    try {
      setLoading(true);
      const { data, error } = await supabase
        .from('supplements')
        .select('*');

      if (error) throw error;
      if (data) setAllSupplements(data);
    } catch (error) {
      Alert.alert('Error', error.message);
    } finally {
      setLoading(false);
    }
  }

  // --- Add a new supplement to the user's stack ---
  async function handleAddSupplement(supplement) {
    // Prevent multiple clicks while an add operation is in progress
    if (adding) return;

    try {
      setAdding(true);
      const { error } = await supabase
        .from('user_stacks')
        .insert({
          user_id: session.user.id,
          supplement_id: supplement.id,
          dosage: 'Tap to set' // Default dosage
        });
      
      if (error) {
        // Handle unique constraint violation gracefully
        if (error.code === '23505') {
          Alert.alert('Info', `${supplement.name} is already in your stack.`);
        } else {
          throw error;
        }
      } else {
        // On success, navigate back to the previous screen.
        navigation.goBack();
      }

    } catch (error) {
      Alert.alert('Error', error.message);
    } finally {
      setAdding(false);
    }
  }

  useEffect(() => {
    fetchAllSupplements();
  }, []);

  const filteredSupplements = allSupplements.filter(supplement =>
    supplement.name.toLowerCase().includes(searchQuery.toLowerCase())
  );

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
      
      {loading ? <ActivityIndicator size="large" color="#1e40af" /> : (
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
      )}
    </SafeAreaView>
  );
};

export default AddSupplementScreen;
