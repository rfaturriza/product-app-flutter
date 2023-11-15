import 'package:dartz/dartz.dart';
import 'package:test_brik/core/error/failures.dart';
import 'package:test_brik/features/product/data/models/product_model.codegen.dart';

abstract class ProductRemoteDataSource {
  Future<Either<Failure, ProductResponseModel>> getProducts(
    int? limit,
    int? skip,
  );

  Future<Either<Failure, ProductModel>> getProductByID(
    int id,
  );

  Future<Either<Failure, ProductResponseModel>> searchProduct(
    String query,
    int? limit,
    int? skip,
  );

  Future<Either<Failure, ProductModel>> createProduct(
     ProductModel product,
  );
}
