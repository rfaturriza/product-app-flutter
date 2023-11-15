import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:test_brik/core/error/failures.dart';
import 'package:test_brik/features/product/data/datasources/remote/product_remote_data_source.dart';
import 'package:test_brik/features/product/domain/entities/product.codegen.dart';

import '../../domain/repositories/product_repository.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  const ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Product?>> createProduct(Product product) async {
    final productModel = product.toModel();
    final result = await remoteDataSource.createProduct(productModel);
    return result.fold(
      (error) => left(error),
      (r) => right(
        r.toEntity(),
      ),
    );
  }

  @override
  Future<Either<Failure, Product?>> getProductByID(int id) async {
    final result = await remoteDataSource.getProductByID(id);
    return result.fold(
      (error) => left(error),
      (r) => right(
        r.toEntity(),
      ),
    );
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts(
    int? limit,
    int? skip,
  ) async {
    final result = await remoteDataSource.getProducts(limit, skip);
    return result.fold(
      (error) => left(error),
      (r) => right(r.toEntity()),
    );
  }

  @override
  Future<Either<Failure, List<Product>>> searchProduct(
    String query,
    int? limit,
    int? skip,
  ) async {
    final result = await remoteDataSource.searchProduct(query, limit, skip);
    return result.fold(
      (error) => left(error),
      (r) => right(r.toEntity()),
    );
  }
}
