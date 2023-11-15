import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:test_brik/features/product/domain/entities/product.codegen.dart';
import 'package:test_brik/features/product/domain/repositories/product_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class GetProductsUseCase implements UseCase<List<Product>?, GetProductsParams> {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>?>> call(GetProductsParams params) async {
    return await repository.getProducts(params.limit, params.skip);
  }
}

class GetProductsParams extends Equatable {
  final int? limit;
  final int? skip;

  const GetProductsParams({this.limit, this.skip});

  @override
  List<Object?> get props => [limit, skip];
}
