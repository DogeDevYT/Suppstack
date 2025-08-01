import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async'; // For debounce timer

final supabase = Supabase.instance.client;

class AddSupplementPage extends StatefulWidget {
  const AddSupplementPage({Key? key}) : super(key: key);

  @override
  _AddSupplementPageState createState() => _AddSupplementPageState();
}

class _AddSupplementPageState extends State<AddSupplementPage> {
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  bool _isAdding = false;
  Timer? _debounce;

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.length >= 3) {
        _searchSupplements(query);
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  Future<void> _searchSupplements(String query) async {
    setState(() => _isLoading = true);
    try {
      final data = await supabase
          .from('dsld_supplements')
          .select('"DSLD ID", "Product Name", "Brand Name"')
          .or('"Product Name".ilike.%$query%, "Brand Name".ilike.%$query%')
          .limit(25);
      if (mounted) {
        setState(() {
          _searchResults = List<Map<String, dynamic>>.from(data);
        });
      }
    } catch (error) {
      _showErrorSnackBar('Failed to search supplements: ${error.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _addSupplementToStack(String dsldId) async {
    if (_isAdding) return;
    setState(() => _isAdding = true);
    try {
      await supabase.rpc('add_dsld_supplement_to_stack', params: {
        'dsld_supplement_id': dsldId,
      });
      // This pop will trigger the .then() callback on the HomePage
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      _showErrorSnackBar('Failed to add supplement: ${error.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isAdding = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Supplement')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                labelText: 'Search the supplement database...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final supplement = _searchResults[index];
                  return ListTile(
                    title: Text(supplement['Product Name'] ?? 'No Name'),
                    subtitle: Text(supplement['Brand Name'] ?? 'No Brand'),
                    onTap: () => _addSupplementToStack(supplement['DSLD ID']),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
