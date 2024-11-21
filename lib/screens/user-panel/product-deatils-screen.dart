import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/cart-model.dart';
import '../../models/product-model.dart';
import '../../utils/app-constant.dart';

// ignore: must_be_immutable
class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailsScreen({super.key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  // Track whether the product is marked as favorite
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appTextColor),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          "Product Details",
          style: TextStyle(color: AppConstant.appTextColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Images Carousel
              Stack(
                children: [
                  CarouselSlider(
                    items: widget.productModel.productImages
                        .map(
                          (imageUrl) => ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              width: Get.width - 20,
                              placeholder: (context, url) => ColoredBox(
                                color: Colors.white,
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        )
                        .toList(),
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 1.5,
                      viewportFraction: 1,
                    ),
                  ),
                  // Favorite Icon
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => toggleFavorite(),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Product Name
              Text(
                widget.productModel.productName,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              // Product Price
              Text(
                "RS ${widget.productModel.price}",
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),

              // Category
              Text(
                "Category: ${widget.productModel.categoryName}",
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),

              // Product Description
              Text(
                "Description:",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                widget.productModel.productDescription,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),

      // Add to Cart Button at the Bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 50.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstant.appSecondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () async {
              await checkProductExistence(uId: user!.uid);
            },
            child: Text(
              "Add to Cart",
              style: TextStyle(color: AppConstant.appTextColor, fontSize: 16.0),
            ),
          ),
        ),
      ),
    );
  }

  // Toggle Favorite Status
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      addProductToFavorites();
    } else {
      removeProductFromFavorites();
    }
  }

  // Add Product to Favorites
  Future<void> addProductToFavorites() async {
    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(user!.uid)
        .collection('userFavorites')
        .doc(widget.productModel.productId)
        .set({
      'productId': widget.productModel.productId,
      'productName': widget.productModel.productName,
      'price': widget.productModel.price,
      'productImages': widget.productModel.productImages,
    });
    print("Product added to favorites");
  }

  // Remove Product from Favorites
  Future<void> removeProductFromFavorites() async {
    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(user!.uid)
        .collection('userFavorites')
        .doc(widget.productModel.productId)
        .delete();
    print("Product removed from favorites");
  }

  // Check Product Existence in Cart
  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice =
          double.parse(widget.productModel.price) * updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });

      print("Product exists. Quantity updated.");
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set({
        'uId': uId,
        'createdAt': DateTime.now(),
      });

      CartModel cartModel = CartModel(
        productId: widget.productModel.productId,
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        price: widget.productModel.price,
        productImages: widget.productModel.productImages,
        productDescription: widget.productModel.productDescription,
        productQuantity: 1,
        productTotalPrice: double.parse(widget.productModel.price),
      );

      await documentReference.set(cartModel.toMap());

      print("Product added to cart.");
    }
  }
}
