import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_supplement_page.dart';
import 'supplement_detail_page.dart';
import '../components/supplement_card.dart';
import 'package:flutter/cupertino.dart';

final supabase = Supabase.instance.client;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>>? _stackItems;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStack();
  }

  Future<void> _fetchStack() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final data = await supabase
          .from('user_stacks')
          .select('*, supplements(*)')
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('created_at', ascending: true);
      
      if (mounted) {
        setState(() {
          _stackItems = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        _showErrorSnackBar('Error fetching stack: ${error.toString()}');
        setState(() => _isLoading = false);
      }
    }
  }

  // --- New Function: Handle toggling the taken status ---
  Future<void> _toggleSupplementTaken(String stackItemId, bool isTaken) async {
    try {
      // If the supplement is being marked as "taken", set the timestamp to now.
      // If it's being "un-taken", set it to null.
      final newTimestamp = isTaken ? DateTime.now().toIso8601String() : null;

      await supabase
          .from('user_stacks')
          .update({'last_taken_at': newTimestamp})
          .eq('id', stackItemId);

      // Update the local state immediately for a responsive UI
      setState(() {
        final index = _stackItems?.indexWhere((item) => item['id'] == stackItemId);
        if (index != null && index != -1) {
          _stackItems?[index]['last_taken_at'] = newTimestamp;
        }
      });

    } catch (error) {
      _showErrorSnackBar('Error updating supplement: ${error.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Helper function to check if a supplement was taken today
  bool _isTakenToday(String? timestamp) {
    if (timestamp == null) return false;
    final lastTakenDate = DateTime.parse(timestamp).toLocal();
    final now = DateTime.now();
    return lastTakenDate.year == now.year &&
           lastTakenDate.month == now.month &&
           lastTakenDate.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Daily Stack')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stackItems!.isEmpty
              ? const Center(child: Text('Your stack is empty. Add a supplement!'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _stackItems!.length,
                  itemBuilder: (context, index) {
                    final item = _stackItems![index];
                    final supplement = item['supplements'];
                    final isTaken = _isTakenToday(item['last_taken_at']);

                    return SupplementCard(
                      brandName: supplement['brand_name'] ?? 'Unknown Brand',
                      productName: supplement['product_name'] ?? 'Unknown Supplement',
                      dosage: item['dosage'],
                      isTaken: isTaken,
                      onCardTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SupplementDetailPage(
                              stackItemId: item['id'],
                              supplementId: supplement['id'],
                            ),
                          ),
                        ).then((_) => _fetchStack());
                      },
                      onToggleTaken: (bool? newValue) {
                        if (newValue != null) {
                          _toggleSupplementTaken(item['id'], newValue);
                        }
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddSupplementPage()),
          ).then((_) => _fetchStack());
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
