part of 'add_product_bloc.dart';

@freezed
class AddProductState with _$AddProductState {
  const factory AddProductState({
    @Default(Product()) Product product,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus status,
  }) = _AddProductState;
}
