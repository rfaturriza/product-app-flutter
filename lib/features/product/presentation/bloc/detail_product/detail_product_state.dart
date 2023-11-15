part of 'detail_product_bloc.dart';

@freezed
class DetailProductState with _$DetailProductState {
  const factory DetailProductState({
    Product? product,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
  }) = _DetailProductState;
}

