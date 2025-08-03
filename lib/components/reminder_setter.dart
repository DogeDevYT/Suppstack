import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

final supabase = Supabase.instance.client;

class ReminderSetter extends StatefulWidget {
  final String supplementName;

  const ReminderSetter({Key? key, required this.supplementName}) : super(key: key);

  @override
  _ReminderSetterState createState() => _ReminderSetterState();
}

class _ReminderSetterState extends State<ReminderSetter> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveReminder() async {
    if (_selectedDay == null) {
      _showSnackBar('Please select a day for the reminder.', isError: true);
      return;
    }
    setState(() => _isLoading = true);

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not logged in.';

      // Combine the selected date and time
      final remindAt = DateTime(
        _selectedDay!.year,
        _selectedDay!.month,
        _selectedDay!.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Fetch the user's FCM token from their profile
      final profileResponse = await supabase
          .from('profiles')
          .select('fcm_token')
          .eq('id', userId)
          .single();

      final fcmToken = profileResponse['fcm_token'];
      if (fcmToken == null) {
        throw 'FCM token not found. Please visit the profile page to enable notifications.';
      }

      // Insert the new reminder into the database
      await supabase.from('reminders').insert({
        'user_id': userId,
        'supplement_name': widget.supplementName,
        'remind_at': remindAt.toIso8601String(),
        'fcm_token': fcmToken,
      });

      _showSnackBar('Reminder saved successfully!', isError: false);
    } catch (error) {
      _showSnackBar('Error saving reminder: ${error.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  //TODO: Add Feature to schedule multiple reminders on multiple days, not just on one day at a specific time
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Set a Reminder', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _selectTime(context),
              icon: const Icon(Icons.alarm),
              label: Text('Remind me at: ${_selectedTime.format(context)}'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveReminder,
              child: Text(_isLoading ? 'Saving...' : 'Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
