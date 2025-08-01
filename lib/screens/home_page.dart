import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Stack')),
      body: const Center(child: Text('Supplement list will go here.')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Supplement Page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}