import * as Notifications from 'expo-notifications';
import { useState } from 'react';
import { Alert, Text, TouchableOpacity, View } from 'react-native';
import { styles } from '../styles/globalStyles';

/**
 * A component to set a daily reminder for a supplement.
 * @param {{ supplementName: string }} props
 */
const ReminderComponent = ({ supplementName }) => {
  const [loading, setLoading] = useState(false);

  const scheduleReminder = async () => {
    setLoading(true);
    try {
      // First, cancel any existing notifications for this supplement to avoid duplicates
      await Notifications.cancelAllScheduledNotificationsAsync(); 

      const notificationId = await Notifications.scheduleNotificationAsync({
        content: {
          title: "Supplement Reminder!",
          body: `Time to take your ${supplementName}.`,
          sound: 'default', // Plays the default notification sound
        },
        trigger: {
          hour: 9, // 9 AM
          minute: 0,
          repeats: true, // Repeat this notification daily
        },
      });
      console.log('Scheduled notification with ID:', notificationId);
      Alert.alert('Reminder Set', `You will be reminded to take ${supplementName} every day at 9:00 AM.`);
    } catch (error) {
      console.error('Error scheduling notification:', error);
      Alert.alert('Error', 'Could not set reminder.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>Daily Reminder</Text>
      <TouchableOpacity
        // Use the new style from the global stylesheet
        style={[styles.button, styles.reminderButton]}
        onPress={scheduleReminder}
        disabled={loading}
      >
        <Text style={styles.buttonText}>{loading ? 'Setting...' : 'Remind Me Daily at 9 AM'}</Text>
      </TouchableOpacity>
    </View>
  );
};

export default ReminderComponent;
