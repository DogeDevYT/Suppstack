import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../components/reminder_setter.dart';
import '../components/update_dosage_component.dart';
import '../components/image_uploader.dart';
import 'package:flutter/cupertino.dart';

final supabase = Supabase.instance.client;

class SupplementDetailPage extends StatefulWidget {
  final String stackItemId;
  final String supplementId;

  const SupplementDetailPage({
    Key? key,
    required this.stackItemId,
    required this.supplementId,
  }) : super(key: key);

  @override
  _SupplementDetailPageState createState() => _SupplementDetailPageState();
}

class _SupplementDetailPageState extends State<SupplementDetailPage> {
  late Future<Map<String, dynamic>> _supplementFuture;

  @override
  void initState() {
    super.initState();
    _supplementFuture = _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final supplementRes = await supabase
        .from('supplements')
        .select()
        .eq('id', widget.supplementId)
        .single();

    final stackItemRes = await supabase
        .from('user_stacks')
        .select()
        .eq('id', widget.stackItemId)
        .single();

    return {
      'supplement': supplementRes,
      'stackItem': stackItemRes,
    };
  }

  Future<void> _removeSupplement(String supplementName) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await supabase
          .from('reminders')
          .delete()
          .match({'user_id': userId, 'supplement_name': supplementName});

      await supabase.from('user_stacks').delete().eq('id', widget.stackItemId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Supplement and its reminders have been removed.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing supplement: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _supplementFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final supplement = snapshot.data!['supplement'];
          final stackItem = snapshot.data!['stackItem'];
          final supplementName = supplement['product_name'] ?? 'this supplement';
          final session = supabase.auth.currentSession;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                supplement['product_name'] ?? 'Unknown Supplement',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                supplement['brand_name'] ?? 'Unknown Brand',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(supplement['description'] ?? 'No description available.'),
              const Divider(height: 40),

              ImageUploader(
                stackItem: stackItem,
                session: session, // Add the session object
                onUpdate: () {    // Correct the parameter name to onUpdate
                  setState(() {
                    _supplementFuture = _fetchData();
                  });
                },
              ),
              UpdateDosageComponent(
                stackItemId: widget.stackItemId,
                currentDosage: stackItem['dosage'],
                navigation: Navigator.of(context),
              ),
              ReminderSetter(supplementName: supplementName),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _removeSupplement(supplementName),
                icon: const Icon(CupertinoIcons.delete),
                label: const Text('Remove from Stack'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}