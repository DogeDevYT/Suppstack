import * as ImagePicker from 'expo-image-picker';
import { useEffect, useState } from 'react';
import { ActivityIndicator, Alert, Image, Platform, Text, TouchableOpacity, View } from 'react-native';
import { supabase } from '../lib/supabase';
import { styles } from '../styles/globalStyles';

const ImageUploader = ({ stackItemId, initialImageUrl, session, onImageUpdated }) => {
  const [uploading, setUploading] =useState(false);
  const [imageUri, setImageUri] = useState(initialImageUrl);

  useEffect(() => {
    setImageUri(initialImageUrl);
  }, [initialImageUrl]);


  const pickImage = async () => {
    const { status } = await ImagePicker.requestMediaLibraryPermissionsAsync();
    if (status !== 'granted') {
      Alert.alert('Permission required', 'Sorry, we need camera roll permissions to make this work!');
      return;
    }

    let result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: 'Images',
      allowsEditing: true,
      aspect: [1, 1],
      quality: 0.5,
    });

    if (!result.canceled) {
      uploadImage(result.assets[0]);
    }
  };

  const uploadImage = async (asset) => {
    setUploading(true);
    try {
      console.log('Preparing to upload asset:', asset);

      const formData = new FormData();
      const file = {
        uri: asset.uri,
        name: asset.uri.split('/').pop(),
        type: asset.mimeType ?? 'image/jpeg',
      };

      if (Platform.OS === 'web') {
        const response = await fetch(asset.uri);
        const blob = await response.blob();
        formData.append('file', blob, file.name);
      } else {
        formData.append('file', file);
      }

      // --- KEY CHANGE 1: Consistent File Path ---
      // We remove the timestamp to create a predictable path for each supplement image.
      // Now, any new upload for this item will target the exact same file path.
      const filePath = `${session.user.id}/${stackItemId}.jpg`;

      const { data, error: uploadError } = await supabase.storage
        .from('supplement-images')
        // --- KEY CHANGE 2: Use Upsert ---
        // The `upsert: true` option tells Supabase to overwrite the file at `filePath`
        // if it already exists, instead of creating a new one.
        .upload(filePath, formData, {
          upsert: true,
        });

      if (uploadError) {
        console.error('Supabase Upload Error:', uploadError);
        throw uploadError;
      }

      console.log('Upload successful, getting public URL...');
      const { data: { publicUrl } } = supabase.storage
        .from('supplement-images')
        .getPublicUrl(data.path);

      const { error: updateError } = await supabase.from('user_stacks').update({ image_url: publicUrl }).eq('id', stackItemId);
      if (updateError) throw updateError;
      
      setImageUri(publicUrl);
      
      if (onImageUpdated) onImageUpdated();
      Alert.alert('Success', 'Image updated successfully!');

    } catch (error) {
      Alert.alert('Upload Error', `An error occurred: ${error.message}`);
    } finally {
      setUploading(false);
    }
  };

  return (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>Your Supplement Image</Text>
      {imageUri ? (
        <Image 
          onError={(error) => console.log('Image load error:', error.nativeEvent.error)}
          source={{ uri: `${imageUri}?t=${new Date().getTime()}` }} 
          style={styles.supplementImage} 
          resizeMode="contain" 
        />
      ) : (
        <View style={styles.imagePlaceholder}><Text style={{ color: '#6b7280' }}>No Image Uploaded</Text></View>
      )}
      {uploading ? (
        <ActivityIndicator size="large" color="#1e40af" style={{ marginTop: 20 }}/>
      ) : (
        <TouchableOpacity style={[styles.button, { marginTop: 20, backgroundColor: '#1d4ed8' }]} onPress={pickImage}><Text style={styles.buttonText}>Upload/Change Image</Text></TouchableOpacity>
      )}
    </View>
  );
};

export default ImageUploader;
