import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_all_products_usecase.dart';
import '../../domain/usecases/get_product_by_code_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';
part 'product_bloc.freezed.dart';

/// Product BLoC
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  final GetProductByCodeUseCase getProductByCodeUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductBloc({
    required this.getAllProductsUseCase,
    required this.getProductByCodeUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(const ProductState.initial()) {
    on<ProductEventLoadAll>(_onLoadAll);
    on<ProductEventSearchByCode>(_onSearchByCode);
    on<ProductEventCreate>(_onCreate);
    on<ProductEventUpdate>(_onUpdate);
    on<ProductEventDelete>(_onDelete);
  }

  Future<void> _onLoadAll(
    ProductEventLoadAll event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());

    final result = await getAllProductsUseCase(NoParams());

    result.fold(
      (failure) => emit(ProductState.error(failure.toString())),
      (products) => emit(ProductState.loaded(products)),
    );
  }

  Future<void> _onSearchByCode(
    ProductEventSearchByCode event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());

    final result = await getProductByCodeUseCase(
      ProductCodeParams(event.code),
    );

    result.fold(
      (failure) => emit(ProductState.error(failure.toString())),
      (product) => emit(ProductState.productFound(product)),
    );
  }

  Future<void> _onCreate(
    ProductEventCreate event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());

    final result = await createProductUseCase(
      CreateProductParams(
        code: event.code,
        name: event.name,
        priceBuy: event.priceBuy,
        priceSale: event.priceSale,
        stock: event.stock,
        unit: event.unit,
      ),
    );

    result.fold(
      (failure) => emit(ProductState.error(failure.toString())),
      (product) => emit(ProductState.operationSuccess(
        'Product created successfully',
        product,
      )),
    );
  }

  Future<void> _onUpdate(
    ProductEventUpdate event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());

    final result = await updateProductUseCase(
      UpdateProductParams(
        uuid: event.uuid,
        code: event.code,
        name: event.name,
        priceBuy: event.priceBuy,
        priceSale: event.priceSale,
        stock: event.stock,
        unit: event.unit,
      ),
    );

    result.fold(
      (failure) => emit(ProductState.error(failure.toString())),
      (product) => emit(ProductState.operationSuccess(
        'Product updated successfully',
        product,
      )),
    );
  }

  Future<void> _onDelete(
    ProductEventDelete event,
    Emitter<ProductState> emit,
  ) async {
    emit(const ProductState.loading());

    final result = await deleteProductUseCase(
      DeleteProductParams(event.uuid),
    );

    result.fold(
      (failure) => emit(ProductState.error(failure.toString())),
      (_) => emit(
          const ProductState.deleteSuccess('Product deleted successfully')),
    );
  }
}
