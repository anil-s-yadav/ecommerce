// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../models/product-model.dart';
import '../screens/user-panel/product-deatils-screen.dart';

class AllProductsWidget extends StatelessWidget {
  const AllProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('products').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height / 5,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No products found!"),
          );
        }

        if (snapshot.data != null) {
          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 0.80,
            ),
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              ProductModel productModel = ProductModel(
                productId: productData['productId'],
                categoryId: productData['categoryId'],
                productName: productData['productName'],
                categoryName: productData['categoryName'],
                price: productData['price'],
                productImages: productData['productImages'],
                productDescription: productData['productDescription'],
                createdAt: productData['createdAt'],
              );

              return Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(
                        () => ProductDetailsScreen(productModel: productModel)),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        child: FillImageCard(
                          borderRadius: 5.0,
                          width: Get.width / 2.5,
                          heightImage: Get.height / 6,
                          imageProvider: CachedNetworkImageProvider(
                            productModel.productImages[0],
                          ),
                          title: Center(
                            child: Text(
                              productModel.productName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                          footer: Center(
                            child: Text("Rs " + productModel.price),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }

        return Container();
      },
    );
  }
}