import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_supplement_page.dart';
import 'supplement_detail_page.dart';

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
    setState(() => _isLoading = true);
    try {
      final data = await supabase
          .from('user_stacks')
          .select('*, supplements(*)') // Use a join to get supplement details
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching stack: ${error.toString()}'), backgroundColor: Colors.red),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  // --- New Function: Handle removing a supplement ---
  Future<void> _removeSupplement(String stackItemId) async {
    try {
      await supabase.from('user_stacks').delete().eq('id', stackItemId);
      // Optimistically remove the item from the local list for a faster UI response
      setState(() {
        _stackItems?.removeWhere((item) => item['id'] == stackItemId);
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing supplement: ${error.toString()}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Stack')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stackItems!.isEmpty
              ? const Center(child: Text('Your stack is empty. Add a supplement to get started!'))
              : ListView.builder(
                  itemCount: _stackItems!.length,
                  itemBuilder: (context, index) {
                    final item = _stackItems![index];
                    final supplement = item['supplements'];
                    
                    // --- KEY CHANGE: Wrap ListTile in a Dismissible widget ---
                    return Dismissible(
                      key: Key(item['id']), // Each item needs a unique key
                      direction: DismissDirection.endToStart, // Allow swiping from right to left
                      onDismissed: (direction) {
                        _removeSupplement(item['id']);
                      },
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: ListTile(
                        title: Text(supplement['product_name'] ?? 'Unknown Supplement'),
                        subtitle: Text(supplement['brand_name'] ?? 'Unknown Brand'),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SupplementDetailPage(
                                stackItemId: item['id'],
                                supplementId: supplement['id'],
                              ),
                            ),
                          ).then((_) => _fetchStack()); // Refetch when returning from detail page
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddSupplementPage()),
          ).then((_) => _fetchStack());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
