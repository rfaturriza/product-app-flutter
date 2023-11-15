import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:test_brik/features/product/domain/entities/product.codegen.dart';
import 'package:test_brik/features/product/domain/repositories/product_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class GetProductByIdUseCase implements UseCase<Product?, GetProductByIdParams> {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Product?>> call(GetProductByIdParams params) async {
    return await repository.getProductByID(params.id);
  }
}

class GetProductByIdParams extends Equatable {
  final int id;

  const GetProductByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}
