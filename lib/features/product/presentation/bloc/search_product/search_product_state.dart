part of 'search_product_bloc.dart';

@freezed
class SearchProductState with _$SearchProductState {
  const factory SearchProductState({
    List<Product>? products,
    Failure? failureProducts,
    @Default(emptyString) String search,
    @Default(false) bool isLoading,
    @Default(1) int page,
    @Default(false) bool hasReachedMax,
  }) = _SearchProductState;
}
