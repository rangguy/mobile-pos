import 'package:json_annotation/json_annotation.dart';
import 'product_model.dart';

part 'product_response_model.g.dart';

/// Product response model
@JsonSerializable()
class ProductResponseModel {
  final String status;
  final String message;
  final dynamic data;

  ProductResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseModelToJson(this);

  /// Get single product from response
  ProductModel? get product {
    if (data is Map<String, dynamic>) {
      return ProductModel.fromJson(data as Map<String, dynamic>);
    }
    return null;
  }

  /// Get list of products from response
  List<ProductModel> get products {
    if (data is List) {
      return (data as List)
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
