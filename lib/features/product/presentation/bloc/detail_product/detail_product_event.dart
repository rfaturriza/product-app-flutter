part of 'detail_product_bloc.dart';

@freezed
class DetailProductEvent with _$DetailProductEvent {
  const factory DetailProductEvent.getProduct({
    required int id,
  }) = _GetProductEvent;
}
