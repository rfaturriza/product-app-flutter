import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:test_brik/features/product/domain/entities/product.codegen.dart';
import 'package:test_brik/features/product/domain/repositories/product_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

@injectable
class GetProductBySearchUseCase implements UseCase<List<Product>?, GetProductBySearchParams> {
  final ProductRepository repository;

  GetProductBySearchUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>?>> call(GetProductBySearchParams params) async {
    return await repository.searchProduct(params.query, params.limit, params.skip);
  }
}

class GetProductBySearchParams extends Equatable {
  final int? limit;
  final int? skip;
  final String query;

  const GetProductBySearchParams({this.limit, this.skip, required this.query});

  @override
  List<Object?> get props => [limit, skip, query];
}
