part of 'add_product_bloc.dart';

@freezed
class AddProductEvent with _$AddProductEvent {
  const factory AddProductEvent.addProduct() = _AddProductEvent;

  const factory AddProductEvent.onChanged({
    String? title,
    String? description,
    int? price,
    double? discountPercentage,
    double? rating,
    int? stock,
    String? brand,
    String? category,
  }) = _OnChangedEvent;
}
