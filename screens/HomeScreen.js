import { useFocusEffect } from '@react-navigation/native';
import { useCallback, useState } from 'react';
import { ActivityIndicator, Alert, FlatList, SafeAreaView, Text, TouchableOpacity, View } from 'react-native';
import SupplementCard from '../components/SupplementCard';
import { supabase } from '../lib/supabase';
import { styles } from '../styles/globalStyles';

const HomeScreen = ({ navigation, session }) => {
  const [loading, setLoading] = useState(true);
  const [userStack, setUserStack] = useState([]);
  const [fetchError, setFetchError] = useState(null);

  // By logging the session prop right at the top of the component,
  // we can see exactly what data it's receiving when it renders.
  console.log('HomeScreen rendered with session user ID:', session?.user?.id);

  useFocusEffect(
    useCallback(() => {
      const fetchUserStack = async () => {
        setFetchError(null);
        setLoading(true);

        try {
          // This check is now the primary guard.
          // If the session prop is invalid when the screen focuses,
          // we immediately show the error state.
          if (!session?.user) {
            console.log('No user session found on focus.');
            setFetchError('No user session available. Please try logging in again.');
            setLoading(false);
            return;
          }

          const { data, error, status } = await supabase
            .from('user_stacks')
            .select(`
              id,
              dosage,
              supplements (id, name, description)
            `)
            .eq('user_id', session.user.id)
            .order('created_at', { ascending: true });

          if (error && status !== 406) {
            throw error;
          }

          if (data) {
            const formattedData = data.map(item => ({
              id: item.id,
              name: item.supplements.name,
              dosage: item.dosage,
              supplement_id: item.supplements.id,
            }));
            setUserStack(formattedData);
          }
        } catch (error) {
          Alert.alert('Error fetching data', error.message);
          setFetchError(error.message);
        } finally {
          setLoading(false);
        }
      };

      fetchUserStack();

      return () => {
        // This function is for cleanup when the screen goes out of focus.
      };
    }, [session]) // The effect depends on the session prop.
  );

  async function handleRemoveSupplement(stackItemId) {
    try {
      const { error } = await supabase
        .from('user_stacks')
        .delete()
        .eq('id', stackItemId);
        
      if (error) throw error;
      setUserStack(prevStack => prevStack.filter(item => item.id !== stackItemId));
    } catch (error) {
      Alert.alert('Error', error.message);
    }
  }

  // --- Conditional Rendering based on state ---

  if (loading) {
    return (
      <SafeAreaView style={styles.container}>
        <ActivityIndicator size="large" color="#1e40af" style={{ flex: 1 }} />
      </SafeAreaView>
    );
  }

  if (fetchError) {
    return (
      <SafeAreaView style={styles.container}>
        <View style={{ flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20 }}>
            <Text style={{ textAlign: 'center', color: '#ef4444', marginBottom: 20 }}>{fetchError}</Text>
            <TouchableOpacity 
              style={styles.button} 
              onPress={() => supabase.auth.signOut()}
            >
              <Text style={styles.buttonText}>Go to Login</Text>
            </TouchableOpacity>
        </View>
      </SafeAreaView>
    );
  }

  return (
    <SafeAreaView style={styles.container}>
      <View style={{ paddingHorizontal: 20, paddingTop: 20, paddingBottom: 10 }}>
        <Text style={styles.headerTitle}>Your Supplement Stack</Text>
      </View>
      
      <FlatList
        data={userStack}
        keyExtractor={(item) => item.id}
        renderItem={({ item }) => (
          <View>
            <SupplementCard
              name={item.name}
              dosage={item.dosage}
              onPress={() => navigation.navigate('SupplementDetail', { 
                supplementId: item.supplement_id,
                stackItemId: item.id,
                currentDosage: item.dosage 
              })}
            />
            <TouchableOpacity
              style={styles.removeButton}
              onPress={() => handleRemoveSupplement(item.id)}
            >
              <Text style={styles.removeButtonText}>Remove</Text>
            </TouchableOpacity>
          </View>
        )}
        style={{ paddingHorizontal: 20 }}
        ListEmptyComponent={<Text style={{textAlign: 'center', color: '#6b7280', marginTop: 40}}>Your stack is empty. Add a supplement to get started!</Text>}
      />
      
      <View style={{ paddingHorizontal: 20, paddingBottom: 20, paddingTop: 10 }}>
        <TouchableOpacity style={[styles.button, styles.addButton]} onPress={() => navigation.navigate('AddSupplement')}>
          <Text style={styles.buttonText}>+ Add Supplement</Text>
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
};

export default HomeScreen;
