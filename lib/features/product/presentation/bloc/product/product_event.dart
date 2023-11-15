part of 'product_bloc.dart';

@freezed
class ProductEvent with _$ProductEvent {
  const factory ProductEvent.getProduct({
    int? limit,
    int? skip,
  }) = _GetProductsEvent;

  const factory ProductEvent.checkIfNeedMoreData({
    @Default(0) int index,
  }) = _CheckIfNeedMoreDataEvent;
}
