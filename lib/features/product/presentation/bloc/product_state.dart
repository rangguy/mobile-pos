part of 'product_bloc.dart';

/// Product states
@freezed
class ProductState with _$ProductState {
  const factory ProductState.initial() = ProductStateInitial;
  const factory ProductState.loading() = ProductStateLoading;
  const factory ProductState.loaded(List<Product> products) =
      ProductStateLoaded;
  const factory ProductState.productFound(Product product) =
      ProductStateProductFound;
  const factory ProductState.operationSuccess(String message, Product product) =
      ProductStateOperationSuccess;
  const factory ProductState.deleteSuccess(String message) =
      ProductStateDeleteSuccess;
  const factory ProductState.error(String message) = ProductStateError;
}
