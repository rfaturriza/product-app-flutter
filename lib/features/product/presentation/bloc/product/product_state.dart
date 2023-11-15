part of 'product_bloc.dart';

@freezed
class ProductState with _$ProductState {
  const factory ProductState({
    List<Product>? products,
    Failure? failureProducts,
    @Default(emptyString) String search,
    @Default(false) bool isLoading,
    @Default(1) int page,
    @Default(false) bool hasReachedMax,
  }) = _ProductState;
}
