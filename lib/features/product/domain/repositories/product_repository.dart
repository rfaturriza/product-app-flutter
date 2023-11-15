import 'package:dartz/dartz.dart';
import 'package:test_brik/features/product/domain/entities/product.codegen.dart';

import '../../../../core/error/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure,List<Product> >> getProducts(
    int? limit,
    int? skip,
  );
  Future<Either<Failure, Product?>> getProductByID(
    int id,
  );
  Future<Either<Failure,List<Product> >> searchProduct(
    String query,
    int? limit,
    int? skip,
  );
  Future<Either<Failure, Product?>> createProduct(
     Product product,
  );
}