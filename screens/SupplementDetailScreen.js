import { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, FlatList, SafeAreaView, Text, View } from 'react-native';
import HypeMeter from '../components/HypeMeter';
import ImageUploader from '../components/ImageUploader';
import ReminderComponent from '../components/ReminderComponent';
import UpdateDosageComponent from '../components/UpdateDosageComponent';
import { supabase } from '../lib/supabase';
import { styles } from '../styles/globalStyles';

const SupplementDetailScreen = ({ route, navigation }) => {
  const { supplementId, stackItemId, currentDosage, currentImageUrl, session } = route.params;
  const [supplement, setSupplement] = useState(null);
  const [loading, setLoading] = useState(true);

  // --- This is the complete data fetching logic ---
  useEffect(() => {
    // Check if supplementId is valid before fetching
    if (!supplementId) {
      Alert.alert('Error', 'No supplement ID provided.');
      setLoading(false);
      return;
    }

    const fetchSupplementDetails = async () => {
      try {
        setLoading(true);
        const { data, error } = await supabase
          .from('supplements')
          .select('*')
          .eq('id', supplementId)
          .single(); // Use .single() to get one object, not an array

        if (error) {
          // If no rows are found, .single() throws an error, which is good.
          throw error;
        }
        
        if (data) {
          setSupplement(data);
          // Set the screen title in the header bar dynamically
          navigation.setOptions({ title: data.name });
        }
      } catch (error) {
        Alert.alert('Error', `Failed to fetch supplement details: ${error.message}`);
        setSupplement(null); // Ensure supplement is null on error
      } finally {
        setLoading(false);
      }
    };

    fetchSupplementDetails();
    // This effect runs whenever the supplementId changes
  }, [supplementId, navigation]);

  // Show a loading spinner while data is being fetched
  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <ActivityIndicator size="large" color="#1e40af" style={{ flex: 1 }} />
      </SafeAreaView>
    );
  }

  // If fetching failed and supplement is still null, show the error message
  if (!supplement) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
          <Text>Supplement not found!</Text>
        </View>
      </SafeAreaView>
    );
  }

  // Once data is loaded, render the full component
  return (
    <SafeAreaView style={styles.container}>
      <FlatList
        ListHeaderComponent={
          <View style={styles.detailContainer}>
            <Text style={styles.detailDescription}>{supplement.description}</Text>
            
            <ImageUploader 
              stackItemId={stackItemId}
              initialImageUrl={currentImageUrl}
              session={session} 
              onImageUpdated={() => {
                // We don't need to refetch here as the image is on a different table
              }} 
            />

            <UpdateDosageComponent 
              stackItemId={stackItemId}
              currentDosage={currentDosage}
              navigation={navigation}
            />

            <ReminderComponent supplementName={supplement.name} />
            <View style={styles.section}><Text style={styles.sectionTitle}>Hype Meter™</Text><HypeMeter {...supplement} /></View>
            <View style={styles.section}><Text style={styles.sectionTitle}>Analysis & Recommendation</Text><Text style={styles.detailDescription}>{supplement.recommendation}</Text></View>
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
