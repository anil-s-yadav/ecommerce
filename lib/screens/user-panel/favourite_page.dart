import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/product-model.dart';
import '../../utils/app-constant.dart';

class FavouritePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  FavouritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Favorites",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
        backgroundColor: AppConstant.appMainColor,
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('favorites')
            .doc(user!.uid)
            .collection('userFavorites')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No favorites added yet.",
                style: TextStyle(fontSize: 18.0, color: Colors.grey[700]),
              ),
            );
          }

          List<ProductModel> favoriteProducts = snapshot.data!.docs
              .map((doc) =>
                  ProductModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();

          return ListView.builder(
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              ProductModel product = favoriteProducts[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: product.productImages.first,
                      fit: BoxFit.cover,
                      width: 70,
                      height: 70,
                      placeholder: (context, url) => ColoredBox(
                        color: Colors.white,
                        child: Center(child: CupertinoActivityIndicator()),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  title: Text(
                    product.productName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    "RS ${product.price}",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeFavorite(product.productId),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Remove a product from favorites
  Future<void> _removeFavorite(String productId) async {
    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(user!.uid)
        .collection('userFavorites')
        .doc(productId)
        .delete();

    print("Product removed from favorites.");
  }
}
