import { useState } from 'react';
import { Alert, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { supabase } from '../lib/supabase';
import { styles } from '../styles/globalStyles';

/**
 * A reusable component for updating a supplement's dosage.
 * @param {object} props - Component props.
 * @param {string} props.stackItemId - The ID of the item in the 'user_stacks' table.
 * @param {string} props.currentDosage - The existing dosage value.
 * @param {object} props.navigation - The navigation object to go back after saving.
 */
const UpdateDosageComponent = ({ stackItemId, currentDosage, navigation }) => {
  const [dosage, setDosage] = useState(currentDosage || '');
  const [saving, setSaving] = useState(false);

  const handleUpdateDosage = async () => {
    if (!dosage) {
      Alert.alert('Error', 'Please enter a dosage value.');
      return;
    }
    setSaving(true);
    try {
      console.log(`Attempting to update stackItemId: ${stackItemId} with dosage: "${dosage}"`);

      const { data, error } = await supabase
        .from('user_stacks')
        .update({ dosage: dosage })
        .eq('id', stackItemId)
        .select(); // IMPORTANT: .select() returns the updated row for verification.

      if (error) {
        // This will now catch database errors, including RLS policy violations.
        console.error('Supabase update error:', error);
        throw error;
      }

      console.log('Update successful. Returned data:', data);
      Alert.alert('Success', 'Dosage updated successfully!');
      
      navigation.goBack();

    } catch (error) {
      Alert.alert('Error', `Failed to update dosage: ${error.message}`);
    } finally {
      setSaving(false);
    }
  };

  return (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>Your Dosage</Text>
      <TextInput
        style={styles.input}
        onChangeText={setDosage}
        value={dosage}
        placeholder="e.g., 500mg, 1 capsule daily"
      />
      <TouchableOpacity
        style={[styles.button, { marginTop: 15 }]}
        onPress={handleUpdateDosage}
        disabled={saving}
      >
        <Text style={styles.buttonText}>{saving ? 'Saving...' : 'Save Dosage'}</Text>
      </TouchableOpacity>
    </View>
  );
};

export default UpdateDosageComponent;
