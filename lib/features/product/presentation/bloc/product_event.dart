part of 'product_bloc.dart';

/// Product events
@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.loadAll() = ProductEventLoadAll;

  const factory ProductEvent.searchByCode(String code) =
      ProductEventSearchByCode;

  const factory ProductEvent.create({
    required String code,
    required String name,
    required double priceBuy,
    required double priceSale,
    required int stock,
    required String unit,
  }) = ProductEventCreate;

  const factory ProductEvent.update({
    required String uuid,
    required String code,
    required String name,
    required double priceBuy,
    required double priceSale,
    required int stock,
    required String unit,
  }) = ProductEventUpdate;

  const factory ProductEvent.delete(String uuid) = ProductEventDelete;
}
