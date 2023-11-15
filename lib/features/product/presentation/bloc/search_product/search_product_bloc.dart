import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/extension/string_ext.dart';
import '../../../domain/entities/product.codegen.dart';
import '../../../domain/usecase/get_product_by_search_usecase.dart';

part 'search_product_bloc.freezed.dart';

part 'search_product_event.dart';

part 'search_product_state.dart';

@injectable
class SearchProductBloc extends Bloc<SearchProductEvent, SearchProductState> {
  final GetProductBySearchUseCase getProductBySearch;

  SearchProductBloc({
    required this.getProductBySearch,
  }) : super(const SearchProductState()) {
    on<_SearchProductEvent>(_onSearchProductFetch);
    on<_CheckIfNeedMoreDataEvent>(_onCheckIfNeedMoreData);
  }

  void _onCheckIfNeedMoreData(
    _CheckIfNeedMoreDataEvent event,
    Emitter<SearchProductState> emit,
  ) {
    if (event.index == state.products!.length - 1) {
      add(const _SearchProductEvent());
    }
  }

  void _onSearchProductFetch(
    _SearchProductEvent event,
    Emitter<SearchProductState> emit,
  ) async {
    const limit = 10;
    if (event.skip == 0) {
      emit(state.copyWith(
        products: [],
        hasReachedMax: false,
      ));
    }
    if (state.hasReachedMax) return;
    emit(state.copyWith(isLoading: true,search: event.query));
    final result = await getProductBySearch(
      GetProductBySearchParams(
        query: event.query,
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
          products: event.skip == null ? products : resultProduct,
        ));
        return;
      }
      emit(state.copyWith(
        isLoading: false,
        products: event.skip == null ? products : resultProduct,
        hasReachedMax: false,
      ));
    });
  }
}
