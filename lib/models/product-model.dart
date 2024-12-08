// ignore_for_file: file_names

class ProductModel {
  final String productId;
  final String categoryId;
  final String productName;
  final String categoryName;
  final String price;
  final String searchName;
  final List<dynamic> productImages;
  final String productDescription;
  final dynamic createdAt;

  ProductModel({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.price,
    required this.searchName,
    required this.productImages,
    required this.productDescription,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'price': price,
      'searchName': searchName,
      'productImages': productImages,
      'productDescription': productDescription,
      'createdAt': createdAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['productId'] ?? '',
      categoryId: json['categoryId'] ?? '',
      productName: json['productName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      price: json['price']?.toString() ?? '0',
      searchName: json['searchName'] ?? '',
      productImages: (json['productImages'] as List<dynamic>?) ?? [],
      productDescription: json['productDescription'] ?? '',
      createdAt: json['createdAt'],
    );
  }
}
