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
  // --- KEY CHANGE: State now handles a date range ---
  DateTime _focusedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = false;

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

  // --- KEY CHANGE: Logic to save multiple reminders ---
  Future<void> _saveRemindersForRange() async {
    if (_rangeStart == null || _rangeEnd == null) {
      _showSnackBar('Please select a start and end day for the reminder range.', isError: true);
      return;
    }
    setState(() => _isLoading = true);

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw 'User not logged in.';

      final profileResponse = await supabase
          .from('profiles')
          .select('fcm_token')
          .eq('id', userId)
          .single();

      final fcmToken = profileResponse['fcm_token'];
      if (fcmToken == null) {
        throw 'FCM token not found. Please visit the profile page to enable notifications.';
      }

      // Create a list to hold all the new reminder objects
      final List<Map<String, dynamic>> remindersToInsert = [];
      
      // Loop from the start date to the end date
      for (var day = _rangeStart!; day.isBefore(_rangeEnd!.add(const Duration(days: 1))); day = day.add(const Duration(days: 1))) {
        final remindAt = DateTime(
          day.year,
          day.month,
          day.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        remindersToInsert.add({
          'user_id': userId,
          'supplement_name': widget.supplementName,
          'remind_at': remindAt.toIso8601String(),
          'fcm_token': fcmToken,
        });
      }
      
      // Perform a single bulk insert with all the reminders
      await supabase.from('reminders').insert(remindersToInsert);

      _showSnackBar('Reminders saved successfully for the selected range!', isError: false);
    } catch (error) {
      _showSnackBar('Error saving reminders: ${error.toString()}', isError: true);
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

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Set Reminders', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              // --- KEY CHANGE: Configure for range selection ---
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              rangeSelectionMode: RangeSelectionMode.toggledOn,
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _rangeStart = start;
                  _rangeEnd = end;
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
              onPressed: _isLoading ? null : _saveRemindersForRange,
              child: Text(_isLoading ? 'Saving...' : 'Save Reminders for Range'),
            ),
          ],
        ),
      ),
    );
  }
}
