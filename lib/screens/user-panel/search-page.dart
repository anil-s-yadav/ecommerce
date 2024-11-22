import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchItemPage extends StatefulWidget {
  const SearchItemPage({super.key});

  @override
  State<SearchItemPage> createState() => _SearchItemPageState();
}

class _SearchItemPageState extends State<SearchItemPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase(); // Normalize search query
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = "";
              });
            },
          ),
        ],
      ),
      body: _searchQuery.isEmpty
          ? const Center(
              child: Text('Search for items by name'),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('searchName', isGreaterThanOrEqualTo: _searchQuery)
                  .where('searchName', isLessThan: _searchQuery + '\uf8ff')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No items found.'));
                }

                final results = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final productData =
                        results[index].data() as Map<String, dynamic>;

                    return ListTile(
                      leading: productData['productImages'] != null &&
                              productData['productImages'].isNotEmpty
                          ? Image.network(
                              productData['productImages'][0],
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            )
                          : const Icon(Icons.image_not_supported),
                      title: Text(productData['productName'] ?? 'No Name'),
                      subtitle: Text("Price: ${productData['price']}"),
                      onTap: () {
                        // Navigate to product details if needed
                        print('Tapped on ${productData['productName']}');
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
