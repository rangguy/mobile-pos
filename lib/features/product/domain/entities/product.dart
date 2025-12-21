import 'package:equatable/equatable.dart';

/// Product entity
class Product extends Equatable {
  final String uuid;
  final String code;
  final String name;
  final double priceBuy;
  final double priceSale;
  final int stock;
  final String unit;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Product({
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

  @override
  List<Object?> get props => [
        uuid,
        code,
        name,
        priceBuy,
        priceSale,
        stock,
        unit,
        createdAt,
        updatedAt,
      ];
}
