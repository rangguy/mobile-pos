import 'package:json_annotation/json_annotation.dart';

part 'product_request_model.g.dart';

/// Product request model for create/update operations
@JsonSerializable()
class ProductRequestModel {
  final String code;
  final String name;
  @JsonKey(name: 'price_buy')
  final double priceBuy;
  @JsonKey(name: 'price_sale')
  final double priceSale;
  final int stock;
  final String unit;

  ProductRequestModel({
    required this.code,
    required this.name,
    required this.priceBuy,
    required this.priceSale,
    required this.stock,
    required this.unit,
  });

  factory ProductRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ProductRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductRequestModelToJson(this);
}
