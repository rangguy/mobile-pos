part of 'product_bloc.dart';

/// Product events
@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.loadAll() = ProductEventLoadAll;

  const factory ProductEvent.searchByCode(String code) =
      ProductEventSearchByCode;

  const factory ProductEvent.create({
    String? code,
    required String name,
    required int priceBuy,
    required int priceSale,
    required int stock,
    required String unit,
  }) = ProductEventCreate;

  const factory ProductEvent.update({
    required String uuid,
    String? code,
    required String name,
    required int priceBuy,
    required int priceSale,
    required int stock,
    required String unit,
  }) = ProductEventUpdate;

  const factory ProductEvent.delete(String uuid) = ProductEventDelete;
}
