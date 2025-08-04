import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class UpdateDosageComponent extends StatefulWidget {
  final String stackItemId;
  final String? currentDosage;
  final NavigatorState navigation;

  const UpdateDosageComponent({
    Key? key,
    required this.stackItemId,
    this.currentDosage,
    required this.navigation,
  }) : super(key: key);

  @override
  _UpdateDosageComponentState createState() => _UpdateDosageComponentState();
}

class _UpdateDosageComponentState extends State<UpdateDosageComponent> {
  late final TextEditingController _dosageController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _dosageController = TextEditingController(text: widget.currentDosage);
  }

  Future<void> _updateDosage() async {
    setState(() => _isSaving = true);
    try {
      await supabase
          .from('user_stacks')
          .update({'dosage': _dosageController.text})
          .eq('id', widget.stackItemId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dosage updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // We don't navigate back here; the detail page stays open.
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating dosage: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Your Dosage', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _dosageController,
              decoration: const InputDecoration(
                labelText: 'e.g., 500mg, 1 capsule daily',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSaving ? null : _updateDosage,
              child: Text(_isSaving ? 'Saving...' : 'Save Dosage'),
            ),
          ],
        ),
      ),
    );
  }
}
