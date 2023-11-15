import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/extension/string_ext.dart';
import '../../../domain/entities/product.codegen.dart';
import '../../../domain/usecase/get_products_usecase.dart';

part 'product_bloc.freezed.dart';

part 'product_event.dart';

part 'product_state.dart';

@injectable
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProducts;

  ProductBloc({
    required this.getProducts,
  }) : super(const ProductState()) {
    on<_GetProductsEvent>(_onGetProductsFetch);
    on<_CheckIfNeedMoreDataEvent>(_onCheckIfNeedMoreData);
  }

  void _onGetProductsFetch(
    _GetProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    const limit = 10;
    if (event.skip == 0) {
      emit(state.copyWith(
        products: [],
        hasReachedMax: false,
      ));
    }
    if (state.hasReachedMax) return;
    emit(state.copyWith(isLoading: true));
    final result = await getProducts(
      GetProductsParams(
        limit: limit,
        skip: event.skip ?? state.products?.length ?? 0,
      ),
    );
    result.fold((l) {
      emit(state.copyWith(
        isLoading: false,
        failureProducts: l,
      ));
    }, (r) {
      final resultProduct = r ?? [];
      final currentProduct = state.products;
      final products = currentProduct != null
          ? currentProduct + resultProduct
          : resultProduct;
      if ((resultProduct.length < limit)) {
        emit(state.copyWith(
          isLoading: false,
          hasReachedMax: true,
          failureProducts: null,
          products: event.skip == null ? products : resultProduct,
        ));
        return;
      }
      emit(state.copyWith(
        isLoading: false,
        products: event.skip == null ? products : resultProduct,
        failureProducts: null,
        hasReachedMax: false,
      ));
    });
  }

  void _onCheckIfNeedMoreData(
    _CheckIfNeedMoreDataEvent event,
    Emitter<ProductState> emit,
  ) {
    if (event.index == state.products!.length - 1) {
      add(const _GetProductsEvent());
    }
  }
}
