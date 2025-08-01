import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// You will need to create these components
// import '../components/dosage_editor.dart';
// import '../components/image_uploader.dart';
// import '../components/reminder_setter.dart';

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
  late final Future<Map<String, dynamic>> _supplementFuture;

  @override
  void initState() {
    super.initState();
    _supplementFuture = _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    // Fetch both the general supplement info and the user's specific stack info
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
              
              // Here you would add your custom components
              // DosageEditor(stackItem: stackItem),
              // ImageUploader(stackItem: stackItem),
              // ReminderSetter(supplementName: supplement['product_name']),
              
              const Text('Dosage, Image, and Reminder components will go here.'),
            ],
          );
        },
      ),
    );
  }
}
