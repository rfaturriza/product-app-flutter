import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/product.codegen.dart';
import '../../../domain/usecase/get_product_by_id_usecase.dart';

part 'detail_product_bloc.freezed.dart';

part 'detail_product_event.dart';

part 'detail_product_state.dart';

@injectable
class DetailProductBloc extends Bloc<DetailProductEvent, DetailProductState> {
  final GetProductByIdUseCase getProduct;

  DetailProductBloc(
    this.getProduct,
  ) : super(const DetailProductState()) {
    on<_GetProductEvent>(_onGetProduct);
  }

  void _onGetProduct(
    _GetProductEvent event,
    Emitter<DetailProductState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    final result = await getProduct(
      GetProductByIdParams(id: event.id),
    );
    result.fold((l) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.failure,
      ));
    }, (r) {
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        product: r,
      ));
    });
  }
}
