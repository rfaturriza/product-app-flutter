import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:test_brik/features/product/domain/entities/product.codegen.dart';

import '../../../domain/usecase/create_product_usecase.dart';

part 'add_product_bloc.freezed.dart';

part 'add_product_event.dart';

part 'add_product_state.dart';

@injectable
class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final CreateProductUseCase createProduct;

  AddProductBloc(
    this.createProduct,
  ) : super(const AddProductState()) {
    on<_AddProductEvent>(_onAddProduct);
    on<_OnChangedEvent>(_onChanged);
  }

  void _onAddProduct(
      _AddProductEvent event,
    Emitter<AddProductState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await createProduct(
      CreateProductParams(
        product: state.product,
      ),
    );
    result.fold((l) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
      ));
    });
  }

  void _onChanged(
    _OnChangedEvent event,
    Emitter<AddProductState> emit,
  ) {
    final product = Product(
      title: event.title ?? state.product.title,
      price: event.price ?? state.product.price,
      description: event.description ?? state.product.description,
      discountPercentage: event.discountPercentage ?? state.product.discountPercentage,
      rating: event.rating ?? state.product.rating,
      stock: event.stock ?? state.product.stock,
      brand: event.brand ?? state.product.brand,
      category: event.category ?? state.product.category,
    );
    emit(state.copyWith(
      product: product,
      status: FormzSubmissionStatus.initial,
    ));
  }
}
