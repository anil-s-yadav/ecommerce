// ignore_for_file: file_names

class CartModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String price;
  final List productImages;
  final String productDescription;

  final int productQuantity;
  final double productTotalPrice;

  CartModel({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.price,
    required this.productImages,
    required this.productDescription,
    required this.productQuantity,
    required this.productTotalPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'price': price,
      'productImages': productImages,
      'productDescription': productDescription,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
      productId: json['productId'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      price: json['price'],
      productImages: json['productImages'],
      productDescription: json['productDescription'],
      productQuantity: json['productQuantity'],
      productTotalPrice: json['productTotalPrice'],
    );
  }
}
