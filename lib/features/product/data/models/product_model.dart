import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

/// Product model for data layer
@JsonSerializable()
class ProductModel {
  final String uuid;
  final String? code;
  final String name;
  @JsonKey(name: 'price_buy')
  final int priceBuy;
  @JsonKey(name: 'price_sale')
  final int priceSale;
  final int stock;
  final String unit;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  ProductModel({
    required this.uuid,
    required this.code,
    required this.name,
    required this.priceBuy,
    required this.priceSale,
    required this.stock,
    required this.unit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  /// Convert to domain entity
  Product toEntity() {
    return Product(
      uuid: uuid,
      code: code,
      name: name,
      priceBuy: priceBuy,
      priceSale: priceSale,
      stock: stock,
      unit: unit,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
    );
  }

  /// Create from domain entity
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      uuid: product.uuid,
      code: product.code,
      name: product.name,
      priceBuy: product.priceBuy,
      priceSale: product.priceSale,
      stock: product.stock,
      unit: product.unit,
      createdAt: product.createdAt.toIso8601String(),
      updatedAt: product.updatedAt.toIso8601String(),
    );
  }
}
