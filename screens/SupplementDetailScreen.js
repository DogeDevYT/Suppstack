import { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, FlatList, SafeAreaView, Text, View } from 'react-native';
import HypeMeter from '../components/HypeMeter';
import { supabase } from '../lib/supabase';
import { styles } from '../styles/globalStyles';

const SupplementDetailScreen = ({ route, navigation }) => {
  const { supplementId } = route.params;
  const [supplement, setSupplement] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchSupplementDetails = async () => {
      try {
        setLoading(true);
        const { data, error } = await supabase
          .from('supplements')
          .select('*')
          .eq('id', supplementId)
          .single(); // Use .single() to get one object instead of an array

        if (error) throw error;
        
        if (data) {
          setSupplement(data);
          // Set the screen title dynamically after fetching the data
          navigation.setOptions({ title: data.name });
        }
      } catch (error) {
        Alert.alert('Error', `Failed to fetch supplement details: ${error.message}`);
      } finally {
        setLoading(false);
      }
    };

    fetchSupplementDetails();
  }, [supplementId, navigation]);

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <ActivityIndicator size="large" color="#1e40af" style={{ flex: 1 }} />
      </SafeAreaView>
    );
  }

  if (!supplement) {
    return <SafeAreaView style={styles.container}><Text>Supplement not found!</Text></SafeAreaView>;
  }

  return (
    <SafeAreaView style={styles.container}>
      <FlatList
        ListHeaderComponent={
          <View style={styles.detailContainer}>
            {/* The title is now in the header, so we can remove it from here. */}
            <Text style={styles.detailDescription}>{supplement.description}</Text>
            <View style={styles.section}>
              <Text style={styles.sectionTitle}>Hype Meter™</Text>
              <HypeMeter {...supplement} />
            </View>
            <View style={styles.section}>
              <Text style={styles.sectionTitle}>Analysis & Recommendation</Text>
              <Text style={styles.detailDescription}>{supplement.recommendation}</Text>
            </View>
          </View>
        }
        data={[]}
        renderItem={null}
        contentContainerStyle={{paddingBottom: 40}}
      />
    </SafeAreaView>
  );
};

export default SupplementDetailScreen;
