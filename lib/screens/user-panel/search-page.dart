import 'package:flutter/material.dart';

class SearchItemPage extends StatelessWidget {
  const SearchItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter action here
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Search results will appear here'),
      ),
    );
  }
}
